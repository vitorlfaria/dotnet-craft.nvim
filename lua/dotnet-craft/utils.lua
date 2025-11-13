local state = require("dotnet-craft.state")

local M = {}

function M.get_index(t, value)
	for k, v in pairs(t) do
		if v == value then
			return k
		end
	end
	return nil
end

function M.split(str, sep)
	local result = {}
	for token in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(result, token)
	end
	return result
end

function M.disable_insert_mode_for_buffer(bufnr)
	-- Set up keymaps for the buffer
	local opts = { silent = true, noremap = true }

	-- Close popup with 'q'
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "", {
		silent = true,
		noremap = true,
		callback = function()
			state.close_current_win()
		end,
	})

	-- Disable insert mode keys
	vim.api.nvim_buf_set_keymap(bufnr, "n", "o", "<nop>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "O", "<nop>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "i", "<nop>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "I", "<nop>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "a", "<nop>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "A", "<nop>", opts)
end

function M.scandir(dir)
	local p = io.popen('find "' .. dir .. '" -type d')
	local dirs = {}
	for line in p:lines() do
		if not string.match(line, "/%..*") then
			table.insert(dirs, line)
		end
	end
	return dirs
end

return M
