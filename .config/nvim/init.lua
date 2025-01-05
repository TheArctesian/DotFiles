-- Set basic options
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 4 -- Tab width
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Auto indent new lines
vim.opt.wrap = true -- Don't wrap lines
vim.opt.swapfile = false -- Don't create swap files
vim.opt.backup = false -- Don't create backup files
vim.opt.hlsearch = true -- Don't highlight searches
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.termguicolors = true -- True color support
vim.opt.scrolloff = 8 -- Keep 8 lines above/below cursor
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.clipboard = "unnamedplus"
-- Set leader key
vim.g.mapleader = " " -- Space as leader key

-- Basic keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>") -- Save with space+w
vim.keymap.set("n", "<leader>q", ":q<CR>") -- Quit with space+q
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>") -- Clear search highlights
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Keep cursor in middle when jumping
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Keep cursor in middle when jumping

-- Plugin management
require("packer").startup(function(use)
	-- Package manager
	use("wbthomason/packer.nvim")

	-- Essential plugins
	use("nvim-lua/plenary.nvim") -- Required by many plugins

	-- Fuzzy finder and file navigation
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("nvim-telescope/telescope-file-browser.nvim")

	-- File tree
	use({
		"nvim-tree/nvim-tree.lua",
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	-- Syntax highlighting and parsing
	use("nvim-treesitter/nvim-treesitter")
	use("nvim-treesitter/nvim-treesitter-context")

	-- LSP and autocompletion
	use("neovim/nvim-lspconfig")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")

	-- Git integration
	use("lewis6991/gitsigns.nvim")
	use("tpope/vim-fugitive")

	-- Quality of life improvements
	use("windwp/nvim-autopairs")
	use("numToStr/Comment.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("folke/which-key.nvim")

	-- Status line and visual improvements
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use("akinsho/bufferline.nvim")

	-- Theme
	use("shaunsingh/nord.nvim")

	-- Formatting
	use("mhartington/formatter.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
end)

-- Set colorscheme
vim.cmd([[colorscheme nord]])

-- Make background transparent
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "MsgArea", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

-- Telescope configuration
require("telescope").setup({})
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Nvim-tree configuration
require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Treesitter configuration
require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "vim", "javascript", "typescript", "python" },
	highlight = {
		enable = true,
	},
})

-- LSP and completion configuration
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

-- Setup language servers
lspconfig.pyright.setup({ capabilities = capabilities })
-- Completion setup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

-- Lualine configuration
require("lualine").setup({
	options = {
		theme = "nord",
		icons_enabled = true,
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- Gitsigns configuration
require("gitsigns").setup()

-- Autopairs configuration
require("nvim-autopairs").setup({})

-- Comment.nvim configuration
require("Comment").setup()

-- Which-key configuration
require("which-key").setup({})

-- Bufferline configuration
require("bufferline").setup({
	options = {
		diagnostics = "nvim_lsp",
		offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
	},
})

-- Updated indent-blankline configuration (v3)
local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}

local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup({
	indent = {
		char = "▏",
	},
	scope = {
		enabled = true,
		show_start = true,
		show_end = false,
		highlight = highlight,
	},
})

-- Formatter configuration
require("formatter").setup({
	filetype = {
		lua = {
			function()
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						vim.api.nvim_buf_get_name(0),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},
		javascript = {
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end,
		},
		typescript = {
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end,
		},
		python = {
			function()
				return {
					exe = "black",
					args = { "-" },
					stdin = true,
				}
			end,
		},
	},
})

-- Format on save
vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]],
	true
)

-- LSP Format on save
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
