" para la identacion correcta
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" - para mostrar los numeros
:set number
" - las busquedas son no key sensitive
:set ignorecase
" - pluggins
call plug#begin('./plugged')
	" arbol de archivos e iconos
	" Plug 'preservim/nerdtree'
	Plug 'ryanoasis/vim-devicons'
  Plug 'nvim-tree/nvim-tree.lua'
	" finder
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-tree/nvim-web-devicons'
	" LSP para autocompletado
	Plug 'neovim/nvim-lspconfig',
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
	" nightfox night para tema
	Plug 'EdenEast/nightfox.nvim' " Vim-Plug
	" Use release branch (recommended)
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	" Or build from source code by using npm
	Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
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
" -- autocomplete
" mason
" navegar el autocompletado de CoC.vim:
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" configuracion de lua
lua << EOF
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


vim.lsp.enable("vtsls, vue_ls, cssls, html")

-- cambiamos unos cuantos iconos
require('nvim-web-devicons').setup({
   override = {
     vue = {icon="󰡄", color="#2bfb79", name="vue"},
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

EOF
