---------------
-- init.lua
-- Shamelessly stolen from various places out there in the wild.
---------------

-- Bootstrap Lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Theme
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function()
      vim.cmd[[colorscheme tokyonight]]
    end
  },

-- Treesitter for syntax highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
      require("nvim-treesitter.configs").setup {
        highlight = { enable = true },
        indent = { enable = true }
      }
    end
  },

-- Autocompletion
  { "hrsh7th/nvim-cmp", dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip"
    }, config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end
  },

-- LSP Config
  { "neovim/nvim-lspconfig", config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
    end
  },

-- FZF
  { "ibhagwan/fzf-lua", config = function()
      require("fzf-lua").setup({})
    end
  },

-- Telescope
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" }, config = function()
      require("telescope").setup{}
    end
  },

-- File tree
  { "kyazdani42/nvim-tree.lua", config = function()
      require("nvim-tree").setup{}
    end
  },

-- Git integration
  { "lewis6991/gitsigns.nvim", config = function()
      require("gitsigns").setup{}
    end
  },

-- Status line
  { "nvim-lualine/lualine.nvim", dependencies = { "kyazdani42/nvim-web-devicons", opt = true }, config = function()
      require("lualine").setup {
        options = {
          theme = "tokyonight"
        }
      }
    end
  },

})

-------------------
-- options
-------------------
local set = vim.opt

--line nums
set.relativenumber = true
set.number = true

-- indentation and tabs
set.tabstop = 4
set.shiftwidth = 4
set.autoindent = true
set.expandtab = true

-- search settings
set.ignorecase = true
set.smartcase = true

-- appearance
set.termguicolors = true
set.background = "dark"
set.signcolumn = "yes"

-- cursor line
set.cursorline = true

-- 80th column
set.colorcolumn = "80"

-- clipboard
set.clipboard:append("unnamedplus")

-- backspace
set.backspace = "indent,eol,start"

-- split windows
set.splitbelow = true
set.splitright = true

-- dw/diw/ciw works on full-word
set.iskeyword:append("-")

-- keep cursor at least 8 rows from top/bot
set.scrolloff = 8

-- undo dir settings
set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

-- incremental search
set.incsearch = true

-- faster cursor hold
set.updatetime = 50

---------------------------
-- VSCode-like keybindings
---------------------------
vim.g.mapleader = " " -- leader key!

-- fzf keybindings
vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "FZF Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>lua require('fzf-lua').live_grep()<CR>", { desc = "FZF Live Grep" })

-- telescope keybindings
vim.keymap.set("n", "<leader>tf", "<cmd>Telescope find_files<CR>", { desc = "Telescope Find Files" })
vim.keymap.set("n", "<leader>tg", "<cmd>Telescope live_grep<CR>", { desc = "Telescope Live Grep" })

-- netrw directoy listing 
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- show rendered markdown files in broswer, after opening them
vim.keymap.set("n", "<leader>md", "<cmd>MarkdownPreview<CR>", { desc = "Markdown Preview" })

-- cursor movements
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Alt Up/Down in vscode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")       -- Join lines, but keep cursor in place
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Keep cursor in place while moving up/down page
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")       -- center screen when looping search results
vim.keymap.set("n", "N", "Nzzzv")

-- paste and don't replace clipboard over deleted text
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- sometimes in insert mode, control-c doesn't exactly work like escape
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Disable Ex mode
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- getting Alex off my back :)
vim.keymap.set("n", "<leader>dg", "<cmd>DogeGenerate<cr>")

-- Replace all instances of whatever is under cursor (on line)
vim.keymap.set("n", "<leader>s", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

-- make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- yank into clipboard even if on ssh
vim.keymap.set('n', '<leader>y', '<Plug>OSCYankOperator')
vim.keymap.set('v', '<leader>y', '<Plug>OSCYankVisual')

-- reload without exiting vim
-- vim.keymap.set("n", "<leader>rl", "<cmd>source ~/.config/nvim/init.lua<cr>")

-- vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- source file
-- vim.keymap.set("n", "<leader><leader>", function()
--    vim.cmd("so")
-- end)







