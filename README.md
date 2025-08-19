# Dwarf Fortress Mod Template

A template for developing Dwarf Fortress mods with modern development Luau types, and sanity.

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
├── .vscode/           # VS Code workspace pre-configured settings
│   ├── settings.json  # Recommended Luau Language Server settings
│   └── tasks.json     # Easy task execution
├── graphics/          # Custom graphics RAW assets
├── modules/           # Shared Luau modules
├── objects/           # Custom object RAW assets
├── scripts/           # Lua scripts, build system reserved
├── src/               # Custom Luau + Lua files
│   └── init.lua       # Entry point example source
├── .darklua.json5     # DarkLua development configuration
├── .darklua.prod.json # DarkLua production configuration
├── .lua-format        # lua-format formatter config
├── .luarc.json        # Luau configuration
├── info.txt           # Mod RAW project file
├── log.sh             # Enhanced logging utility
├── mod.d.luau         # Global type definitions
└── stylua.toml        # StyLua formatter config
```

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

1. Clone this repository to your Dwarf Fortress mods directory
   ```bash
   git clone https://github.com/tilkinsc/dwarf-fortress-mod-template.git/
   ```
2. Make `log.sh` executable (if necessary):
   ```bash
   chmod +x log.sh
   ```

## Development

### Build Process

This project uses DarkLua to process Luau code into Lua compatible with Dwarf Fortress.

#### Development Build

```bash
# Build all files (debug)
darklua process src/ output/
```
See also: Ctrl+P >Tasks: Run Task > Build all files (debug)

```bash
# Build all files (production)
darklua process src/ output/ --config darklua.prod.json
```
See also: Ctrl+P >Tasks: Run Task > Build all files (production)

```bash
# Watch for changes and build (recommended during development)
darklua process src/ output/ --watch
```
See also: Ctrl+P >Tasks: Run Task > Watch for changes and build


#### Production Build

```bash
darklua process src/ output/ --config darklua.production.json
```

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

```lua
declare _G: {
    DEBUG: boolean,
    -- Add global type definitions here
}
```

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

## Production Deployment

1. Build your mod:
   ```bash
   ./darklua process src/ output/ --config darklua.production.json
   ```

2. Package the `output/` directory with your mod assets

## License

[Your License Here]

## Contributing

[Your contribution guidelines here]
