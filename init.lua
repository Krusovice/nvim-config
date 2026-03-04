-- init.lua

vim.cmd("filetype plugin indent on")
vim.g.mapleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.signcolumn = "auto"

-- Terminal keybind
vim.keymap.set('n', '<leader>t', ':vsplit | term<CR>:vertical resize 80<CR>i')
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>')

-- Move lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Terminal starts in insert
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  command = "startinsert"
})

-- Web files 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "astro", "html", "css", "javascript", "typescript", "typescriptreact" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end
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

-- Plugins
require("lazy").setup({

  -- Treesitter
{
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    require("nvim-treesitter").install({
      "rust",
      "javascript",
      "typescript",
      "html",
      "css",
      "python",
      "astro",
    })
  end,
},

  -- Autotag (afhængig af Treesitter)
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPost",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Mason + LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "html", "cssls", "ts_ls", "astro", "rust_analyzer", "pyright" },
        automatic_installation = true,
      })
    end,
  },

  -- Enable LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.enable({ "html", "cssls", "ts_ls", "astro", "rust_analyzer", "pyright" })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = { { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" } },
      })
    end,
  },

})
