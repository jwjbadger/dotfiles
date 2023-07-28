set nocompatible

syntax on
set number
set hlsearch
set incsearch
set autoindent noexpandtab tabstop=4 shiftwidth=4

" Vim-Plug
call plug#begin("~/.local/share/nvim/site/plugged")

" nvim-cmp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" vsnip
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" nerdtree
Plug 'preservim/nerdtree'

" fugitive (Git support)
Plug 'tpope/vim-fugitive'

" notify
Plug 'rcarriga/nvim-notify'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" lualine
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'kyazdani42/nvim-web-devicons'

" LeaderF (fuzzy search)
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

" neoformat
Plug 'sbdchd/neoformat'

" alpha-nvim 
Plug 'goolord/alpha-nvim'

" Nerd Commenter
Plug 'scrooloose/nerdcommenter'
call plug#end()

" nvim-cmp setup

lua <<EOF
  -- notify
  vim.notify = require("notify")
  
  -- nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require'lspconfig'.ccls.setup{
    init_options = {
      compilationDatabaseDirectory = "build";
      index = {
        threads = 0;
      };
      clang = {
        excludeArgs = { "-frounding-math"} ;
      };
      cmd = { "ccls" };
      filetypes = { "c", "cpp", "objc", "objcpp" };
      offset_encoding = "utf-32";
    }
  }

  -- treesitter
  require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
    highlight = { enable = true },
    indent = { enable = true }
  }

  -- lualine 
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'horizon',
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
  }

  -- alpha-nvim
  local alpha = require'alpha'
  local dashboard = require("alpha.themes.dashboard")
  dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
  }
  dashboard.section.buttons.val = {
    dashboard.button( "Leader f f", "  > Find file", ":Leaderf file --popup<CR>"),
    dashboard.button( "Leader f r", "  > Recent files"   , ":Leaderf mru --popup<CR>"),
    dashboard.button( "Leader f g", "  > Project grep" , ":Leaderf rg --popup<CR>"),
    dashboard.button( "u", "  > Update plugins" , ":PlugUpdate | :PlugUpgrade"),
    dashboard.button( "e", "  > New file" , ":enew <CR>"),
    dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
  }
  alpha.setup(dashboard.opts)
EOF
