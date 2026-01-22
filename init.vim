" - para mostrar los numeros
:set number
" - las busquedas son no key sensitive
:set ignorecase
" - pluggins
call plug#begin('/home/cleanhead/.config/nvim/plugged')
	" arbol de archivos
	Plug 'preservim/nerdtree'
	Plug 'ryanoasis/vim-devicons'
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

call plug#end()
" Configuración del tema
colorscheme nightfox
"  - keybandings
" abre el arbol de archivos a la izquierda
nnoremap ,ot :NERDTreeToggle<CR>
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
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
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
EOF
