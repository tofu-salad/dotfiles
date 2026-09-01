return {
	on_attach = function(client)
		client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }
		client.server_capabilities.documentFormattingProvider = false
	end,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
			workspace = {
				ignoreSubmodules = true,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
}
