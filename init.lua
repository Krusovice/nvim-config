vim.g.mapleader = " "

-- Show line numbers
vim.opt.number = true
-- Show relative line numbers (optional, useful later for commands like "5j")
-- vim.opt.relativenumber = true
--
-- -- Disable swap files
vim.opt.swapfile = false

-- Better search
vim.opt.ignorecase = true  -- Case insensitive search
vim.opt.smartcase = true   -- Unless you use capitals

-- Indentation for Rust/JS/TS
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.smartindent = true

-- Better visual feedback
vim.opt.cursorline = true  -- Highlight current line
vim.opt.signcolumn = "auto" -- Always show sign column (for LSP diagnostics)

-- Terminal keybind
vim.keymap.set('n', '<leader>t', ':vsplit | term<CR>:vertical resize 80<CR>i', { desc = 'Open terminal split' })

-- Set leader key (if not already set)
vim.g.mapleader = " "  -- Spacebar as leader
