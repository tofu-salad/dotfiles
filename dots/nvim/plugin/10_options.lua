vim.g.mapleader = " " -- Use `<Space>` as <Leader> key
vim.o.mouse = "a" -- Enable mouse
vim.o.undofile = true -- Enable persistent undo
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then
	vim.cmd("syntax enable")
end

-- UI
vim.o.breakindent = true -- Indent wrapped lines to match line start
vim.o.breakindentopt = "list:-1" -- Add padding for lists (if 'wrap' is set)
vim.o.colorcolumn = "+1" -- Draw column on the right of maximum width
vim.o.cursorline = true -- Enable current line highlighting
vim.o.linebreak = true -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.number = true -- Show line numbers
vim.o.pumborder = "single" -- Use border in popup menu
vim.o.pumheight = 10 -- Make popup menu smaller
vim.o.pummaxwidth = 100 -- Make popup menu not too wide
vim.o.shortmess = "CFOSWaco" -- Disable some built-in completion messages
vim.o.showmode = false -- Don't show mode in command line
vim.o.signcolumn = "yes" -- Always show signcolumn (less flicker)
vim.o.splitbelow = true -- Horizontal splits will be below
vim.o.splitkeep = "screen" -- Reduce scroll during window split
vim.o.splitright = true -- Vertical splits will be to the right
vim.o.winborder = "single" -- Use border in floating windows
vim.o.wrap = false -- Don't visually wrap lines (toggle with \w)

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"
vim.g.netrw_use_errorwindow = 0
vim.g.netrw_keepdir = 1

vim.o.cursorlineopt = "screenline,number" -- Show cursor line per screen line

-- Editing
vim.o.autoindent = true -- Use auto indent
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.formatoptions = "rqnl1j" -- Improve comment editing
vim.o.ignorecase = true -- Ignore case during search
vim.o.incsearch = true -- Show search matches while typing
vim.o.infercase = true -- Infer case in built-in completion
vim.o.smartcase = true -- Respect case if search pattern has upper case
vim.o.smartindent = true -- Make indenting smart
vim.o.spelloptions = "camel" -- Treat camelCase word parts as separate words
vim.o.virtualedit = "block" -- Allow going past end of line in blockwise mode

vim.o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash as `word` textobject part

-- Built-in completion
vim.o.complete = ".,w,b,kspell" -- Use less sources
vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Use custom behavior
vim.o.completetimeout = 100

-- Misc
vim.g.omni_sql_no_default_maps = 1 -- Disable SQL ctrl+c

-- Diagnostics
local diagnostic_opts = {
	severity_sort = true,
	float = { border = "single", source = "if_many" },
	-- Show signs on top of any other sign, but only for warnings and errors
	signs = { priority = 9999, severity = { min = "WARN", max = "ERROR" } },

	-- Show all diagnostics as underline
	underline = { severity = { min = "HINT", max = "ERROR" } },

	-- Show more details immediately for errors on the current line
	virtual_lines = false,
	virtual_text = false,

	-- Don't update diagnostics when typing
	update_in_insert = false,
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
	},
}

Config.later(function()
	vim.diagnostic.config(diagnostic_opts)
end)
