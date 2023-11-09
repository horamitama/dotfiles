local status, packer = pcall(require, "packer")
if (not status) then
    print("Packer is not installed")
    return
end
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'nvim-lua/plenary.nvim'
  use 'wbthomason/packer.nvim'
  use 'nvim-tree/nvim-web-devicons'

  -- color scheme 
  use 'shaunsingh/nord.nvim'

  -- status line
  use {
    'nvim-lualine/lualine.nvim',
     requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- fuzzy finder
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.4' }
  use "nvim-telescope/telescope-file-browser.nvim"

  -- syntax highlight
  use 'nvim-treesitter/nvim-treesitter'

  -- comment
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  }

  -- buffer line
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
  
  -- git
  use 'lewis6991/gitsigns.nvim'

  -- lsp
  use 'neovim/nvim-lspconfig'
  
  use ({
    'nvimdev/lspsaga.nvim',
    after = 'nvim-lspconfig',
  })

  use 'gkz/vim-ls' -- LiveScript
  use 'jose-elias-alvarez/null-ls.nvim'
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  }

  use 'onsails/lspkind-nvim' -- vscode-like pictograms
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for neovim's built-in LSP
  use 'hrsh7th/nvim-cmp' -- Completion
  use 'L3MON4D3/LuaSnip'

  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'

  -- formatter 
  use 'MunifTanjim/prettier.nvim'

  -- copilot
  use 'github/copilot.vim'
end)
