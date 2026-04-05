vim.cmd.colorscheme("citra")

local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local opt = vim.opt
local opt_local = vim.opt_local

local colors = vim.g.citra_colors

-- ===========================================================================
-- EDITOR OPTIONS
-- ===========================================================================

local options = {
	termguicolors = true,
	number = true,
	relativenumber = true,
	cursorline = true,
	cursorlineopt = "both",
	wrap = false,
	scrolloff = 10,
	sidescrolloff = 10,
	tabstop = 4,
	shiftwidth = 4,
	softtabstop = 4,
	expandtab = true,
	smartindent = true,
	autoindent = true,
	ignorecase = true,
	smartcase = true,
	hlsearch = true,
	incsearch = true,
	signcolumn = "yes",
	colorcolumn = "80",
	showmatch = true,
	cmdheight = 1,
	completeopt = "menuone,noinsert,noselect,popup",
	showmode = false,
	pumheight = 10,
	pumblend = 10,
	winblend = 0,
	conceallevel = 0,
	concealcursor = "",
	synmaxcol = 300,
	fillchars = { eob = " " },
	backup = false,
	writebackup = false,
	swapfile = false,
	undofile = true,
	updatetime = 300,
	timeoutlen = 500,
	ttimeoutlen = 0,
	autowrite = false,
	autoread = true,
	hidden = true,
	errorbells = false,
	backspace = "indent,eol,start",
	autochdir = false,
	selection = "inclusive",
	mouse = "a",
	foldmethod = "expr",
	foldexpr = "v:lua.vim.treesitter.foldexpr()",
	foldlevel = 99,
	splitbelow = true,
	splitright = true,
	wildmenu = true,
	wildmode = "longest:full,full",
	redrawtime = 10000,
	maxmempattern = 20000,
	guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20",
}

for name, value in pairs(options) do
	opt[name] = value
end

opt.iskeyword:append("-")
opt.path:append("**")
opt.clipboard:append("unnamedplus")
opt.diffopt:append("linematch:60")

local undodir = fn.expand("~/.cache/nvim/undodir")
if fn.isdirectory(undodir) == 0 then
	fn.mkdir(undodir, "p")
end
opt.undodir = undodir

-- ===========================================================================
-- STATUSLINE
-- ===========================================================================

local mode_names = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
	R = "REPLACE",
	r = "REPLACE",
	["!"] = "SHELL",
	t = "TERMINAL",
}

function _G.user_mode()
	local current = fn.mode()
	return mode_names[current] or (" " .. current)
end

function _G.user_file_type()
	return vim.bo.filetype
end

api.nvim_set_hl(0, "StatusLineBold", { bold = true })

local active_statusline = table.concat({
	" %#StatusLineBold#",
	"%{v:lua.user_mode()} ",
	"%#StatusLine#",
	"@ %f ",
	"%=",
	"%{v:lua.user_file_type()} ",
	"%l:%c ",
})

local inactive_statusline = " %f %= %{v:lua.user_file_type()} %l:%c "

api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	callback = function()
		opt_local.statusline = active_statusline
	end,
})

api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	callback = function()
		opt_local.statusline = inactive_statusline
	end,
})

-- ===========================================================================
-- TABLINE
-- ===========================================================================

local function build_name_count()
	local counts = {}
	for _, tabnr in ipairs(api.nvim_list_tabpages()) do
		local win = api.nvim_tabpage_get_win(tabnr)
		local buf = api.nvim_win_get_buf(win)
		local full_name = api.nvim_buf_get_name(buf)
		local key = full_name == "" and "[No Name]" or fn.fnamemodify(full_name, ":t")

		counts[key] = (counts[key] or 0) + 1
	end
	return counts
end

local function tab_label(bufnr, counts)
	local full_name = api.nvim_buf_get_name(bufnr)
	if full_name == "" then
		return "[No Name]"
	end

	local base = fn.fnamemodify(full_name, ":t")
	if (counts[base] or 0) > 1 then
		return fn.fnamemodify(full_name, ":.")
	end
	return base
end

function _G.MyTabLine()
	local parts = {}
	local counts = build_name_count()
	local current = api.nvim_get_current_tabpage()

	for i, tabnr in ipairs(api.nvim_list_tabpages()) do
		local hl = tabnr == current and "%#TabLineSel#" or "%#TabLine#"
		local win = api.nvim_tabpage_get_win(tabnr)
		local buf = api.nvim_win_get_buf(win)
		parts[#parts + 1] = hl
		parts[#parts + 1] = "%" .. i .. "T " .. i
		parts[#parts + 1] = ": " .. tab_label(buf, counts) .. " "
	end

	parts[#parts + 1] = "%#TabLineFill#%T"
	return table.concat(parts)
end

opt.showtabline = 2
opt.tabline = "%!v:lua.MyTabLine()"

-- ===========================================================================
-- KEYMAPS
-- ===========================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function map(mode, lhs, rhs, desc, extra)
	local opts = vim.tbl_extend("force", { silent = true, desc = desc }, extra or {})
	keymap.set(mode, lhs, rhs, opts)
end

map("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, "Down (wrap-aware)", { expr = true })

map("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, "Up (wrap-aware)", { expr = true })

map("n", "<leader>sh", "<cmd>nohlsearch<cr><cmd>let @/ = ''<cr>", "Clear search highlights")

map("n", "n", "nzzzv", "Next search result (centered)")
map("n", "N", "Nzzzv", "Previous search result (centered)")
map("n", "<C-d>", "<C-d>zz", "Half page down (centered)")
map("n", "<C-u>", "<C-u>zz", "Half page up (centered)")

map("x", "<leader>p", '"_dP', "Paste without yanking")
map({ "n", "v" }, "<leader>x", '"_d', "Delete without yanking")

map("n", "<leader>bn", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>bp", "<cmd>bprevious<cr>", "Previous buffer")

map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-j>", "<C-w>j", "Move to bottom window")
map("n", "<C-k>", "<C-w>k", "Move to top window")
map("n", "<C-l>", "<C-w>l", "Move to right window")

map("n", "<leader>vs", "<cmd>vsplit<cr>", "Split window vertically")
map("n", "<leader>hs", "<cmd>split<cr>", "Split window horizontally")
map("n", "<C-Up>", "<cmd>resize +1<cr>", "Increase window height")
map("n", "<C-Down>", "<cmd>resize -1<cr>", "Decrease window height")
map("n", "<C-Left>", "<cmd>vertical resize -1<cr>", "Decrease window width")
map("n", "<C-Right>", "<cmd>vertical resize +1<cr>", "Increase window width")

map("n", "<A-j>", "<cmd>m .+1<cr>==", "Move line down")
map("n", "<A-k>", "<cmd>m .-2<cr>==", "Move line up")
map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Move selection up")

map("v", "<", "<gv", "Indent left and reselect")
map("v", ">", ">gv", "Indent right and reselect")
map("n", "<", "<<", "Indent left")
map("n", ">", ">>", "Indent right")
map("n", "J", "mzJ`z", "Join lines and keep cursor position")

map("n", "<leader>pa", function()
	local path = fn.expand("%:p")
	fn.setreg("+", path)
	print(path)
end, "Copy full file path")

map("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, "Toggle diagnostics")

for _, arrow in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
	keymap.set({ "n", "i", "v" }, arrow, "<Nop>")
end

keymap.set("c", "<Up>", "<Nop>")
keymap.set("c", "<Down>", "<Nop>")
map("c", "<C-j>", "<Up>", "Command-line history previous")
map("c", "<C-k>", "<Down>", "Command-line history next")

map("n", "<leader>vt", "<cmd>vsplit<cr><cmd>term<cr>i", "Vertical term")
map("n", "<leader>ht", "<cmd>split<cr><cmd>term<cr>i", "Horizontal term")
keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- ===========================================================================
-- AUTOCMDS
-- ===========================================================================

local augroup = api.nvim_create_augroup("UserConfig", { clear = true })

api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then
			return
		end

		local last_pos = api.nvim_buf_get_mark(0, '"')
		local last_line = api.nvim_buf_line_count(0)
		local row = last_pos[1]

		if row < 1 or row > last_line then
			return
		end

		pcall(api.nvim_win_set_cursor, 0, last_pos)
	end,
})

api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		opt_local.wrap = true
		opt_local.linebreak = true
		opt_local.spell = true
	end,
})

-- ===========================================================================
-- PLUGINS (vim.pack)
-- ===========================================================================

vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/echasnovski/mini.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/SRCthird/minintro.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/petertriho/nvim-scrollbar",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/github/copilot.vim",
	"https://github.com/olimorris/codecompanion.nvim",
})

-- ===========================================================================
-- TREESITTER
-- ===========================================================================

local function setup_treesitter()
	local treesitter = require("nvim-treesitter")
	local ts_config = require("nvim-treesitter.config")

	treesitter.setup({})

	local ensure_installed = {
		"rust",
		"c",
		"cpp",
		"html",
		"css",
		"javascript",
		"json",
		"yaml",
		"lua",
		"markdown",
		"python",
		"typescript",
		"bash",
		"java",
	}

	local installed = ts_config.get_installed()
	local to_install = {}
	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(installed, parser) then
			to_install[#to_install + 1] = parser
		end
	end
	if #to_install > 0 then
		treesitter.install(to_install)
	end

	local group = api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			local ok, lang = pcall(vim.treesitter.language.get_lang, args.match)
			if not ok or not lang then
				return
			end
			if vim.tbl_contains(treesitter.get_installed(), lang) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()

-- ===========================================================================
-- FZF-LUA
-- ===========================================================================

local fzf = require("fzf-lua")
local fzf_actions = fzf.actions

fzf.setup({
	defaults = {
		file_icons = "mini",
	},
	winopts = {
		border = "rounded",
		backdrop = 100,
		preview = {
			border = "rounded",
			layout = "vertical",
			vertical = "down:60%",
			winopts = {
				number = true,
				relativenumber = true,
				cursorline = true,
				cursorlineopt = "both",
			},
		},
	},
	actions = {
		files = {
			default = function(items, opts_)
				local buf_name = api.nvim_buf_get_name(0)
				if buf_name == "" or buf_name:match("minintro$") then
					fzf_actions.file_edit(items, opts_)
					return
				end
				fzf_actions.file_tabedit(items, opts_)
			end,
			["ctrl-s"] = fzf_actions.file_split,
			["ctrl-v"] = fzf_actions.file_vsplit,
			["ctrl-f"] = fzf_actions.file_edit,
		},
	},
	fzf_colors = { true },
})

fzf.register_ui_select()

map("n", "<leader>ff", fzf.files, "FZF Files")
map("n", "<leader>fg", fzf.live_grep, "FZF Live Grep")
map("n", "<leader>fb", fzf.buffers, "FZF Buffers")
map("n", "<leader>fh", fzf.help_tags, "FZF Help Tags")
map("n", "<leader>fx", fzf.diagnostics_document, "FZF Diagnostics Document")
map("n", "<leader>fX", fzf.diagnostics_workspace, "FZF Diagnostics Workspace")

-- ===========================================================================
-- MINI.NVIM + INTRO
-- ===========================================================================

for _, module in ipairs({
	"ai",
	"comment",
	"move",
	"surround",
	"cursorword",
	"pairs",
	"trailspace",
	"bufremove",
}) do
	require("mini." .. module).setup({})
end

require("mini.notify").setup({
	lsp_progress = { enable = true },
	window = { config = { border = "rounded" } },
})

require("mini.icons").setup({ style = "ascii" })

local mini_trailspace = require("mini.trailspace")
map("n", "<A-T>", mini_trailspace.trim, "Trim trailing spaces")

local function split_lines(value)
	local result = {}
	for line in (value or ""):gmatch("([^\n]*)\n?") do
		if line == "" and #result > 0 and result[#result] == "" then
			break
		end
		result[#result + 1] = line
	end
	return result
end

local function get_hostname_logo()
	local cmd = "fastfetch --structure none"
	local logo = fn.system(cmd)
	logo = logo:gsub("\27%[[0-9;]*[a-zA-Z]", "")
	logo = logo:gsub("%s+$", "")
	logo = logo:gsub("\r\n", "\n")
	return split_lines(logo)
end

local color_map = {
	lenstra = "#BE133C",
	winawer = "#EBB305",
	marhaen = "#0CA5E9",
	maclaurin = "#8B5CF6",
}

local hostname = (vim.uv or vim.loop).os_gethostname():gsub("%..*", "")
hostname = hostname:lower()

require("minintro").setup({
	title = get_hostname_logo(),
	version = { "" },
	info = { "" },
	colors = { color_map[hostname] },
})

local startup = false
local dashboard_mode = false

local function set_cursor_blend(value)
	local hl = api.nvim_get_hl(0, { name = "Cursor", link = false })
	hl.blend = value
	api.nvim_set_hl(0, "Cursor", hl)
end

local function set_dashboard_ui(enabled)
	if dashboard_mode == enabled then
		return
	end
	dashboard_mode = enabled

	if enabled then
		mini_trailspace.unhighlight()
		opt.cursorline = false
		set_cursor_blend(100)
		opt.guicursor:append("a:Cursor/lCursor")
		opt.laststatus = 0
		opt.cmdheight = 0
		opt.showtabline = 0
		return
	end

	opt.cursorline = true
	set_cursor_blend(0)
	opt.guicursor:remove("a:Cursor/lCursor")
	opt.laststatus = 3
	opt.cmdheight = 1
	opt.showtabline = 2
end

api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "*",
	callback = function()
		local buf_name = api.nvim_buf_get_name(0)
		local show_intro = (buf_name == "" and not startup) or buf_name:match("minintro$")

		if show_intro then
			set_dashboard_ui(true)
		else
			set_dashboard_ui(false)
		end

		startup = true
	end,
})

-- ===========================================================================
-- GITSIGNS + SCROLLBAR
-- ===========================================================================

local gitsigns = require("gitsigns")
gitsigns.setup({
	signcolumn = true,
	current_line_blame = false,
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	numhl = false,
	linehl = false,
})

map("n", "[h", gitsigns.prev_hunk, "Previous hunk")
map("n", "]h", gitsigns.next_hunk, "Next hunk")
map("n", "<leader>hg", gitsigns.stage_hunk, "Stage hunk")
map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
map("n", "<leader>hb", function()
	gitsigns.blame_line({ full = true })
end, "Blame line")
map("n", "<leader>hB", gitsigns.toggle_current_line_blame, "Toggle inline blame")
map("n", "<leader>hd", gitsigns.diffthis, "Diff this")

map("n", "<leader>dw", function()
	vim.diagnostic.setloclist({ open = true })
end, "Open diagnostic list")
map("n", "<leader>dl", vim.diagnostic.open_float, "Show line diagnostics")

require("scrollbar").setup({
	show_in_active_only = true,
	handle = {
		color = colors.bg3,
	},
	handlers = {
		cursor = false,
	},
})
require("scrollbar.handlers.gitsigns").setup({})

-- ===========================================================================
-- LSP, FORMATTING, LINTING, COMPLETION
-- ===========================================================================

local diagnostic_signs = {
	Error = "E",
	Warn = "W",
	Hint = "H",
	Info = "I",
}

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

do
	local orig_open = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig_open(contents, syntax, opts, ...)
	end
end

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local lsp_opts = { noremap = true, silent = true, buffer = bufnr }

	keymap.set("n", "<leader>gS", function()
		vim.cmd.vsplit()
		vim.lsp.buf.definition()
	end, lsp_opts)

	keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, lsp_opts)
	keymap.set("n", "<leader>rn", vim.lsp.buf.rename, lsp_opts)
	keymap.set("n", "K", vim.lsp.buf.hover, lsp_opts)

	keymap.set("n", "<leader>D", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, lsp_opts)
	keymap.set("n", "<leader>d", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, lsp_opts)
	keymap.set("n", "<leader>nd", function()
		vim.diagnostic.jump({ count = 1 })
	end, lsp_opts)
	keymap.set("n", "<leader>pd", function()
		vim.diagnostic.jump({ count = -1 })
	end, lsp_opts)

	keymap.set("n", "<leader>fd", fzf.lsp_definitions, lsp_opts)
	keymap.set("n", "<leader>fD", vim.lsp.buf.definition, lsp_opts)
	keymap.set("n", "<leader>fr", fzf.lsp_references, lsp_opts)
	keymap.set("n", "<leader>ft", fzf.lsp_typedefs, lsp_opts)
	keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, lsp_opts)
	keymap.set("n", "<leader>fw", fzf.lsp_workspace_symbols, lsp_opts)
	keymap.set("n", "<leader>fi", fzf.lsp_implementations, lsp_opts)

	if client:supports_method("textDocument/codeAction", bufnr) then
		keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "source.organizeImports" },
					diagnostics = {},
				},
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, lsp_opts)
	end
end

api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = lsp_on_attach,
})

require("mason").setup({})

require("mason-lspconfig").setup({
	ensure_installed = {
		"rust_analyzer",
		"clangd",
		"html",
		"cssls",
		"ts_ls",
		"jsonls",
		"lua_ls",
		"marksman",
		"pyright",
		"bashls",
		"jdtls",
		"efm",
	},
	automatic_installation = true,
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"luacheck",
		"black",
		"flake8",
		"prettierd",
		"eslint_d",
		"fixjson",
		"shfmt",
		"shellcheck",
		"clang-format",
		"cpplint",
		"google-java-format",
	},
	auto_update = true,
	run_on_start = true,
})

do
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")
	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local eslint_d = require("efmls-configs.linters.eslint_d")
	local fixjson = require("efmls-configs.formatters.fixjson")
	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")
	local clangfmt = require("efmls-configs.formatters.clang_format")
	local cpplint = require("efmls-configs.linters.cpplint")
	local rustfmt = require("efmls-configs.formatters.rustfmt")
	local gjf = require("efmls-configs.formatters.google_java_format")

	vim.lsp.config("efm", {
		filetypes = {
			"rust",
			"c",
			"cpp",
			"html",
			"css",
			"javascript",
			"typescript",
			"json",
			"lua",
			"markdown",
			"python",
			"sh",
			"java",
		},
		init_options = { documentFormatting = true },
		settings = {
			languages = {
				rust = { rustfmt },
				c = { clangfmt, cpplint },
				cpp = { clangfmt, cpplint },
				java = { gjf },
				html = { prettier_d },
				css = { prettier_d },
				javascript = { eslint_d, prettier_d },
				typescript = { eslint_d, prettier_d },
				javascriptreact = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },
				json = { eslint_d, fixjson },
				jsonc = { eslint_d, fixjson },
				lua = { luacheck, stylua },
				markdown = { prettier_d },
				python = { flake8, black },
				sh = { shellcheck, shfmt },
			},
		},
	})
end

api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = {
		"*.lua",
		"*.py",
		"*.go",
		"*.js",
		"*.jsx",
		"*.ts",
		"*.tsx",
		"*.json",
		"*.css",
		"*.scss",
		"*.html",
		"*.sh",
		"*.bash",
		"*.zsh",
		"*.c",
		"*.cpp",
		"*.h",
		"*.hpp",
	},
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		if not vim.bo[args.buf].modifiable then
			return
		end
		if api.nvim_buf_get_name(args.buf) == "" then
			return
		end

		local has_efm = false
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if client.name == "efm" then
				has_efm = true
				break
			end
		end
		if not has_efm then
			return
		end

		pcall(vim.lsp.buf.format, {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(client)
				return client.name == "efm"
			end,
		})
	end,
})

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<Tab>"] = { "accept", "fallback" },
		["<A-Esc>"] = { "show", "hide", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
	},
	completion = {
		menu = {
			scrollbar = false,
			auto_show = true,
			border = "rounded",
			draw = {
				columns = {
					{ "kind_icon", "label", "label_description", gap = 1 },
				},
				components = {
					kind_icon = {
						ellipsis = false,
						text = function(ctx)
							local icon = require("mini.icons").get("lsp", ctx.kind)
							return icon
						end,
						highlight = function(ctx)
							local _, hl = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
				},
			},
		},
		documentation = {
			auto_show = true,
			window = { border = "rounded" },
		},
	},
	sources = {
		default = { "lsp", "path", "buffer", "snippets" },
	},
	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})

require("lspconfig")["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

-- ===========================================================================
-- AI INTEGRATIONS
-- ===========================================================================

require("codecompanion").setup({
	display = {
		chat = {
			intro_message = "",
			separator = "─",
			show_context = true,
			show_header_separator = true,
			show_settings = false,
			show_token_count = true,
			show_tools_processing = true,
			start_in_insert_mode = false,
			window = {
				sticky = true,
				width = 0.35,
				opts = {
					cursorline = true,
					cursorlineopt = "both",
					colorcolumn = "",
				},
			},
		},
		action_palette = { provider = "fzf_lua" },
		diff = {
			enabled = true,
			window = {
				width = function()
					return math.min(120, vim.o.columns - 10)
				end,
				height = function()
					return vim.o.lines - 4
				end,
				opts = {
					number = true,
					relativenumber = true,
					cursorline = true,
					cursorlineopt = "both",
					colorcolumn = "",
				},
			},
			word_highlights = {
				additions = true,
				deletions = true,
			},
		},
	},
	adapters = {
		http = {
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "gpt-5.3-codex",
						},
					},
				})
			end,
		},
	},
	interactions = {
		chat = { adapter = "copilot" },
		inline = { adapter = "copilot" },
	},
})

keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
