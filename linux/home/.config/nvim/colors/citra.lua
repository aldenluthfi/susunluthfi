vim.cmd([[highlight clear]])

local M = {}

local highlight = function(group, bg, fg, attr, sp)
	fg = fg and "guifg=" .. fg or ""
	bg = bg and "guibg=" .. bg or ""
	attr = attr and "gui=" .. attr .. " cterm=" .. attr or ""
	sp = sp and "guisp=" .. sp or ""

	vim.api.nvim_command("highlight " .. group .. " " .. fg .. " " .. bg .. " " .. attr .. " " .. sp)
end

local link = function(target, group)
	vim.api.nvim_command("highlight! link " .. target .. " " .. group)
end

local colors = {
	bg0 = "#18181B",
	bg1 = "#27272A",
	bg2 = "#52525B",
	bg3 = "#3F3F46",

	fg0 = "#FAFAFA",
	fg1 = "#E7E5E5",
	fg2 = "#979798",
	fg3 = "#71717A",

	red = "#FF6B6B",
	orange = "#FF9900",
	yellow = "#FFE066",
	green = "#4ADEB7",
	cyan = "#3EDBF0",
	blue = "#409CFF",
	purple = "#A259FF",
	magenta = "#FF4DFF",

	comment = "#D5D3D1",
	diff_add = "#354320",
	diff_delete = "#5e3335",
}

M.colors = colors
vim.g.citra_colors = colors

-- Core syntax
highlight("Normal", colors.bg0, colors.fg0, nil)
highlight("NormalNC", colors.bg0, colors.fg2, nil)
highlight("NormalFloat", colors.bg0, colors.fg0, nil)
highlight("FloatBorder", colors.bg0, colors.fg3, nil)
highlight("FloatTitle", colors.bg0, colors.fg2, "bold")
highlight("ColorColumn", colors.bg1, nil, nil)
highlight("CursorLine", colors.bg1, nil, nil)
highlight("CursorColumn", colors.bg1, nil, nil)
highlight("LineNr", nil, colors.fg3, nil)
highlight("CursorLineNr", nil, colors.yellow, "bold")
highlight("SignColumn", colors.bg0, nil, nil)
highlight("VertSplit", colors.bg0, colors.bg2, nil)
highlight("WinSeparator", colors.bg0, colors.bg2, nil)
highlight("FoldColumn", colors.bg0, colors.fg3, nil)
highlight("Folded", colors.bg1, colors.fg2, nil)
highlight("StatusLine", colors.bg2, colors.fg0, nil)
highlight("StatusLineNC", colors.bg0, colors.fg3, nil)
highlight("TabLine", colors.bg1, colors.fg1, nil)
highlight("TabLineSel", colors.bg2, colors.fg1, nil)
highlight("TabLineFill", colors.bg0, colors.fg2, nil)
highlight("Visual", colors.bg2, nil, nil)
highlight("VisualNOS", colors.bg2, nil, nil)
highlight("Search", colors.yellow, colors.bg0, "bold")
highlight("IncSearch", colors.orange, colors.bg0, "bold")
highlight("CurSearch", colors.red, colors.bg0, "bold")
highlight("MatchParen", colors.comment, colors.bg0, "bold")
highlight("NonText", nil, colors.fg3, nil)
highlight("Whitespace", nil, colors.fg3, nil)
highlight("Conceal", nil, colors.fg3, nil)
highlight("Title", nil, colors.fg0, "bold")
highlight("Directory", nil, colors.blue, "bold")
highlight("Question", nil, colors.green, "bold")
highlight("MoreMsg", nil, colors.green, "bold")
highlight("WarningMsg", nil, colors.orange, "bold")
highlight("ErrorMsg", colors.bg0, colors.red, "bold")
highlight("ModeMsg", nil, colors.fg1, "bold")

highlight("Comment", nil, colors.comment, nil)
highlight("Constant", nil, colors.orange, nil)
highlight("String", nil, colors.green, nil)
highlight("Character", nil, colors.green, nil)
highlight("Number", nil, colors.green, nil)
highlight("Boolean", nil, colors.green, nil)
highlight("Float", nil, colors.green, nil)
highlight("Identifier", nil, colors.red, nil)
highlight("Function", nil, colors.yellow, nil)
highlight("Statement", nil, colors.blue, nil)
highlight("Conditional", nil, colors.orange, nil)
highlight("Repeat", nil, colors.red, nil)
highlight("Label", nil, colors.orange, nil)
highlight("Operator", nil, colors.fg1, nil)
highlight("Keyword", nil, colors.purple, nil)
highlight("Exception", nil, colors.red, nil)
highlight("PreProc", nil, colors.orange, nil)
highlight("Include", nil, colors.blue, nil)
highlight("Define", nil, colors.orange, nil)
highlight("Macro", nil, colors.yellow, nil)
highlight("PreCondit", nil, colors.orange, nil)
highlight("Type", nil, colors.orange, nil)
highlight("StorageClass", nil, colors.orange, nil)
highlight("Structure", nil, colors.blue, nil)
highlight("Typedef", nil, colors.orange, nil)
highlight("Special", nil, colors.cyan, nil)
highlight("SpecialChar", nil, colors.cyan, nil)
highlight("Tag", nil, colors.orange, nil)
highlight("Delimiter", nil, colors.fg1, nil)
highlight("SpecialComment", nil, colors.fg2, "italic")
highlight("Debug", nil, colors.red, nil)
highlight("Underlined", nil, colors.blue, "underline")
highlight("Ignore", nil, colors.fg3, nil)
highlight("Error", colors.bg0, colors.red, "bold")
highlight("Todo", colors.bg1, colors.yellow, "bold")

-- Popup/completion
highlight("Pmenu", colors.bg0, colors.fg0, nil)
highlight("PmenuSel", colors.fg0, colors.bg1, nil)
highlight("PmenuSbar", colors.bg1, nil, nil)
highlight("PmenuThumb", colors.bg0, colors.fg0, nil)
highlight("WildMenu", colors.bg0, colors.fg0, nil)
highlight("PmenuKind", colors.bg0, colors.yellow, nil)
highlight("PmenuExtra", colors.bg0, colors.comment, nil)

-- Diff and VCS
highlight("DiffAdd", colors.diff_add, nil, nil)
highlight("DiffDelete", colors.diff_delete, nil, nil)
highlight("DiffChange", colors.bg1, colors.blue, nil)
highlight("DiffText", colors.blue, colors.bg0, "bold")
highlight("GitSignsAdd", colors.bg0, colors.green, nil)
highlight("GitSignsChange", colors.bg0, colors.cyan, nil)
highlight("GitSignsDelete", colors.bg0, colors.red, nil)
highlight("GitSignsCurrentLineBlame", nil, colors.fg3, nil)

-- Diagnostics
highlight("DiagnosticError", nil, colors.red, nil)
highlight("DiagnosticWarn", nil, colors.yellow, nil)
highlight("DiagnosticInfo", nil, colors.blue, nil)
highlight("DiagnosticHint", nil, colors.cyan, nil)
highlight("DiagnosticOk", nil, colors.green, nil)
highlight("DiagnosticVirtualTextError", colors.diff_delete, colors.red, nil)
highlight("DiagnosticVirtualTextWarn", colors.diff_add, colors.yellow, nil)
highlight("DiagnosticVirtualTextInfo", colors.bg2, colors.blue, nil)
highlight("DiagnosticVirtualTextHint", colors.bg1, colors.cyan, nil)
highlight("DiagnosticFloatingError", colors.bg0, colors.red, nil)
highlight("DiagnosticFloatingWarn", colors.bg0, colors.yellow, nil)
highlight("DiagnosticFloatingInfo", colors.bg0, colors.blue, nil)
highlight("DiagnosticFloatingHint", colors.bg0, colors.cyan, nil)
highlight("DiagnosticSignError", colors.bg0, colors.red, nil)
highlight("DiagnosticSignWarn", colors.bg0, colors.yellow, nil)
highlight("DiagnosticSignInfo", colors.bg0, colors.blue, nil)
highlight("DiagnosticSignHint", colors.bg0, colors.cyan, nil)
highlight("DiagnosticUnderlineError", nil, nil, "undercurl", colors.red)
highlight("DiagnosticUnderlineWarn", nil, nil, "undercurl", colors.yellow)
highlight("DiagnosticUnderlineInfo", nil, nil, "undercurl", colors.blue)
highlight("DiagnosticUnderlineHint", nil, nil, "undercurl", colors.cyan)

-- Plugin styling
highlight("FzfLuaNormal", colors.bg0, colors.fg0, nil)
highlight("FzfLuaBorder", colors.bg0, colors.fg3, nil)
highlight("FzfLuaTitle", colors.bg0, colors.fg2, "bold")
highlight("FzfLuaPrompt", colors.bg0, colors.fg0, nil)
highlight("FzfLuaPromptBorder", colors.bg0, colors.fg3, nil)
highlight("FzfLuaPromptTitle", colors.bg0, colors.fg2, "bold")
highlight("FzfLuaSelection", colors.bg2, colors.fg0, "bold")
highlight("FzfLuaCursorLine", colors.bg2, nil, nil)
highlight("BlinkCmpMenu", colors.bg0, colors.fg0, nil)
highlight("BlinkCmpMenuBorder", colors.bg0, colors.fg3, nil)
highlight("BlinkCmpMenuSelection", colors.magenta, colors.bg0, "bold")
highlight("BlinkCmpDoc", colors.bg0, colors.fg0, nil)
highlight("BlinkCmpDocBorder", colors.bg0, colors.fg3, nil)
highlight("MiniCursorword", colors.bg2, nil, nil)
highlight("MiniCursorwordCurrent", colors.bg2, nil, "bold")
highlight("MiniTrailspace", colors.diff_delete, colors.fg0, "bold")
highlight("MiniIndentscopeSymbol", nil, colors.bg2, nil)
highlight("MiniIconsGrey", nil, colors.fg3, nil)
highlight("MiniIconsBlue", nil, colors.blue, nil)
highlight("MiniIconsYellow", nil, colors.yellow, nil)
highlight("MiniIconsOrange", nil, colors.orange, nil)
highlight("MiniIconsRed", nil, colors.red, nil)
highlight("MiniIconsPurple", nil, colors.purple, nil)
highlight("MiniIconsGreen", nil, colors.green, nil)
highlight("MiniIconsAzure", nil, colors.cyan, nil)
highlight("MiniIconsCyan", nil, colors.cyan, nil)
highlight("CopilotSuggestion", "none", colors.fg3, nil)
highlight("CopilotAnnotation", "none", colors.cyan, "italic")

-- Treesitter and links
link("@function", "Function")
link("@function.builtin", "Function")
link("@function.macro", "Macro")
link("@parameter", "Identifier")
link("@parameter.reference", "Identifier")
link("@field", "Identifier")
link("@property", "Identifier")
link("@variable", "Identifier")
link("@variable.builtin", "Special")
link("@type", "Type")
link("@type.builtin", "Type")
link("@namespace", "Structure")
link("@constant", "Constant")
link("@constant.builtin", "Constant")
link("@string", "String")
link("@number", "Number")
link("@float", "Float")
link("@boolean", "Boolean")
link("@comment", "Comment")
link("@operator", "Operator")
link("@punctuation", "Delimiter")
link("@punctuation.delimiter", "Delimiter")
link("@punctuation.bracket", "Delimiter")
link("@keyword", "Keyword")
link("@keyword.function", "Keyword")
link("@keyword.return", "Keyword")
link("@conditional", "Conditional")
link("@repeat", "Repeat")
link("@label", "Label")
link("@tag", "Tag")
link("@tag.delimiter", "Delimiter")

link("TSFunction", "Function")
link("TSPunctSpecial", "Delimiter")
link("TSParameterReference", "TSParameter")
link("TSRepeat", "Repeat")
link("TSNumber", "Number")
link("TSFloat", "Number")
link("TSConditional", "Conditional")
link("TSField", "Constant")
link("TSParameter", "Constant")
link("TSLabel", "Type")
link("TSNamespace", "TSType")
link("TSPunctBracket", "Delimiter")
link("TSProperty", "TSField")
link("TSString", "String")
link("TSType", "Type")
link("TSComment", "Comment")
link("TSOperator", "Operator")
link("TSTagDelimiter", "Type")
link("TelescopeNormal", "Normal")
link("TSTag", "Type")
link("TSFuncMacro", "Macro")
link("TSConstBuiltin", "TSVariableBuiltin")
link("TSConstant", "Constant")
link("TSKeyword", "Keyword")

return M
