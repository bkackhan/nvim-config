" ***************** configs del editor ***********************
" para la identacion correcta
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" - para mostrar los numeros
set number
" - las busquedas son no key sensitive
set ignorecase
" ***************** clipboard ***********************
set clipboard=unnamedplus

if executable('xclip')
    let g:clipboard = {
        \ 'name': 'xclip',
        \ 'copy': {
        \    '+': 'xclip -quiet -i -selection clipboard',
        \    '*': 'xclip -quiet -i -selection primary',
        \ },
        \ 'paste': {
        \    '+': 'xclip -o -selection clipboard',
        \    '*': 'xclip -o -selection primary',
        \ },
        \ }
endif
" ***************** pluggins ***********************
call plug#begin('/home/cleanhead/.config/nvim/plugged')
	" arbol de archivos e iconos
	Plug 'ryanoasis/vim-devicons'
  Plug 'nvim-tree/nvim-tree.lua'
	" finder
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-tree/nvim-web-devicons'
	" LSP 
	Plug 'neovim/nvim-lspconfig',
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
  "autocompletado
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  " For vsnip users autocompletado.
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

	" nightfox night para tema
	Plug 'EdenEast/nightfox.nvim' " Vim-Plug
  " para cerrar los pares de { [ (
  Plug 'windwp/nvim-autopairs'

call plug#end()
" Configuración del tema
colorscheme nightfox
"  - keybandings
" abre el arbol de archivos a la izquierda
nnoremap ,ot :NvimTreeToggle<CR>
" cambia entre el arbol y el editor
nnoremap <C-e> :wincmd w<CR>
" busca todos los archivos por nombre
nnoremap ,ff :Telescope find_files<CR>
" ? sudo apt-get install ripgrep es requerido para esta funcion 
" busca texto en todos los archivos
nnoremap ,fg :Telescope live_grep<CR>
" buscar y reemplazar
nnoremap ,fh :/<right>
" buscar y reemplazar
nnoremap ,fr :%s///gc<left><left><left><left>
" quita el molesto higligh despues de una busqueda
nnoremap ,nh :noh<CR>
" ************ LUA CONFIG **************
lua << EOF
-- ************ mason config **************
vim.lsp.completion.enable()
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed={ "vtsls", "vue_ls"},
	automatic_installation = true
})
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "dockerls",
    "html",
    "jsonls",
    "lua_ls",
    "vimls",
    "vue_ls",
    "vtsls",
    "cssls",
    "cssmodules_ls"
  },
  automatic_installation = true,
})


-- ************* icon update for nest *****************
require('nvim-web-devicons').setup({
   override = {
     --vue = {icon="󰡄", color="#2bfb79", name="vue"},
     ["service.ts"] = {icon="", color="#fbe12b", name="nest_service"},
     ["controller.ts"] = {icon="", color="#2b77fb", name="nest_controller"},
     ["module.ts"] = {icon="", color="#dc1625", name="nest_module"},
     ["dto.ts"] = {icon="", color="#653535", name="nest_dto"},
   }
})
-- auto pairs para el cerrado automatico de de los { [ (
require("nvim-autopairs").setup({map_cr = false})
-- NvimTree
require("nvim-tree").setup()
-- ***************** vim-cmp config *******************
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) 
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
    -- Tab/Shift-Tab también navegan
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback() -- Usa el comportamiento normal de Tab
      end
    end, {'i', 's'}),
    
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback() -- Usa el comportamiento normal de Shift+Tab
      end
    end, {'i', 's'}),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- ***************** lsp config *******************
local vue_language_server_path = vim.fn.stdpath("data")
.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"


local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
}

local vue_css_plugin = {
    name = "@vue/language-plugin-scss",
    location = vue_language_server_path,
    languages = { "vue" },
}

vim.lsp.config("vtsls", {
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					vue_plugin,
				},
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})


vim.lsp.enable("vtsls", "vue_ls", "cssls", "html")

EOF
