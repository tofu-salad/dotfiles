local add = vim.pack.add
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Fidget
now(function()
	add({ "https://github.com/j-hui/fidget.nvim" })
	require("fidget").setup({})
end)

-- Completion
now_if_args(function()
	add({ "https://github.com/nvim-mini/mini.completion" })
	local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
	local process_items = function(items, base)
		---@diagnostic disable-next-line: undefined-global
		return MiniCompletion.default_process_items(items, base, process_items_opts)
	end
	require("mini.completion").setup({
		delay = { completion = 10 ^ 7, info = 10 ^ 7, signature = 10 ^ 7 },
		lsp_completion = {
			-- Without this config autocompletion is set up through `:h 'completefunc'`.
			-- Although not needed, setting up through `:h 'omnifunc'` is cleaner
			-- (sets up only when needed) and makes it possible to use `<C-u>`.
			source_func = "omnifunc",
			auto_setup = false,
			process_items = process_items,
		},
	})

	-- Set 'omnifunc' for LSP completion only when needed.
	local on_attach = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
	end
	Config.new_autocmd("LspAttach", nil, on_attach, "Set 'omnifunc'")

	-- Advertise to servers that Neovim now supports certain set of completion and
	-- signature features through 'mini.completion'.
	---@diagnostic disable-next-line: undefined-global
	vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

-- Picker
later(function()
	add({ "https://github.com/nvim-mini/mini.pick" })
	require("mini.pick").setup()
	vim.keymap.set("n", "<leader>ff", "<Cmd>Pick files<CR>", { desc = "[f]ind [f]iles" })
	vim.keymap.set("n", "<leader>ft", "<Cmd>Pick files tool='git'<CR>", { desc = "[f]ind gi[t] files" })
	vim.keymap.set("n", "<leader>fg", "<Cmd>Pick grep_live<CR>", { desc = "[f]iles [g]rep" })
end)

-- Colorscheme
now(function()
	add({ "https://github.com/oskarnurm/koda.nvim" })
	require("koda").setup({
		transparent = true,
	})
	vim.cmd.colorscheme("koda")
end)

-- Todo Comments
later(function()
	add({ "https://github.com/folke/todo-comments.nvim" })
	require("todo-comments").setup({ signs = false })
end)

-- Git
later(function()
	add({ "https://github.com/nvim-mini/mini-git" })
	require("mini.git").setup()
end)

-- Tree-Sitter
now_if_args(function()
	-- Define hook to update tree-sitter parsers after plugin is updated
	local ts_update = function()
		vim.cmd("TSUpdate")
	end
	Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

	add({
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	})

	local languages = {
		"rust",
		"html",
		"css",
		"tsx",
		"jsx",
		"javascript",
		"typescript",
	}
	local isnt_installed = function(lang)
		return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
	end
	local to_install = vim.tbl_filter(isnt_installed, languages)
	if #to_install > 0 then
		require("nvim-treesitter").install(to_install)
	end

	-- Enable tree-sitter after opening a file for a target language
	local filetypes = {}
	for _, lang in ipairs(languages) do
		for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
			table.insert(filetypes, ft)
		end
	end
	local ts_start = function(ev)
		vim.treesitter.start(ev.buf)
	end
	Config.new_autocmd("FileType", filetypes, ts_start, "Start tree-sitter")
end)
