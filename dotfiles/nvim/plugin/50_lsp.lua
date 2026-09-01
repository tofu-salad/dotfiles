local add = vim.pack.add
local now_if_args = Config.now_if_args

now_if_args(function()
	add({ "https://github.com/neovim/nvim-lspconfig" })
	vim.lsp.enable({
		"lua_ls",
		"vtsls",
		"stylua",
		"clangd",
		"gopls",
		"nixd",
		"oxfmt",
		"rust_analyzer",
		"html",
		"cssls",
		"jsonls",
	})
end)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("tofu-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Keybinds
		map("gd", vim.lsp.buf.definition, "[g]o to [d]efinition")
		map("grf", vim.lsp.buf.format, "[L]sp [F]ormat")
		map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client and client:supports_method("textDocument/semanticTokens/full", event.buf) then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})
