# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a WezTerm terminal emulator configuration written in Lua. WezTerm loads `wezterm.lua` automatically as its entry point.

## Architecture

The config is split into three modules, each exporting an `apply_to_config(config)` function that mutates the shared config table:

- **`wezterm.lua`** — Entry point. Sets global options (font, color scheme, cursor, window decorations), defines the `<leader>` key (`SHIFT+Space`), registers the `format-tab-title` event handler, and calls each module's `apply_to_config`.
- **`navigation.lua`** — Pane and tab movement keybinds (`CTRL+SHIFT+hjkl` for panes, `ALT+h/l` for tabs, `LEADER+h/l` to jump and zoom left/right panes).
- **`pane.lua`** — Pane splitting (`CTRL+SHIFT+:` horizontal, `CTRL+SHIFT+"` vertical) and a `resize_pane` key table activated by `LEADER+r` (then `hjkl` to resize, auto-exits after 500ms idle).
- **`workspace.lua`** — Workspace management: right-status bar showing all workspaces with the active one highlighted, `CTRL+SHIFT+w` to switch workspaces via a custom selector, `LEADER+w` to create a new named workspace.

## Key Design Patterns

- Modules append to `config.keys` and `config.key_tables` (pre-initialized as empty tables in `wezterm.lua`) — never replace them.
- The `update-status` event in `workspace.lua` sets a user var (`tabbar_refresh`) as a hack to force tab title re-renders, since WezTerm doesn't automatically refresh tab titles when workspace state changes.
- `status_update_interval = 100` (ms) drives both status bar and tab title refresh rate.

## Testing Changes

WezTerm hot-reloads the config on save. To validate changes:
1. Save the file — WezTerm will reload automatically.
2. Check the WezTerm debug overlay (`CTRL+SHIFT+L`) for Lua errors.
3. Reload manually if needed: `wezterm reload-configuration` or via the right-click menu.
