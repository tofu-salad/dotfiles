return {
	on_attach = function(client)
		local has_oxfmt = Config.bin_exists("oxfmt") or Config.bin_exists_nodemodules("oxfmt", client.config.root_dir)
		client.server_capabilities.documentFormattingProvider = not has_oxfmt
	end,
}
