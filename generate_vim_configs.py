#! /usr/bin/env python

import argparse
import json
import os
import re
from collections import ChainMap
from pathlib import PurePath

from jinja2 import Environment, PackageLoader


env = Environment(loader=PackageLoader(__name__))

CUSTOM_DOTFILES_DIR = 'custom_dotfiles/'
CUSTOM_SETTINGS_DIR = 'custom_settings/'
DEFAULT_DOTFILES_DIR = 'default_dotfiles/'
DEFAULT_SETTINGS_DIR = 'default_settings/'


def _filter_writable_strategies(
        all_strategies, dotfile_names, update_default_dotfiles):

    def include(strategy):
        if dotfile_names is not None:
            result = strategy['name'] in dotfile_names
        elif update_default_dotfiles is True:
            result = True
        else:
            result = strategy['is_customized']
        return result

    return {
        strategy['name']: strategy
        for strategy
        in all_strategies.values()
        if include(strategy)
    }


def _parse_cli_inputs():
    parser = argparse.ArgumentParser(prog='Vim Dotfiles Generator')
    parser.add_argument('dotfile_names', nargs='?')
    parser.add_argument('-d', '--read-from-dir',
                        action='store_const', const=True)
    parser.add_argument('-n', '--dry-run',
                        action='store_const', const=True)
    parser.add_argument('-u', '--update-default-dotfiles',
                        action='store_const', const=True)
    args = parser.parse_args()

    both = args.dotfile_names and args.read_from_dir
    neither = (args.dotfile_names is None) and (args.read_from_dir is None)
    if neither or both:
        msg = "Provide a list of dotfiles OR else the -d/--read-from-dir flag"
        raise SystemExit(msg)

    dotfiles = args.dotfile_names.split(',') if args.dotfile_names else None

    return (dotfiles,
            args.dry_run,
            args.update_default_dotfiles)


def _populate_strategies(defaults_only=False):
    plugin_settings = _read_settings('plugins', defaults_only)
    strategy_settings = _read_settings('strategies', defaults_only)

    def populate_strategy(strategy, plugins):
        strategy['plugin_settings'] = [
            plugins[name] for name in strategy.get('plugins', [])]
        strategy['plugin_settings'] += [
            plugins[name]
            for group in strategy.get('plugin_groups', [])
            for name in group.get('plugin_settings_files', [])
        ]
        # This is a little fugly - could be cleaned up
        strategy['plugin_settings_by_group'] = {
            group["name"]: [plugins[name]
                            for name
                            in group.get('plugin_settings_files', [])]
            for group in strategy.get('plugin_groups', [])
        }
        strategy['is_customized'] = (strategy['is_customized'] or any(
            [plugins[name]['is_customized']
                for name
                in strategy.get('plugins', [])])
        )

        return strategy

    populated_strategies = {
        name: populate_strategy(strategy_setting, plugin_settings)
        for name, strategy_setting in strategy_settings.items()
    }
    return populated_strategies


def _print_header(header_text):
    border = '#' * 60
    padded_s = f" {header_text} ".center(60, '#')
    print(f"{border}\n{padded_s}\n{border}")


def _read_settings(sub_dirname, defaults_only=False):
    settings_dir_names = [DEFAULT_SETTINGS_DIR] if defaults_only else [
        DEFAULT_SETTINGS_DIR, CUSTOM_SETTINGS_DIR]
    cm = ChainMap()

    for settings_dir_name in settings_dir_names:
        settings_dir = os.path.join(settings_dir_name, sub_dirname)
        settings = {}

        try:
            for file_name in os.listdir(settings_dir):
                with open(os.path.join(settings_dir, file_name), 'r') as f:
                    output = json.loads(f.read())
                key = re.sub(r'.json', '', file_name)
                settings[key] = output
                settings[key]['is_customized'] = (
                    settings_dir_name == CUSTOM_SETTINGS_DIR)
        except Exception as e:
            # Replace with logger
            print(f"WARNING: Could not read {settings_dir}")

        cm = cm.new_child(settings)

    return cm


def _render_files(strategies, is_dry_run=False, update_default_dotfiles=False):
    output_dir = (
        DEFAULT_DOTFILES_DIR
        if update_default_dotfiles else CUSTOM_DOTFILES_DIR)

    for strategy in strategies.values():
        filename = strategy['name']
        filename += '.vim' if not strategy['name'].endswith('.vim') else ''
        file_path = PurePath(output_dir, filename)

        body = env.get_template('config_template.j2').render(
            description=strategy['description'],
            plugin_settings_by_group=strategy['plugin_settings_by_group'],
            plugin_settings=strategy['plugin_settings'],
            repos=[plugin['repo'] for plugin in strategy['plugin_settings']],
            strategy=strategy)

        if is_dry_run:
            file_path_msg = f"Printing {file_path}"
            _print_header(file_path_msg)
            print(body)
        else:
            os.makedirs(output_dir, exist_ok=True)
            with open(file_path, 'w') as f:
                f.write(body)


if __name__ == "__main__":
    dotfile_names, dry_run, update_default_dotfiles = _parse_cli_inputs()
    all_strategies = _populate_strategies(update_default_dotfiles)
    strategies = _filter_writable_strategies(
        all_strategies,
        dotfile_names,
        update_default_dotfiles)
    _render_files(
        strategies,
        update_default_dotfiles=update_default_dotfiles,
        is_dry_run=dry_run)
