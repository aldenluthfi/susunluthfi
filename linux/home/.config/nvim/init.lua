vim.cmd.colorscheme("citra")
local colors = vim.g.citra_colors

-- ============================================================================
-- OPTIONS
-- ============================================================================
vim.opt.termguicolors = true
vim.opt.number = true -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- highlight current line
vim.opt.cursorlineopt = "both" -- highlight both number and line
vim.opt.wrap = false -- do not wrap lines by default
vim.opt.scrolloff = 10 -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10 -- keep 10 lines to left/right of cursor

vim.opt.tabstop = 4 -- tabwidth
vim.opt.shiftwidth = 4 -- indent width
vim.opt.softtabstop = 4 -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smartindent = true -- smart auto-indent
vim.opt.autoindent = true -- copy indent from current line

vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case sensitive if uppercase in string
vim.opt.hlsearch = true -- highlight search matches
vim.opt.incsearch = true -- show matches as you type

vim.opt.signcolumn = "yes" -- always show a sign column
vim.opt.colorcolumn = "80" -- show a column at 100 position chars
vim.opt.showmatch = true -- highlights matching brackets
vim.opt.cmdheight = 1 -- single line command line
vim.opt.completeopt = "menuone,noinsert,noselect,popup" -- completion options
vim.opt.showmode = false -- do not show the mode, instead have it in statusline
vim.opt.pumheight = 10 -- popup menu height
vim.opt.pumblend = 10 -- popup menu transparency
vim.opt.winblend = 0 -- floating window transparency
vim.opt.conceallevel = 0 -- do not hide markup
vim.opt.concealcursor = "" -- do not hide cursorline in markup
vim.opt.synmaxcol = 300 -- syntax highlighting limit
vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines

local undodir = vim.fn.expand("~/.cache/nvim/undodir")
if
	vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false -- do not create a backup file
vim.opt.writebackup = false -- do not write to a backup file
vim.opt.swapfile = false -- do not create a swapfile
vim.opt.undofile = true -- do create an undo file
vim.opt.undodir = undodir -- set the undo directory
vim.opt.updatetime = 300 -- faster completion
vim.opt.timeoutlen = 500 -- timeout duration
vim.opt.ttimeoutlen = 0 -- key code timeout
vim.opt.autoread = true -- auto-reload changes if outside of neovim
vim.opt.autowrite = false -- do not auto-save

vim.opt.hidden = true -- allow hidden buffers
vim.opt.errorbells = false -- no error sounds
vim.opt.backspace = "indent,eol,start" -- better backspace behaviour
vim.opt.autochdir = false -- do not autochange directories
vim.opt.iskeyword:append("-") -- include - in words
vim.opt.path:append("**") -- include subdirs in search
vim.opt.selection = "inclusive" -- include last char in selection
vim.opt.mouse = "a" -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard

-- Folding: requires treesitter available at runtime; safe fallback if not
vim.opt.foldmethod = "expr" -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter folding
vim.opt.foldlevel = 99 -- start with all folds open

vim.opt.splitbelow = true -- horizontal splits go below
vim.opt.splitright = true -- vertical splits go right

vim.opt.wildmenu = true -- tab completion
vim.opt.wildmode = "longest:full,full" -- complete longest common match
vim.opt.diffopt:append("linematch:60") -- improve diff display
vim.opt.redrawtime = 10000 -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000 -- increase max memory

-- Non blinking cursor
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- ============================================================================
-- STATUSLINE
-- ============================================================================

local function file_type()
	return vim.bo.filetype
end

local function mode()
	local mode = vim.fn.mode()
	local modes = {
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
	return modes[mode] or (" " .. mode)
end

_G.mode = mode
_G.file_type = file_type

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		callback = function()
			vim.opt_local.statusline = table.concat({
				" %#StatusLineBold#",
				"%{v:lua.mode()} ",
				"%#StatusLine#",
				"@ %f ",
				"%=", -- Right-align everything after this
				"%{v:lua.file_type()} ",
				"%l:%c ",
			})
		end,
	})
	vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			vim.opt_local.statusline = " %f %= %{v:lua.file_type()} %l:%c "
		end,
	})
end

setup_dynamic_statusline()

-- ============================================================================
-- TABLINE
-- ============================================================================

local function build_name_count()
	local counts = {}
	for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
		local win = vim.api.nvim_tabpage_get_win(tabnr)
		local buf = vim.api.nvim_win_get_buf(win)
		local full = vim.api.nvim_buf_get_name(buf)

		local key
		if full == "" then
			key = "[No Name]"
		else
			key = vim.fn.fnamemodify(full, ":t")
		end

		counts[key] = (counts[key] or 0) + 1
	end
	return counts
end

local function tab_label(bufnr, counts)
	local full = vim.api.nvim_buf_get_name(bufnr)
	if full == "" then
		return "[No Name]"
	end

	local base = vim.fn.fnamemodify(full, ":t")
	if (counts[base] or 0) > 1 then
		return vim.fn.fnamemodify(full, ":.")
	end
	return base
end

function _G.MyTabLine()
	local s = ""
	local counts = build_name_count()

	for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
		local hl = (tabnr == vim.api.nvim_get_current_tabpage()) and "%#TabLineSel#" or "%#TabLine#"
		local win = vim.api.nvim_tabpage_get_win(tabnr)
		local buf = vim.api.nvim_win_get_buf(win)

		s = s .. hl .. "%" .. i .. "T " .. i .. ": " .. tab_label(buf, counts) .. " "
	end

	s = s .. "%#TabLineFill#%T"
	return s
end

vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.MyTabLine()"

-- ============================================================================
-- KEYMAPS
-- ============================================================================

vim.g.mapleader = " " -- space for leader
vim.g.maplocalleader = " " -- space for localleader

-- better movement in wrapped text
vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

vim.keymap.set("n", "<leader>sh", ":nohlsearch<CR>:let @/ = ''<CR>", {
	desc = "Clear search highlights",
})

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set("n", "<leader>vs", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>hs", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +1<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -1<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -1<CR>", {
	desc = "Decrease window width",
})
vim.keymap.set("n", "<C-Right>", ":vertical resize +1<CR>", {
	desc = "Increase window width",
})

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
vim.keymap.set("n", "<", "<<", { desc = "indent left" })
vim.keymap.set("n", ">", ">>", { desc = "Indent right" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

vim.keymap.set("n", "<leader>pa", function() -- show file path
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print(path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- force use h,j,k,l
vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>")

vim.keymap.set("c", "<Up>", "<Nop>")
vim.keymap.set("c", "<Down>", "<Nop>")
vim.keymap.set("c", "<C-j>", "<Up>", { desc = "Command-line history previous" })
vim.keymap.set("c", "<C-k>", "<Down>", { desc = "Command-line history next" })

vim.keymap.set("n", "<leader>vt", ":vsplit<CR>:term<CR>i")
vim.keymap.set("n", "<leader>ht", ":split<CR>:term<CR>i")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- ============================================================================
-- AUTOCMDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================

local function packadd(name)
	vim.cmd("packadd " .. name)
end

vim.pack.add({
	"https://www.github.com/lewis6991/gitsigns.nvim",
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/SRCthird/minintro.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/petertriho/nvim-scrollbar",

	-- Language Server Protocols (LSP)
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},

	-- Copilot and CodeCompanion
	"https://github.com/github/copilot.vim",
	"https://github.com/olimorris/codecompanion.nvim",
})

packadd("nvim-treesitter")
packadd("gitsigns.nvim")
packadd("mini.nvim")
packadd("fzf-lua")
packadd("plenary.nvim")
packadd("minintro.nvim")
packadd("nvim-scrollbar")

-- LSP
packadd("nvim-lspconfig")
packadd("mason.nvim")
packadd("mason-lspconfig.nvim")
packadd("mason-tool-installer.nvim")
packadd("efmls-configs-nvim")
packadd("blink.cmp")

-- Copilot and CodeCompanion
packadd("copilot.vim")
packadd("codecompanion.nvim")

-- ============================================================================
-- PLUGIN CONFIGS
-- ============================================================================

local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
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

	local config = require("nvim-treesitter.config")

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()

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
		["files"] = {
			["default"] = function(ipairs, opts)
				local buf_name = vim.api.nvim_buf_get_name(0)

				if buf_name == "" or buf_name:match("minintro$") then
					fzf_actions.file_edit(ipairs, opts)
				else
					fzf_actions.file_tabedit(ipairs, opts)
				end
			end,
			["ctrl-s"] = fzf_actions.file_split,
			["ctrl-v"] = fzf_actions.file_vsplit,
			["ctrl-f"] = fzf_actions.file_edit,
		},
		["buffers"] = {
			["default"] = fzf_actions.buf_tabedit,
			["ctrl-s"] = fzf_actions.buf_split,
			["ctrl-v"] = fzf_actions.buf_vsplit,
			["ctrl-f"] = fzf_actions.buf_edit,
		},
	},
	fzf_colors = { true },
})
fzf.register_ui_select()

vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", fzf.diagnostics_document, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", fzf.diagnostics_workspace, { desc = "FZF Diagnostics Workspace" })

require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({
	lsp_progress = { enable = true },
	window = { config = { border = "rounded" } },
})
require("mini.icons").setup({ style = "ascii" })

vim.keymap.set("n", "<A-T>", require("mini.trailspace").trim)

function string:split(delimiter)
	local result = {}
	local from = 1
	local delim_from, delim_to = string.find(self, delimiter, from)
	while delim_from do
		table.insert(result, string.sub(self, from, delim_from - 1))
		from = delim_to + 1
		delim_from, delim_to = string.find(self, delimiter, from)
	end
	table.insert(result, string.sub(self, from))
	return result
end

local function get_hostname_logo()
	local logo = vim.fn.system('fastfetch --structure none | sed "s/\x1b[[0-9;]*[a-zA-Z]//g"')
	logo = logo:gsub("%s+$", "")
	logo = logo:gsub("\r\n", "\n")

	return logo:split("\n")
end

local color_map = {
	lenstra = "#BE133C",
	winawer = "#EBB305",
	marhaen = "#0CA5E9",
	maclaurin = "#8B5CF6",
}

require("minintro").setup({
	title = get_hostname_logo(),
	version = { "" },
	info = { "" },
	colors = { color_map[vim.loop.os_gethostname():gsub("%..*", ""):lower()] },
})

local startup = false
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "*",
	callback = function()
		local buf_name = vim.api.nvim_buf_get_name(0)

		if (buf_name == "" and not startup) or buf_name:match("minintro$") then
			require("mini.trailspace").unhighlight()
			vim.opt.cursorline = false
			local hl = vim.api.nvim_get_hl_by_name("Cursor", true)
			hl.blend = 100
			vim.api.nvim_set_hl(0, "Cursor", hl)
			vim.opt.guicursor:append("a:Cursor/lCursor")
			vim.opt.laststatus = 0
			vim.opt.cmdheight = 0
			vim.opt.showtabline = 0

			if buf_name == "" then
				startup = true
			end
		else
			vim.opt.cursorline = true
			local hl = vim.api.nvim_get_hl_by_name("Cursor", true)
			hl.blend = 0
			vim.api.nvim_set_hl(0, "Cursor", hl)
			vim.opt.guicursor:remove("a:Cursor/lCursor")
			vim.opt.laststatus = 3
			vim.opt.cmdheight = 1
			vim.opt.showtabline = 2
			startup = true
		end
	end,
})

require("gitsigns").setup({
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

vim.keymap.set("n", "<leader>hg", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })

vim.keymap.set("n", "<leader>hr", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })

vim.keymap.set("n", "<leader>hp", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })

vim.keymap.set("n", "<leader>hb", function()
	require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })

vim.keymap.set("n", "<leader>hB", function()
	require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle inline blame" })

vim.keymap.set("n", "<leader>hd", function()
	require("gitsigns").diffthis()
end, { desc = "Diff this" })

vim.keymap.set("n", "<leader>dw", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })

vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, {
	desc = "Show line diagnostics",
})

vim.keymap.set("n", "<leader>cc", function()
	require("CopilotChat").toggle()
end, { desc = "Toggle Copilot Chat" })

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

-- ============================================================================
-- LSP, Linting, Formatting & Completion
-- ============================================================================

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
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "<leader>gd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, opts)

	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

	vim.keymap.set("n", "<leader>gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, opts)

	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	vim.keymap.set("n", "<leader>D", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)
	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, opts)
	vim.keymap.set("n", "<leader>nd", function()
		vim.diagnostic.jump({ count = 1 })
	end, opts)

	vim.keymap.set("n", "<leader>pd", function()
		vim.diagnostic.jump({ count = -1 })
	end, opts)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	vim.keymap.set("n", "<leader>fd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, opts)
	vim.keymap.set("n", "<leader>fr", function()
		require("fzf-lua").lsp_references()
	end, opts)
	vim.keymap.set("n", "<leader>ft", function()
		require("fzf-lua").lsp_typedefs()
	end, opts)
	vim.keymap.set("n", "<leader>fs", function()
		require("fzf-lua").lsp_document_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fw", function()
		require("fzf-lua").lsp_workspace_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fi", function()
		require("fzf-lua").lsp_implementations()
	end, opts)

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
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
		end, opts)
	end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

require("mason").setup({})
require("mason-lspconfig").setup({

	ensure_installed = {
		"rust_analyzer", -- Rust
		"clangd", -- C / C++
		"html", -- HTML
		"cssls", -- CSS
		"ts_ls", -- TS / JS
		"jsonls", -- JSON
		"lua_ls", -- Lua
		"marksman", -- Markdown
		"pyright", -- Python
		"bashls", -- Bash
		"jdtls", -- Java
		"efm", -- Linters and Formatters
	},

	automatic_installation = true,
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua", -- Lua formatter
		"luacheck", -- Lua linter
		"black", -- Python formatter
		"flake8", -- Python linter
		"prettierd", -- Web formatter
		"eslint_d", -- Web linter
		"fixjson", -- JSON formatter
		"shfmt", -- Shell formatter
		"shellcheck", -- Shell linter
		"clang-format", -- C / C++ formatter
		"cpplint", -- C / C++ linter
		"google-java-format", -- Java formatter
	},
	auto_update = true,
	run_on_start = true,
})

do
	-- Lua
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	-- Python
	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")

	-- Web (JS/TS/HTML/CSS/JSON/Markdown)
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local eslint_d = require("efmls-configs.linters.eslint_d")

	-- JSON
	local fixjson = require("efmls-configs.formatters.fixjson")

	-- Shell
	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")

	-- C / C++
	local clangfmt = require("efmls-configs.formatters.clang_format")
	local cpplint = require("efmls-configs.linters.cpplint")

	-- Rust
	local rustfmt = require("efmls-configs.formatters.rustfmt")

	-- Java
	local google_java_format = require("efmls-configs.formatters.google_java_format")

	vim.lsp.config("efm", {
		filetypes = {
			"rust",
			"c",
			"cpp",
			"html",
			assistant = {
				chat = {
					enabled = true,
					model = "gpt-3.5-turbo",
				},
			},

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

				-- Rust
				rust = { rustfmt },

				-- C / C++
				c = { clangfmt, cpplint },
				cpp = { clangfmt, cpplint },

				-- Java
				java = { google_java_format },

				-- Web
				html = { prettier_d },
				css = { prettier_d },

				javascript = { eslint_d, prettier_d },
				typescript = { eslint_d, prettier_d },

				javascriptreact = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },

				-- JSON
				json = { eslint_d, fixjson },
				jsonc = { eslint_d, fixjson },

				-- Lua
				lua = { luacheck, stylua },

				-- Markdown
				markdown = { prettier_d },

				-- Python
				python = { flake8, black },

				-- Shell
				sh = { shellcheck, shfmt },
			},
		},
	})
end

-- Format on save (ONLY real file buffers, ONLY when efm is attached)
vim.api.nvim_create_autocmd("BufWritePre", {
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
		-- avoid formatting nonfile buffers (helps prevent weird write prompts)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		if not vim.bo[args.buf].modifiable then
			return
		end
		if vim.api.nvim_buf_get_name(args.buf) == "" then
			return
		end

		local has_efm = false
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == "efm" then
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
			filter = function(c)
				return c.name == "efm"
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
							local mini_icon, _ = require("mini.icons").get("lsp", ctx.kind)
							return mini_icon
						end,
						highlight = function(ctx)
							local _, hl = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
				},
			},
		},
		documentation = { auto_show = true, window = { border = "rounded" } },
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

-- ============================================================================
-- AI INTEGRATIONS
-- ============================================================================

require("codecompanion").setup({
	display = {
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
					border = "rounded",
					winblend = 10,
					number = true,
					relativenumber = true,
					cursorline = true,
					cursorlineopt = "both",
				},
			},
		},
	},
	interactions = {
		acp = {
			copilot_acp = function()
				return require("codecompanion.adapters").extend("copilot_acp", {
					defaults = { model = "gpt-4.1", mode = "plan" },
				})
			end,
		},
		chat = { adapter = "copilot_acp" },
		inline = { adapter = "copilot" },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>a", ":CodeCompanionChat Toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", ":CodeCompanionChat Add<CR>", { noremap = true, silent = true })
