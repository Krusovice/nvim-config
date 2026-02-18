vim.g.mapleader = " "

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- global clipboard, to yank paste outside nvim
vim.opt.clipboard = "unnamedplus"

-- Disable swap files
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
vim.opt.signcolumn = "auto" -- Always show sign column (for LSP diagnostics)

-- Terminal keybind
vim.keymap.set('n', '<leader>t', ':vsplit | term<CR>:vertical resize 80<CR>i', { desc = 'Open terminal split' })
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { desc = 'Window switch from terminal' }) 

-- switching to terminal view, starts in i-mode
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  command = "startinsert"
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)
-- Load plugins
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
})
