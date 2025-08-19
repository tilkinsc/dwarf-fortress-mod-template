# Dwarf Fortress Mod Template

A template for developing Dwarf Fortress mods for modern development with Luau types, and sanity.

## Features

- 🏗️ **Structured Project Layout**
- 🔄 **Automated Build Process**
- 📚 **Optimizations**
- ⚙️ **Luau Transpilation**
- 🔍 **Enhanced Logging**
- 🧪 **Type Safety**

## Project Structure

```
./mod-template/
├── .vscode/            # VS Code workspace pre-configured settings
│   ├── settings.json   # Recommended Luau Language Server settings
│   └── tasks.json      # Easy task execution
├── graphics/           # Custom graphics RAW assets
├── modules/            # Shared Luau modules
├── objects/            # Custom object RAW assets
├── scripts/            # Lua scripts, Dwarf Fortress executes these
├── src/                # Custom Luau + Lua files
│   └── init.lua        # Entry point example source
├── .darklua.json5      # DarkLua development configuration
├── .darklua.prod.json5 # DarkLua production configuration
├── .lua-format         # lua-format formatter config
├── .luaurc             # Luau configuration
├── info.txt            # Mod RAW project file
├── log.sh              # Enhanced logging utility
├── mod.d.luau          # Global type definitions
└── stylua.toml         # StyLua formatter config
```

## Summary

This template was created because I wanted to develop Dwarf Fortress mods, but I can't be caught dead without types. Using darklua, I was able to write Luau code, and then transpile it to Lua code that is compatible with Dwarf Fortress. I also added some features to make development easier, such as a logging utility which dumps script/game output to a single local log file and the console. For those who actually like formatters, I've included StyLua and lua-format. Because Dwarf Fortress hasn't declared documentation, I have prepared mod.d.luau, which provides type definitions for the important game's globals. Darklua also seems to double as a preprocessor in a way, so I took the liberty of writing a development and production configuration that exposes a DEBUG variable, which can be used for code elimination.

### Why Luau?

Luau brings type checking, better intellisense, the continue keyword, and this should be enough for you to justify using it.

## Getting Started

### Prerequisites

- [Dwarf Fortress](https://store.steampowered.com/app/975370/Dwarf_Fortress/) (Preconfigured for Steam Version)
- [DarkLua](https://github.com/seaofvoices/darklua) <small>[[1](#footnote-1)]</small>
- [Git](https://git-scm.com/downloads)

Optional, but highly recommended:
- Visual Studio Code (fork or official)
- [Luau Language Server](vscode:extension/JohnnyMorganz.luau-lsp) <small>[[2](#footnote-2)]</small>

<small id="footnote-1">[1]</small>: DarkLua has a prebuilt binary for Linux and Windows, or you can build it using Rust  
<small id="footnote-2">[2]</small>: You can use any editor, but you will need to configure [Luau Language Server](https://github.com/JohnnyMorganz/luau-lsp) yourself  

### Setup

You can clone this repository manually and remove the git history.
```bash
git clone https://github.com/tilkinsc/dwarf-fortress-mod-template.git/ my_first_mod
cd my_first_mod
rm .git
git init
```

Or, you can click the 'Use this template' button and clone your new repo.

You may need to `chmod +x log.sh`

## Development

### Build Process

This project uses DarkLua to process and bundle Luau code into Lua compatible with Dwarf Fortress.

```bash
# Build all files (debug)
darklua process src/ scripts/
```
See also: Ctrl+P >Tasks: Run Task > Build all files (debug)

```bash
# Build all files (production)
darklua process src/ scripts/ -c darklua.prod.json
```
See also: Ctrl+P >Tasks: Run Task > Build all files (production)

```bash
# Watch for changes and build (recommended during development)
darklua process src/ scripts/ -w
```
See also: Ctrl+P >Tasks: Run Task > Watch for changes and build

### Debugging

The `log.sh` script provides enhanced logging capabilities:

```bash
# Start the log viewer
./log.sh
```

**Log Viewer Features:**
- Combines game logs (`gamelog.txt`) and Lua logs (`lualog.txt`)
- Adds timestamps to all entries
- Tracks and displays repeated log entries
- Saves logs to `lualog.log`

## Type System

### Global Type Definitions

`mod.d.luau` provides type definitions for Dwarf Fortress globals:

This enables:
- Type checking for Dwarf Fortress globals
- Better IDE support and autocompletion
- Early detection of type-related issues

## VS Code Integration

This workspace includes configuration for:
- Luau language server
- Type checking
- Code formatting
- Debugging support

## Dump the Environment

While my mod.d.luau is pretty good, it's not complete. Why? Because there are too many globals injected at one time. I exported the ones that are intended for use out of the lua files. However, you should definitely dump the environment because there are some functions you could probably use.

You might want to use `./log.sh` so you can analyze the output easily.

```lua
type Map<K, V> = {[K]: V};
type AnyMap = Map<any, any>;
type Dict<V> = {[string]: V};
type Action = () -> void;
type Func<TResult> = () -> TResult;
type void = nil;

log(_VERSION) -- Lua 5.4

local function recursive_log(tbl: AnyMap, level: number?, prefix: string?, max_depth: number?)
    local visited: AnyMap = {}
    local function recurse(tbl: AnyMap, level: number?, prefix: string?, max_depth: number?)
        local _level = level or 0
        local _prefix = prefix or ""
        local _max_depth = max_depth or math.huge
        local n = 0
        for _ in next, tbl do n = n + 1 end
        local count = 0
        for k, v in next, tbl do
            if (_G == v or v == _G.package or k == "preload") then
                continue
            end
            local found = false
            for _, l in next, visited do
                if l == v then found = true; break end
            end
            if found then continue end
            table.insert(visited, v :: any)
            count = count + 1
            local is_last = (count == n)
            local connector = is_last and "└─" or "├─"
            log(_prefix .. connector .. k, v)
            if type(v) == "table" and _level < _max_depth then
                local new_prefix = tostring(_prefix) .. (is_last and "  " or "│ ")
                recurse(v :: AnyMap, _level + 1, new_prefix, _max_depth)
            end
        end
    end
    recurse(tbl, level, prefix, max_depth)
end

recursive_log(_G)
```
