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

-- 2 spaces for web files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "astro", "html", "css", "javascript", "typescript" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end
})

-- Load plugins
require("lazy").setup({
  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  -- LSP config
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "html",
          "cssls",
          "ts_ls",
          "astro",
          "rust_analyzer",
          "pyright",
        },
        automatic_installation = true,
      })
    end,
  },
  -- Enable language servers
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.enable({'html', 'cssls', 'ts_ls', 'astro', 'rust_analyzer', 'pyright'})
    end,
  },
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
        },
      })
    end,
  },
-- Auto close HTML tags
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
})
