_G.Config = {}

-- Define custom autocommand group and helper to create an autocommand.
local gr = vim.api.nvim_create_augroup("tofu-config", {})
Config.new_autocmd = function(event, pattern, callback, desc)
	local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
	vim.api.nvim_create_autocmd(event, opts)
end

-- Define custom `vim.pack.add()` hook helper. Plugin data is passed as
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
	local f = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
			return
		end
		if not ev.data.active then
			vim.cmd.packadd(plugin_name)
		end
		callback(ev.data)
	end
	Config.new_autocmd("PackChanged", "*", f, desc)
end

vim.pack.add({ "https://github.com/nvim-mini/mini.misc" })
local misc = require("mini.misc")

Config.now = function(f)
	misc.safely("now", f)
end
Config.later = function(f)
	misc.safely("later", f)
end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f)
	misc.safely("event:" .. ev, f)
end
Config.on_filetype = function(ft, f)
	misc.safely("filetype:" .. ft, f)
end

--- @param bin string
--- @return boolean
Config.bin_exists = function(bin)
	return vim.fn.executable(bin) == 1
end

--- @param bin string
--- @param root string Project root directory
--- @return boolean
Config.bin_exists_nodemodules = function(bin, root)
	return vim.fn.executable(vim.fs.joinpath(root, "node_modules/.bin", bin)) == 1
end
