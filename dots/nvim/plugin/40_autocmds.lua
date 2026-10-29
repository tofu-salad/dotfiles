local new_autocmd = Config.new_autocmd

new_autocmd("TextYankPost", "*", function()
	vim.hl.on_yank()
end, "Highligh when yanking (copying) text")
