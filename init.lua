-- Config that must come before plugins:
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- https://github.com/folke/lazy.nvim - "zzz A modern plugin manager for Neovim"
-- :help lazy.nvim.txt
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	-- vim.fn.system {
	-- 	'git',
	-- 	'clone',
	-- 	'--filter=blob:none',
	-- 	'https://github.com/folke/lazy.nvim.git',
	-- 	'--branch=stable', -- latest stable release
	-- 	lazypath,
	-- }
	vim.notify("automatic lazy.nvim cloning is disabled, see .config/nvim/Makefile")
end
if vim.loop.fs_stat(lazypath) then
	vim.opt.rtp:prepend(lazypath)
end

require("lazy").setup({
	-- TODO: DAP

	--------------------------------------------------------------------------------

	-- independent plugins (no dependencies or dependants)

	-- {
	-- 	-- colorscheme
	-- 	"https://gitlab.com/protesilaos/tempus-themes-vim",
	-- 	lazy = false,
	-- 	priority = 100,
	-- 	config = function()
	-- 		if vim.o.background == "dark" then
	-- 			vim.cmd.colorscheme("tempus_night")
	-- 		else
	-- 			vim.cmd.colorscheme("tempus_day")
	-- 		end
	-- 	end,
	-- },

	-- { "https://github.com/ahmedkhalf/project.nvim" }, -- project
	{ "https://github.com/airblade/vim-gitgutter" }, -- gitgutter
	{ "https://github.com/editorconfig/editorconfig-vim" }, -- editorconfig
	{ "https://github.com/tpope/vim-fugitive", }, -- fugitive
	{ "https://github.com/tpope/vim-sleuth" }, -- sleuth
	-- { "https://github.com/tpope/vim-vinegar", lazy = false }, -- vinegar (netrw)

	-- {
	-- 	"https://github.com/akinsho/bufferline.nvim",
	-- 	config = function()
	-- 		-- vim.g.termguicolors = true
	-- 		local bufferline = require('bufferline')
	-- 		vim.o.laststatus = 1 -- laststatus=2 is redundant with bufferline.
	-- 		bufferline.setup({
	-- 			options = {
	-- 				diagnostics = 'nvim_lsp',
	-- 				numbers = "ordinal",
	-- 				sort_by = 'insert_at_end',
	-- 				tab_size = 16,
	-- 				-- Disable most styling:
	-- 				indicator = {
	-- 					style = 'underline',
	-- 				},
	-- 				modified_icon = 'M',
	-- 				show_buffer_icons = false,
	-- 				show_buffer_close_icons = false,
	-- 				show_close_icon = false,
	-- 				separator_style = { ' ', ' ' },
	-- 				style_preset = {
	-- 					bufferline.style_preset.no_italic,
	-- 					bufferline.style_preset.no_bold,
	-- 					bufferline.style_preset.minimal,
	-- 				}
	-- 			}
	-- 		})
	-- 	end,
	-- },

	{
		-- notify
		"https://github.com/rcarriga/nvim-notify",
		config = function()
			local notify = require('notify')
			notify.setup({
				max_width = 32,
				icons = {
					DEBUG = "DEBUG",  -- DEBUG = "",
					ERROR = "ERROR",  -- ERROR = "",
					INFO = "INFO",   -- INFO = "",
					TRACE = "TRACE",  -- TRACE = "✎",
					WARN = "WARN",   -- WARN = ""
				},
				stages = "static" -- stages = "fade_in_slide_out",
			})
			-- vim.notify = notify
		end,
	},

	--------------------------------------------------------------------------------

	-- treesitter and friends

	{
		-- autopairs
		"https://github.com/windwp/nvim-autopairs",
		dependencies = { "treesitter" },
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
			})
		end,
	},

	{
		-- comment
		--
		-- TODO: document where config is cargo culted from.
		"https://github.com/numToStr/Comment.nvim",
		dependencies = { "ts-context-commentstring", },
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	{
		-- treesitter
		"https://github.com/nvim-treesitter/nvim-treesitter",
		name = "treesitter",
		dependencies = { "ts-context-commentstring" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
				-- "the five listed parsers should always be installed"
				-- https://github.com/nvim-treesitter/nvim-treesitter#modules
				sync_install = false,
				auto_install = true,

				highlight = { enable = true },
				indent = { enable = true },

				-- https://github.com/nvim-treesitter/nvim-treesitter#incremental-selection
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn", -- set to `false` to disable one of the mappings
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
						-- init_selection = "<c-space>",
						-- node_incremental = "<c-space>",
						-- scope_incremental = "<c-s>",
						-- node_decremental = "<M-space>",
					},
				},

				autotag = { enable = true },
				context_commentstring = {
					enable = true,
					enable_autocdm = false,
				},
			})
			vim.cmd(
				[[
					set foldmethod=expr
					set foldexpr=nvim_treesitter#foldexpr()
					set nofoldenable " Disable folding at startup.
				]]
			)
		end,
	},

	{
		"https://github.com/nvim-treesitter/nvim-treesitter-context",
		dependencies = "treesitter",
		config = function()
			require("treesitter-context").setup({
				min_window_height = 24,
				mode = "topline", -- 'cursor' is distracting.
			})
		end,
	},

	{
		-- ts-autotag
		"https://github.com/windwp/nvim-ts-autotag",
		dependencies = { "treesitter" },
	},

	{
		-- ts-context-commentstring
		"https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
		name = "ts-context-commentstring",
	},

	--------------------------------------------------------------------------------

	-- eldritch horrors

	{
		-- cmp
		"https://github.com/hrsh7th/nvim-cmp",
		name = "cmp",
		dependencies = { "luasnip" },
		config = function()
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end
			local luasnip = require('luasnip')
			-- Set up nvim-cmp.
			local cmp = require'cmp'
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
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
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							-- cmp.select_next_item()
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select})
							-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
							-- they way you will only jump inside the snippet region
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							-- cmp.complete()
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select})
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					-- { name = 'vsnip' }, -- For vsnip users.
					{ name = 'luasnip' }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
					--
					{ name = 'buffer' },
					{ name = "path", keyword_patterh = "/" }, -- Works for ~/, ./, ../.
					{ name = "emoji", keyword_pattern = ":" },
					-- { name = "luasnip" },
					-- { name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
				})
			})
		end,
	},
	-- cmp sources
	{ "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help", dependencies = { "cmp", "lspconfig" } },
	{ "https://github.com/hrsh7th/cmp-buffer", dependencies = { "cmp" } },
	{ "https://github.com/hrsh7th/cmp-emoji", dependencies = { "cmp" } },
	{ "https://github.com/hrsh7th/cmp-nvim-lsp", dependencies = { "cmp", "lspconfig" } },
	{ "https://github.com/hrsh7th/cmp-path", dependencies = { "cmp" } },

	{
		-- lspconfig
		"https://github.com/neovim/nvim-lspconfig",
		name = "lspconfig",
		lazy = false,
		dependencies = { "mason-lspconfig", "neodev" },
		config = function()
			-- Source: https://github.com/neovim/nvim-lspconfig#suggested-configuration
			-- Mods: no significant ones so far.
			-- TODO: https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
			-- TODO: https://github.com/neovim/nvim-lspconfig/wiki/Snippets
			local lspconfig = require('lspconfig')
			lspconfig.bashls.setup{}
			lspconfig.clangd.setup{}
			lspconfig.lua_ls.setup{}
			lspconfig.pyright.setup {}
			lspconfig.terraformls.setup{}
			lspconfig.lua_ls.setup({
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
				settings = {
					Lua = {
						runtime = { version = 'LuaJIT' },
						diagnostics = { globals = {'vim'}, },
						workspace = { library = vim.api.nvim_get_runtime_file("", true), },
						telemetry = { enable = false, },
					},
				},
			})
			-- lspconfig.efm.setup({
			-- 	init_options = {documentFormatting = true},
			-- 	settings = {
			-- 		rootMarkers = {".git/"},
			-- 		languages = {
			-- 			lua = {
			-- 				{formatCommand = "lua-format -i", formatStdin = true}
			-- 			}
			-- 		}
			-- 	}
			-- })
			-- docker
			lspconfig.docker_compose_language_service.setup{}
			lspconfig.dockerls.setup{}
			-- go
			lspconfig.golangci_lint_ls.setup{}
			lspconfig.gopls.setup{}
			-- "webdev"
			lspconfig.tailwindcss.setup{}
			lspconfig.tsserver.setup {}
			-- lspconfig.eslint.setup({
			-- 	on_attach = function(client, bufnr)
			-- 		vim.api.nvim_create_autocmd("BufWritePre", {
			-- 			buffer = bufnr,
			-- 			command = "EslintFixAll",
			-- 		})
			-- 	end,
			-- })
			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set('n', '<space>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<space>f', function()
						vim.lsp.buf.format { async = true }
					end, opts)
				end,
			})
		end,
	},

	{
		-- luasnip
		"https://github.com/L3MON4D3/LuaSnip",
		name = "luasnip",
		version = "1.*",
		build = 'make install_jsregexp',
		-- config = function()
		--   require("luasnip").setup()
		-- end,
	},

	{
		-- mason
		"https://github.com/williamboman/mason.nvim",
		name = "mason",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	{
		-- mason-lspconfig
		"https://github.com/williamboman/mason-lspconfig.nvim",
		name = "mason-lspconfig",
		dependencies = { "mason" },
		config = function()
			require("mason-lspconfig").setup()
		end,
	},

	{
		-- neodev
		"https://github.com/folke/neodev.nvim",
		name = "neodev",
		dependencies = { "cmp" },
		config = function()
			require("neodev").setup()
		end,
	},

	{
		"https://github.com/jose-elias-alvarez/null-ls.nvim",
		name = "null",
		dependencies = "https://github.com/nvim-lua/plenary.nvim",
		config = function()
			local null_ls = require('null-ls')
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			null_ls.setup({
				debug = true, -- TODO: disable me.
				sources = {
					null_ls.builtins.diagnostics.checkmake,
					null_ls.builtins.diagnostics.clang_check,
					null_ls.builtins.diagnostics.deadnix,
					null_ls.builtins.diagnostics.tsc,
					-- eslint
					null_ls.builtins.code_actions.eslint_d,
					-- null_ls.builtins.diagnostics.eslint_d,
					null_ls.builtins.formatting.eslint_d,
					null_ls.builtins.formatting.prettierd, -- null_ls.builtins.formatting.prettier,
					-- go
					null_ls.builtins.diagnostics.golangci_lint,
					null_ls.builtins.formatting.gofmt, -- null_ls.builtins.formatting.gofumpt,
					null_ls.builtins.formatting.goimports,
					-- null_ls.builtins.formatting.goimports_reviser,
					-- lua
					-- null_ls.builtins.diagnostics.luacheck,
					-- null_ls.builtins.formatting.lua_format,
					-- null_ls.builtins.formatting.stylua,
					-- python
					null_ls.builtins.formatting.blackd,
					-- shellcheck
					null_ls.builtins.code_actions.shellcheck,
					null_ls.builtins.diagnostics.shellcheck,
					-- terraform
					null_ls.builtins.diagnostics.terraform_validate,
					null_ls.builtins.diagnostics.tfsec,
					null_ls.builtins.formatting.terraform_fmt,
				},
				-- AutoFormatting:
				-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save#code
				-- you can reuse a shared lspconfig on_attach callback here
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
								-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
								-- vim.lsp.buf.formatting_sync()
								vim.lsp.buf.format({
									async = false,
									timeout_ms = 5000, -- Eslint can take slightly longer than the default.
								})
							end,
						})
					end
				end,
			})
		end,
	},

	--------------------------------------------------------------------------------

	-- telescope

	{
		"https://github.com/nvim-telescope/telescope.nvim",
		dependencies = "https://github.com/nvim-lua/plenary.nvim",
		tag = "0.1.2",
		config = function()
			local telescope = require('telescope').setup({})
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<c-p>', builtin.find_files, {})
			vim.keymap.set('n', '<c-g>', builtin.live_grep, {})
			-- vim.keymap.set('n', '<c-B>', builtin.buffers, {})
			vim.keymap.set('n', '<c-h>', builtin.help_tags, {})
			vim.keymap.set('n', '<c-t>', builtin.lsp_dynamic_workspace_symbols, {})
		end,
	},

})


-- Keymaps:
vim.keymap.set('n', '<c-w>', ':bwipeout<cr>') -- Close buffer.
vim.keymap.set('n', '-', ':Ex $PWD<cr>') -- Poor man's vinegar (better since not relative to file).
-- Move buffers with tab and s-tab:
vim.keymap.set('n', '<s-tab>', ':bprevious<cr>')
vim.keymap.set('n', '<tab>', ':bnext<cr>')
-- 'y' uses system clipboard:
vim.keymap.set("n", "y", [["+y]])
vim.keymap.set("v", "y", [["+y]])
-- vim.cmd([[
--   nnoremap <silent><m-1> <Cmd>BufferLineGoToBuffer 1<CR>
--   nnoremap <silent><m-2> <Cmd>BufferLineGoToBuffer 2<CR>
--   nnoremap <silent><m-3> <Cmd>BufferLineGoToBuffer 3<CR>
--   nnoremap <silent><m-4> <Cmd>BufferLineGoToBuffer 4<CR>
--   nnoremap <silent><m-5> <Cmd>BufferLineGoToBuffer 5<CR>
--   nnoremap <silent><m-6> <Cmd>BufferLineGoToBuffer 6<CR>
--   nnoremap <silent><m-7> <Cmd>BufferLineGoToBuffer 7<CR>
--   nnoremap <silent><m-8> <Cmd>BufferLineGoToBuffer 8<CR>
--   nnoremap <silent><m-9> <Cmd>BufferLineGoToBuffer 9<CR>
--   nnoremap <silent><m-0> <Cmd>BufferLineGoToBuffer -1<CR>
-- ]])

vim.cmd.filetype("on")
vim.cmd.syntax("on")

vim.cmd([[
  colorscheme highlightcx
  colorscheme fix
]])

vim.g.netrw_banner = 0
vim.g.netrw_hide = 1
vim.g.netrw_liststyle = 3 -- Start in tree mode.
vim.o.autowrite = true
-- vim.o.backup = true -- "Who needs backups?" --me (I needed a backup.)
vim.o.belloff = "" -- Vim default.
vim.o.breakindent = true
vim.o.confirm = true -- Have destructive commands y-n prompt instead of fail.
vim.o.encoding = "utf-8"
vim.o.foldenable = false
vim.o.foldlevelstart = 99
vim.o.foldmethod = "indent"
vim.o.formatoptions = "roqlj" -- See fo-table.
vim.o.guicursor = ""
vim.o.hidden = false
vim.o.hlsearch = true
vim.o.ignorecase = false
vim.o.joinspaces = false -- Single space after a period.
vim.o.lazyredraw = true -- No redrawing while executing macros.
vim.o.linebreak = true
vim.o.list = false
vim.o.listchars = "tab:>  ,lead:-,trail:-,extends:@,precedes:@,nbsp:-"
vim.o.modeline = false
vim.o.mouse = ""
vim.o.nrformats = "alpha,bin,hex" -- Enable CTRL-A for letters, don't treat leading 0s as a base 8 marker.
vim.o.number = false
vim.o.number = true
vim.o.report = 0 -- Always report number of lines changed, no arbitrary threshhold.
vim.o.secure = true -- Unnecesary but just in case, see trojan-horse.
vim.o.shiftround = true -- Round indent to shiftwidth.
vim.o.shiftwidth = 8
vim.o.showfulltag = true
vim.o.showmode = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.startofline = false
vim.o.textwidth = 80
vim.o.undofile = true
vim.o.virtualedit = "all" -- Viaje de ida.
vim.o.wrap = false
vim.o.wrapscan = false -- /, * and friends don't wrap around the file. (--search hit BOTTOM, continuing at TOP--)
