# Neovim Linux-to-Windows Migration: Comprehensive Research

> Research compiled: January 2026
> Sources: 2024-2025 blog posts, GitHub issues, Neovim Discourse, community guides

---

## Table of Contents

1. [General Setup Guides](#1-general-windows-setup-guides)
2. [User Migration Experiences](#2-user-migration-experiences-linux-to-windows)
3. [lazy.nvim on Windows](#3-lazynvim-windows-compatibility)
4. [telescope.nvim on Windows](#4-telescopenvim-windows-issues)
5. [Terminal Emulator Choices](#5-terminal-emulator-choices)
6. [WSL vs Native Windows](#6-wsl-vs-native-windows)
7. [Plugin Compatibility Issues](#7-plugin-compatibility-issues)
8. [Treesitter Compiler Setup](#8-treesitter-compiler-setup-on-windows)
9. [Package Manager Comparison](#9-windows-package-managers-for-neovim)
10. [mason.nvim LSP on Windows](#10-masonnvim-lsp-on-windows)
11. [Windows Defender / Antivirus](#11-windows-defender--antivirus-performance)
12. [Shell Configuration](#12-shell-configuration-powershell-vs-cmdexe)
13. [Clipboard Integration](#13-clipboard-integration)
14. [Decision Matrix](#14-decision-matrix-wsl-vs-native)

---

## 1. General Windows Setup Guides

### Common Consensus
Setting up Neovim on Windows is entirely feasible and has become significantly smoother in 2024-2025. The community generally recommends two paths: (a) WSL2 for a near-Linux experience, or (b) native Windows with careful dependency management.

### Essential Steps for Native Windows Setup
1. **Install a modern terminal** -- Windows Terminal, WezTerm, or Alacritty (do NOT use stock cmd.exe or legacy PowerShell for Neovim)
2. **Install a Nerd Font** -- Required for icon/glyph rendering in most configurations
3. **Install Neovim** -- via `winget install Neovim.Neovim`, `choco install neovim`, or `scoop install neovim`
4. **Install supporting tools** -- `git`, `ripgrep`, `fd`, a C compiler (zig/clang/gcc), `make`, `node`, `npm`
5. **Use a starter config** -- kickstart.nvim or LazyVim are the most popular
6. **Config location**: `%LOCALAPPDATA%\nvim` (i.e., `C:\Users\<USERNAME>\AppData\Local\nvim`)

### Key Sources
- [How to install and set up Neovim on Windows](https://blog.nikfp.com/how-to-install-and-set-up-neovim-on-windows) (Updated June 2025)
- [Neovim on Windows GitHub Guide](https://github.com/mattimustang/neovim-on-windows)
- [Setting Up Neovim on Windows -- Beginner Guide](https://medium.com/@adarshroy.formal/setting-up-neovim-on-windows-a-beginner-friendly-no-nonsense-guide-with-cpp-clangd-without-wsl-f792117466a0) (Nov 2024)
- [NeoVim from Scratch in 2025](https://medium.com/@edominguez.se/so-i-switched-to-neovim-in-2025-163b85aa0935) (April 2025)

---

## 2. User Migration Experiences (Linux to Windows)

### Common Consensus
Migrating a Linux Neovim config to Windows is **easier than most people expect**, but not friction-free.

### What Works Well
- **Cloning a Linux config to Windows works surprisingly well**: One author reported cloning their Ubuntu Neovim setup to Windows in "just a few minutes" and finding "the entire process was quite straightforward."
- **Lua configs are portable**: Because lazy.nvim uses `vim.fn.stdpath()` which auto-resolves to the right path on each OS, the bootstrap and plugin loading code is cross-platform.
- **Symlink approach**: Managing dotfiles with tools like `chezmoi` and creating symlinks from your dotfiles repo to `%LOCALAPPDATA%\nvim` is a well-established pattern.

### What Causes Problems
- **Path differences**: Linux uses `~/.config/nvim`, Windows uses `%LOCALAPPDATA%\nvim`
- **External tool dependencies**: Any plugin that shells out to Unix tools (grep, find, sed, etc.) will need Windows equivalents installed
- **Line endings**: `\r\n` vs `\n` can cause subtle issues (see Telescope section)
- **Shell assumption**: Many plugins assume `sh`/`bash` as the shell

### Key Sources
- [Share NeoVim configuration between Linux and Windows](https://dev.to/kaiwalter/share-neovim-configuration-between-linux-and-windows-4gh8)
- [Neovim, but it's in Windows](https://medium.com/nerd-for-tech/neovim-but-its-in-windows-f39f181afaf9)
- [Neovim configs and Windows - Neovim Discourse](https://neovim.discourse.group/t/neovim-configs-and-windows/4734)

---

## 3. lazy.nvim Windows Compatibility

### Common Consensus
**lazy.nvim is fully compatible with Windows.** The bootstrap code uses `vim.fn.stdpath("data")` which resolves correctly on all platforms. No Windows-specific modifications are needed for the plugin manager itself.

### Setup on Windows
```powershell
# LazyVim starter (PowerShell)
# Backup existing config
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
# Clone starter
git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim
Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force
```

### Problems Reported
- **Treesitter parser compilation** is the main friction point within LazyVim/lazy.nvim setups on Windows (requires a C compiler -- see Section 8)
- **Git must be in PATH** for the bootstrap to work
- **Some plugins with `build` steps** may fail if they assume Unix tooling

### Solutions
- Install Zig (`winget install zig.zig` or `scoop install zig`) as the treesitter compiler
- Ensure `git` is installed and in PATH before first launch
- For plugins with build steps, check if they support CMake as an alternative build method

### Key Sources
- [lazy.nvim Installation Docs](https://lazy.folke.io/installation)
- [LazyVim Installation](https://www.lazyvim.org/installation)
- [Set up Windows laptop with LazyVim as IDE](https://medium.com/@zh3w4ng/set-up-a-new-windows-laptop-as-a-dev-machine-w-lazyvim-as-ide-e8ed23770ce9)
- [Using lazy.nvim in VSCode on Windows](https://blog.bront.rodeo/using-lazy-nvim-in-vscode-on-windows/)

---

## 4. telescope.nvim Windows Issues

### Common Consensus
Telescope works on Windows but has several known issues that require workarounds.

### Problems Reported

| Issue | Description | Severity |
|-------|-------------|----------|
| `live_grep` returns 0 results | `rg` is in PATH and works from terminal, but Telescope shows nothing | High |
| `^M` appended to filenames | Windows line endings cause blank files to open | High |
| `oldfiles` broken with `$HOME` | If `HOME` env var is set, oldfiles opens blank buffers | Medium |
| `telescope-fzf-native` build fails | `cc` not found on Windows; needs MinGW/MSYS2 or CMake | Medium |
| Multiple warnings on startup | "The 'hidden' key is not available" warnings | Low |

### Solutions
1. **Install `ripgrep` and `fd`** and ensure they are on your PATH
2. **For `telescope-fzf-native.nvim`**: Use the CMake build option instead of make:
   ```lua
   {
     'nvim-telescope/telescope-fzf-native.nvim',
     build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
   }
   ```
   Or install MinGW/MSYS2 for `gcc`/`make`.
3. **Be cautious with `$HOME` env var** on Windows -- it can interfere with path resolution
4. **Run `:checkhealth telescope`** to verify all dependencies
5. **Keep Neovim up to date** -- requires Neovim >= 0.10.4

### Key Sources
- [live_grep not working on Windows - Issue #385](https://github.com/nvim-telescope/telescope.nvim/issues/385)
- [Telescope broken on Windows 10 - Issue #1144](https://github.com/nvim-telescope/telescope.nvim/issues/1144)
- [oldfiles broken with $HOME - Issue #2387](https://github.com/nvim-telescope/telescope.nvim/issues/2387)
- [telescope-fzf-native build failed on Windows - Issue #122](https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/122)
- [Multiple warnings on Windows - Issue #3333](https://github.com/nvim-telescope/telescope.nvim/issues/3333)

---

## 5. Terminal Emulator Choices

### Common Consensus
**Do NOT use stock cmd.exe or legacy PowerShell** as your Neovim host terminal. All three recommended options work well; the choice depends on your priorities.

### Comparison

| Feature | Windows Terminal | WezTerm | Alacritty |
|---------|-----------------|---------|-----------|
| **Speed** | Good | Good (enable WebGPU) | Fastest |
| **Config language** | JSON/GUI | Lua | TOML |
| **Tabs/Splits** | Yes | Yes | No (use tmux/WM) |
| **Nerd Font support** | Yes | Yes | Yes |
| **Ligatures** | Yes | Yes | No |
| **Undercurl** | Partial | Yes | Experimental |
| **Cross-platform** | Windows only | Win/Mac/Linux | Win/Mac/Linux |
| **GPU acceleration** | Yes | Yes (WebGPU) | Yes |
| **Lua config** | No | Yes | No |
| **Built into Windows 11** | Yes | No | No |

### Recommendations
- **WezTerm**: Best for Neovim users who want Lua configuration parity and rich features (tabs, splits, ligatures, undercurl). Some users report slight input lag compared to Alacritty.
- **Alacritty**: Best for raw performance. No tabs/splits (use a multiplexer). Some Windows-specific mouse input issues reported. Undercurl support is experimental.
- **Windows Terminal**: Best for convenience (pre-installed on Win 11). Good enough for most users. Less configurable than the other two.

### Windows-Specific Issues
- Alacritty on Windows may have mouse input issues depending on whether WezTerm is also installed (affects ConPTY behavior)
- WezTerm may feel laggy without WebGPU enabled; enable it in config for best performance
- Windows Terminal is the lowest-friction option since it ships with Windows 11

### Key Sources
- [WezTerm vs Alacritty Discussion](https://github.com/wezterm/wezterm/discussions/1769)
- [Neovim Terminal Poll - Neovim Discourse](https://neovim.discourse.group/t/poll-which-terminal-emulator-do-you-use/2319)
- [Choosing a Terminal Emulator](https://enochchau.com/blog/2022/choosing-a-terminal/)
- [WezTerm Terminal as Part of Your Workflow](https://haseebmajid.dev/posts/2024-01-05-part-4-wezterm-terminal-as-part-of-your-development-workflow/)

---

## 6. WSL vs Native Windows

### Common Consensus
**WSL2 is the preferred approach** for most users migrating from Linux. Native Windows is viable but requires more manual optimization.

### WSL2 Advantages
- Near-identical experience to Linux -- all Unix tooling works natively
- Plugin compatibility is essentially 100% (same as Linux)
- No need for a C compiler workaround for treesitter (just `apt install build-essential`)
- LSP servers install cleanly via Mason
- Shell compatibility is not an issue (uses bash/zsh)
- Community documentation assumes Unix; WSL matches those assumptions

### WSL2 Disadvantages
- **Clipboard integration requires extra setup** (win32yank, OSC52, or clip.exe/powershell.exe)
- **Cross-filesystem access is slow** -- working on `/mnt/c/` from WSL is significantly slower than working in the WSL filesystem
- **Cannot use Windows-native tools** like ActiveDirectory PowerShell modules
- **Adds complexity** -- two environments to maintain
- **Discord RPC and similar IPC tools** do not work out of the box

### Native Windows Advantages
- Direct access to Windows filesystem (no cross-FS penalty)
- Single environment to maintain
- Can use Windows-native tools and integrations
- No WSL overhead

### Native Windows Disadvantages
- **Antivirus (Windows Defender) causes significant slowdowns** -- file I/O heavy operations are penalized
- **Plugin compatibility issues** -- some plugins assume Unix shell
- **Treesitter compilation** requires installing a C compiler (zig, clang, MSVC)
- **Shell configuration pitfalls** -- PowerShell vs cmd.exe vs pwsh causes plugin breakage
- **PATH bloat** -- Windows PATH can become very long, slowing executable lookups
- **Clipboard is slower** -- initial copy operations can be slow without OSC52
- **Many features in testing/debugging plugins may be broken** on native Windows

### Performance Comparison
- **Startup time**: Native Windows can be 60ms slower due to `setlocale()` overhead (fixable with env vars)
- **File search**: Slower on native Windows, especially with antivirus active
- **General editing**: Comparable once startup is complete
- **WSL filesystem**: Fast for files stored in the Linux filesystem; slow for `/mnt/c/` access

### Key Sources
- [Neovim Experience on Windows](https://kqtran.com/blog/neovim-performance-on-windows/)
- [Perfect Windows 11 Dev Environment with WezTerm, WSL2, Neovim](https://mayberoot.medium.com/the-perfect-windows-11-dev-environment-setup-with-wezterm-wsl2-and-neovim-d73ab1202703)
- [Configuring LazyVim and Python on Windows with WSL](https://dev.to/gitaroktato/configuring-lazyvim-and-python-on-windows-with-wsl-2fpd)
- [Neovim on Windows + WSL](https://medium.frankmayer.dev/neovim-on-windows-wsl-4f9fe7bcb95c)

---

## 7. Plugin Compatibility Issues

### Common Consensus
Most Neovim plugins work on Windows, but plugins that shell out to external commands or have build steps are the most likely to break.

### Categories of Problems

#### 1. Shell Configuration Conflicts
- Plugins that run shell commands may break if PowerShell is set as the default shell
- **Fix**: Keep `cmd.exe` as `vim.o.shell` for internal plugin use, or set:
  ```lua
  if vim.fn.has('win32') == 1 then
    vim.o.shell = 'cmd.exe'
    vim.o.shellcmdflag = '/c'
  end
  ```

#### 2. Build Step Failures
- Plugins requiring C compilation (treesitter, telescope-fzf-native) fail without a compiler
- **Fix**: Install zig, clang, or MSVC build tools

#### 3. Unix Tool Dependencies
- Plugins that call `grep`, `find`, `sed`, `awk` will fail on native Windows
- **Fix**: Install `ripgrep`, `fd`, `GNU coreutils` via scoop/choco, or use WSL

#### 4. Path Separator Issues
- Some plugins hardcode `/` as path separator
- Most well-maintained plugins handle this, but older/unmaintained ones may not

#### 5. Corporate Environment Issues
- Corporate proxy interference with package downloads (plugins hang during install)
- BeyondTrust EPM and similar privilege escalation tools cause additional slowdowns
- **Fix**: Configure proxy settings, add exclusions for nvim-related tools

### Plugins Known to Have Windows Issues
- `telescope-fzf-native.nvim` -- build failures (use CMake build)
- `nvim-dap-python` / `neotest-python` -- runtime path detection issues
- Plugins using `neoterm` -- breaks with PowerShell as shell
- Any plugin using `io.popen()` with Unix commands

### Key Sources
- [Get NeoVim plugins with build processes working on Windows](https://dev.to/kaiwalter/get-neovim-plugins-with-build-processes-working-on-windows-i39)
- [Fixing vim-plug update error on Neovim on Windows](https://fpira.com/blog/2024/12/fixing-vim-plug-update-error-on-neovim-on-windows)
- [How to install and set up Neovim on Windows](https://blog.nikfp.com/how-to-install-and-set-up-neovim-on-windows)

---

## 8. Treesitter Compiler Setup on Windows

### Common Consensus
A C compiler is **required** for nvim-treesitter to compile parsers. This is the single most common friction point for Neovim on Windows. **Zig is the easiest option.**

### Requirements (Neovim 0.11+)
- `tar` and `curl` in PATH (bundled with recent Windows/Neovim)
- `tree-sitter-cli` >= 0.26.1
- A C compiler in PATH

### Compiler Options (Ranked by Ease of Setup)

#### Option 1: Zig (Recommended -- Easiest)
```powershell
scoop install zig
# or
winget install zig.zig
```
Then in your Neovim config:
```lua
require('nvim-treesitter.install').compilers = { "zig" }
```

#### Option 2: Clang via LLVM
```powershell
scoop install llvm
```
Then:
```lua
require('nvim-treesitter.install').compilers = { "clang" }
```

#### Option 3: MSVC Build Tools (Officially Recommended by nvim-treesitter)
Install "Build Tools for Visual Studio" with the "Desktop development with C++" workload. This is the heaviest option (~6-8GB) but the officially recommended one.

#### Option 4: MinGW/GCC
```powershell
choco install mingw
```
Ensure the MinGW `bin` directory is in PATH.

### Configuring Compiler Priority
nvim-treesitter checks PATH for: `$CC`, `cc`, `gcc`, `clang`, `cl`, `zig` (in that order). You can override:
```lua
require('nvim-treesitter.install').compilers = { "clang", "zig", "gcc" }
```

### Important Notes
- **Parsers are platform-specific** -- compiled on Windows, they only work on Windows
- **Ensure architecture matches** -- if using x64 Neovim, use x64 compiler
- `curl` is bundled with Neovim; `tar` (BSD tar) is bundled with recent Windows versions

### Key Sources
- [nvim-treesitter Windows Support Wiki](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support)
- [Setup Neovim Treesitter on Windows using Scoop and Zig](https://www.sanketsjournal.com/articles/20240710-setup-neovim-treesitter-on-windows-using-scoop-and-zig)
- [How to install neovim treesitter on Windows 11](https://takia.dev/nvim-treesitter-windows-11/)
- [Neovim with LSP and Treesitter on Windows Without Admin Rights](https://devctrl.blog/posts/neovim-on-windows/)
- [Treesitter compiler setting discussion](https://github.com/nvim-treesitter/nvim-treesitter/discussions/7920)

---

## 9. Windows Package Managers for Neovim

### Comparison

| Feature | Winget | Scoop | Chocolatey |
|---------|--------|-------|------------|
| **Pre-installed** | Yes (Win 11) | No | No |
| **Admin required** | No | No | Yes (for install) |
| **Package count** | ~8000+ | Lowest | ~10000+ |
| **Install scope** | System-wide | User-local | System-wide |
| **Free** | Yes | Yes | Yes (community) |
| **Neovim command** | `winget install Neovim.Neovim` | `scoop install neovim` | `choco install neovim` |
| **Nightly builds** | No | Yes (extras) | `choco install neovim --pre` |

### Recommendations
- **Winget**: Best default choice. Pre-installed on Windows 11, no admin needed, official Microsoft tool.
- **Scoop**: Best for developers who want user-local installs without admin. Does not modify system directories. Good for installing supporting tools (zig, ripgrep, fd, etc.).
- **Chocolatey**: Largest package ecosystem. Good for corporate environments. Supports nightly/pre-release builds easily.

### One-liner Setups

**Using Chocolatey:**
```powershell
choco install -y neovim git ripgrep wget fd unzip gzip mingw make
```

**Using Scoop:**
```powershell
scoop install neovim git ripgrep fd zig
```

**Using Winget:**
```powershell
winget install Neovim.Neovim Git.Git BurntSushi.ripgrep.MSVC sharkdp.fd zig.zig
```

### Prerequisites
- Windows 8+ required (Windows 7 not supported)
- If missing `VCRUNTIME170.dll`, install [Visual C++ Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist)

### Key Sources
- [Chocolatey vs. Winget vs. Scoop](https://www.xda-developers.com/chocolatey-vs-winget-vs-scoop/)
- [Installing Neovim - Official Wiki](https://github.com/neovim/neovim/wiki/Installing-Neovim)
- [Neovim INSTALL.md](https://github.com/neovim/neovim/blob/master/INSTALL.md)

---

## 10. mason.nvim LSP on Windows

### Common Consensus
mason.nvim works on Windows but has more friction than on Linux/macOS, primarily around permission errors and missing system dependencies.

### Problems Reported

#### 1. EPERM Permission Errors
The most common Windows issue: `EPERM: operation not permitted` when Mason moves packages from staging to the final directory. This is often caused by:
- **Windows Defender/antivirus** locking files during the move operation
- **File locking** by other processes
- **Fix**: Add Mason's data directory to Windows Defender exclusions, or run `:MasonInstall` again (it often works on retry)

#### 2. LSP Spawning Failures
Servers install but fail to start. Common causes:
- Missing `npm`, `node`, `python`, `pip` in PATH
- Missing `pwsh` (PowerShell 7) -- Mason health check warns about this
- **Fix**: Run `:checkhealth mason` and install all reported missing dependencies

#### 3. Breaking Changes (Mason v2 + Neovim 0.11)
Mason v2 and mason-lspconfig v2 introduced breaking changes aligned with Neovim 0.11's new `vim.lsp.config` API:
- **Requires**: Neovim >= 0.11.0, mason.nvim >= 2.0.0, nvim-lspconfig >= 2.0.0
- mason-lspconfig now automatically calls `vim.lsp.enable()` for installed servers
- Some users migrating found LSPs stopped attaching to buffers

### Recommended Setup (2025)
```lua
{
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "ts_ls", "pyright" },
    })
  end,
}
```

### Troubleshooting Checklist
1. Run `:checkhealth mason` -- identifies missing system dependencies
2. Check `:MasonLog` for detailed error output
3. Ensure `npm`, `node`, `python`, `pip`, `curl`, `tar` are in PATH
4. Add Mason directories to Windows Defender exclusions
5. Ensure all three plugins (mason, mason-lspconfig, nvim-lspconfig) are on compatible major versions

### Key Sources
- [Unable to install LSPs on Windows - Issue #1565](https://github.com/williamboman/mason.nvim/issues/1565)
- [Migrating to vim.lsp.config - Discussion #2023](https://github.com/mason-org/mason.nvim/discussions/2023)
- [mason-lspconfig.nvim README](https://github.com/mason-org/mason-lspconfig.nvim)
- [Mason.nvim Ultimate Guide](https://dev.to/ralphsebastian/masonnvim-the-ultimate-guide-to-managing-your-neovim-tooling-4520)

---

## 11. Windows Defender / Antivirus Performance

### The Problem
Windows Defender real-time scanning intercepts every file I/O operation. Neovim's file-driven architecture means it creates, reads, and writes many small files during:
- Plugin installation
- Treesitter parser compilation
- LSP operations
- General buffer management

This can cause:
- **Slow startup** (measurably slower than Linux)
- **Plugin installation hangs** (Mason EPERM errors)
- **Treesitter compilation failures** (files locked during build)
- **General input lag**

### Solutions

#### Add Process Exclusions (PowerShell, elevated)
```powershell
Add-MpPreference -ExclusionProcess "nvim.exe"
Add-MpPreference -ExclusionProcess "node.exe"
Add-MpPreference -ExclusionProcess "pwsh.exe"
```

#### Add Directory Exclusions
```powershell
Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\nvim"
Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\nvim-data"
```

#### GUI Path
Settings > Update & Security > Windows Security > Virus & threat protection > Manage settings > Add or remove exclusions

### Additional Performance Tips
- **Set locale env vars manually** to avoid 60ms startup penalty from Windows `setlocale()` registry access
- **Use PowerShell 7.x** (`pwsh`) instead of PowerShell 5 -- halves shell startup time
- **Use OSC52 for clipboard** -- avoids spawning processes for each copy operation

### Key Sources
- [Neovim Experience on Windows](https://kqtran.com/blog/neovim-performance-on-windows/)
- [Nightly release triggers Windows Defender - Issue #27838](https://github.com/neovim/neovim/issues/27838)

---

## 12. Shell Configuration (PowerShell vs cmd.exe)

### Common Consensus
**Keep `cmd.exe` as Neovim's internal shell**. Use PowerShell as your terminal, but do not set it as `vim.o.shell`.

### The Problem
Many Neovim plugins assume a POSIX-like shell (bash/sh) for `:!` commands and `system()` calls. Setting PowerShell as the shell breaks these assumptions. Additionally, Neovim has a known bug where double-quoting occurs between `shell_build_argv` and libuv's `make_program_args`.

### Recommended Config
```lua
if vim.fn.has('win32') == 1 then
  -- Keep cmd.exe for internal shell operations (plugin compatibility)
  vim.o.shell = 'cmd.exe'
  vim.o.shellcmdflag = '/c'
  -- PowerShell-specific settings only if you truly need pwsh as shell:
  -- vim.o.shell = 'pwsh'
  -- vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
  -- vim.o.shellquote = ''
  -- vim.o.shellxquote = ''
end
```

### PowerShell Version Matters
- **PowerShell 5** (`powershell.exe`): Ships with Windows. Missing features like `$PSStyle.OutputRendering` and `Remove-Alias`. Not recommended as Neovim shell.
- **PowerShell 7+** (`pwsh.exe`): Cross-platform, better compatibility. If you must use PowerShell as the shell, use this version.

### Key Sources
- [Fixing 'shell' on Windows - Issue #28384](https://github.com/neovim/neovim/issues/28384)
- [Shell-powershell doc issues - Issue #37124](https://github.com/neovim/neovim/issues/37124)
- [Setting Up Neovim with Windows PowerShell](https://dev.to/hoo12f/setting-up-neovim-with-windows-powershell-2208)
- [PowerShell Development in Neovim (2024)](https://medium.com/@kacpermichta33/powershell-development-in-neovim-23ed44d453b4)

---

## 13. Clipboard Integration

### Option A: OSC52 (Recommended for Neovim 0.10+)
Native support added in Neovim 0.10. Automatically detected if terminal supports it.

```lua
-- Force OSC52
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
```

**Caveat**: Paste via OSC52 may not work in all terminals (WezTerm does not allow clipboard reads by default). You may need `Ctrl+Shift+V` for paste. Some terminals cause a 10-second freeze when Neovim tries to read the clipboard via OSC52.

### Option B: clip.exe + powershell.exe (WSL-specific)
```lua
vim.g.clipboard = {
  name = 'WslClipboard',
  copy = {
    ['+'] = 'clip.exe',
    ['*'] = 'clip.exe',
  },
  paste = {
    ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  },
  cache_enabled = 0,
}
```

### Option C: win32yank.exe
Install via `scoop install win32yank` or download from GitHub releases.

### Option D: clipipe (Best Performance)
A persistent background process approach that avoids spawning a new process per clipboard operation. Significant speed improvement on Windows/WSL.

### WSL Detection
```lua
local in_wsl = os.getenv('WSL_DISTRO_NAME') ~= nil
if in_wsl then
  -- Apply WSL-specific clipboard config
end
```

### Key Sources
- [Neovim Provider Docs - Clipboard](https://neovim.io/doc/user/provider.html)
- [OSC52 clipboard discussion - #28010](https://github.com/neovim/neovim/discussions/28010)
- [WSL Neovim Clipboard - Issue #12092](https://github.com/neovim/neovim/issues/12092)
- [clipipe - GitHub](https://github.com/bkoropoff/clipipe)
- [feat(osc52): default OSC52 tool - PR #33021](https://github.com/neovim/neovim/pull/33021)

---

## 14. Decision Matrix: WSL vs Native

### Choose WSL2 if:
- [x] You are coming from Linux and want the smoothest transition
- [x] You rely on Unix tooling (grep, sed, awk, etc.) in your workflow
- [x] You use plugins that shell out to Unix commands
- [x] You want maximum plugin compatibility with zero friction
- [x] You do not need Windows-native tool integration
- [x] You are willing to keep your project files in the WSL filesystem

### Choose Native Windows if:
- [x] You need direct Windows filesystem access without performance penalties
- [x] You work in a corporate environment where WSL is restricted
- [x] You need Windows-native tool integration (PowerShell modules, .NET, etc.)
- [x] You want a single environment to maintain
- [x] You are willing to install and configure supporting tools (zig, ripgrep, etc.)
- [x] You can add Windows Defender exclusions for Neovim directories

### Hybrid Approach (Most Flexible)
Many users run **both**:
- WSL2 Neovim for software development (code editing, git, builds)
- Native Windows Neovim for quick file edits and Windows-specific tasks
- Shared config via dotfile manager (chezmoi) with OS-conditional logic

---

## Quick Start Checklist (Native Windows)

```powershell
# 1. Install package manager (if not using winget)
# scoop: irm get.scoop.sh | iex

# 2. Install Neovim and dependencies
winget install Neovim.Neovim
scoop install git ripgrep fd zig nodejs

# 3. Install a Nerd Font
# Download from https://www.nerdfonts.com/ and install

# 4. Clone your config
git clone <your-config-repo> $env:LOCALAPPDATA\nvim

# 5. Add Windows Defender exclusions (elevated PowerShell)
Add-MpPreference -ExclusionProcess "nvim.exe"
Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\nvim"
Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\nvim-data"

# 6. Add to your init.lua for Windows compatibility
# See Sections 8, 12, 13 above for specific config snippets

# 7. Launch Neovim
nvim
```

## Quick Start Checklist (WSL2)

```powershell
# 1. Install WSL2
wsl --install

# 2. Install a terminal emulator
winget install wez.wezterm
# or use Windows Terminal (pre-installed on Win 11)

# 3. Inside WSL:
sudo apt update && sudo apt install -y neovim git ripgrep fd-find build-essential nodejs npm

# 4. Clone your config (same as Linux)
git clone <your-config-repo> ~/.config/nvim

# 5. Set up clipboard (add to init.lua)
# See Section 13 for clipboard options

# 6. Launch Neovim
nvim
```
