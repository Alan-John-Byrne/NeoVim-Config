-- SECTION: PART 0: Fix Neovim 'breaking-changes' issues:
-- INFO: Neovim V0.11 disables LSP virtual text by default. MUST ENABLE IT.
vim.diagnostic.config({ virtual_text = true })
-- SECTION: PART 1: Some pre-config and API brief.
-- OOO: The API:
-- The overall API is complex, where the global vim table actually exposes three main portions that are used together,
-- they are:
-- > The 'Vim API' - accessed via the 'vim.cmd()' method and the 'vim.fn' (builtin-functions) sub-table. Provides compatibility with legacy Vim functions but uses 0-based indexing.
-- > The 'Nvim API' - accessed via the '.api' table. Neovim-specific, low-level API requiring explicit arguments and using 0-based indexing.
-- > The 'Lua API' - includes high-level modules like `vim.lsp`, `vim.treesitter`, `vim.diagnostic`, and utility functions like `vim.inspect`, `vim.loop`, etc.
-- IMPORTANT: This distinction is vital because:
-- -> 'Vim API' functions use 0-based when Lua uses 1-based indexing
-- -> 'Nvim API' need all method arguments passed. Even though Lua (it's LSP and compiler) might accept some as nil.
-- INFO: The options.lua file is used for accessing the global vim lua table, and setting options.
-- Not for direct API calls. See full list of options using the ':options' command.
-- TODO: Plugin Global Settings:
-- WARN: 'vim.g': Global variables. These are NOT options. They're used for configuring global
-- settings used by plugins that require them to be set, prior to them actually being loaded by 'lazy.nvim' itself.
-- You can't do 'local plugin_global = vim.g'. As 'vim.g' is a special meta-table handled by neovim so you can't
-- do a 'shallow' or 'deep' copy into a variable and control it from there. It must be 'vim.g' on it's own. Like so:
vim.g.mapleader = " " -- 'which-key': Set "<leader>" key to 'space' allowing keymaps to work properly.
vim.g.maplocalleader = "\\"
-- SECTION: PART 2: Setting options using the Lua portion of the overall API.
-- CHECK: Ways of setting options using the Lua API:
--'vim.opt': Modern recommended way of setting options. Use when possible.
--'vim.o': Global-only options. Applies to all buffers and windows. Use to set global settings that apply across buffers and windows.
--'vim.bo': Buffer-local options. Only applies to the CURRENT buffer. Use within plugin configuration functions or autocommands.
--'vim.wo': Window-local options. Only applies to the CURRENT window. Use within plugin configuration functions or autocommands.
--'vim.env': Allows for accessing your environment variables within Neovim. (eg: $env.HOME)
-- REMEMBER: Setting options via 'vim.opt' will auto-detect if they're 'global', 'buffer-local', or 'window-local'.
-- NOTE: Options are automatically loaded before the 'lazy.nvim' package manager
-- starts up. Add any additional options here:
local opt = vim.opt
--MAC
-- INFO: 'opt.shell' points to the bash executable.
opt.shell = "/bin/bash" -- currently required as just '/bin/bash' for 'venv-selector.nvim' to function properly.
opt.shellcmdflag = "-c" -- currently required as just '-c' for 'venv-selector.nvim' to function properly.
opt.shellquote = ""

-- IMPORTANT: Must set the correct cli tool depending on the OS being used:
local cross_os = require("config.custom_nvim_lua_libraries.cross_os")
if cross_os.detect_os() == "Darwin" then
  -- OOO: MAC
  -- INFO: 'opt.shell' points to the bash executable.
  opt.shell = "/bin/bash" -- currently required as just '/bin/bash' for 'venv-selector.nvim' to function properly.
  opt.shellcmdflag = "-c" -- currently required as just '-c' for 'venv-selector.nvim' to function properly.
  opt.shellquote = ""
else
  -- OOO: WINDOWS
  -- INFO: 'opt.shell' points to the PowerShell7 executable,
  -- available through your set environment variables, in your ".ps1" profile.
  opt.shell = "pwsh" -- Adding the PowerShell profile terminal configuration:
  opt.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
  opt.shellxquote = ""
end

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2                                    -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true                                      -- Confirm to save changes before exiting modified buffer
opt.cursorline = true                                   -- Enable highlighting of the current line
opt.expandtab = true                                    -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.pumblend = 0 -- Popup blend (opacity)  WARN: '0' required for transparent LSP popups (using the "pretty_hover" plugin).
opt.foldlevel = 99
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true                         -- Ignore case
opt.inccommand = "nosplit"                    -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3                            -- global statusline
opt.linebreak = true                          -- Wrap lines at convenient points / Avoid wrapping in the middle of words
opt.list = true                               -- Show some invisible characters (tabs...
opt.mouse = "a"                               -- Enable mouse mode
opt.number = true                             -- Print line number
opt.pumheight = 50                            -- Maximum number of entries in a popup
opt.relativenumber = true                     -- Relative line numbers
opt.ruler = false                             -- Disable the default ruler
opt.scrolloff = 4                             -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true                         -- Round indent
opt.shiftwidth = 2                            -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false                          -- Dont show mode since we have a statusline
opt.sidescrolloff = 8                         -- Columns of context
opt.signcolumn = "yes"                        -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true                          -- Don't ignore case with capitals
opt.smartindent = true                        -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true                         -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true                         -- Put new windows right of current
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.tabstop = 2                               -- Number of spaces tabs count for
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Special symbols to use whilst editing.
-- WARN: Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
