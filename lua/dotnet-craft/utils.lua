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
	local opts = { silent = true, noremap = true }

	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "", {
		silent = true,
		noremap = true,
		callback = function()
			state.close_current_win()
		end,
	})

	vim.api.nvim_buf_set_keymap(bufnr, "n", "o", "<nop>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "O", "<nop>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "i", "<nop>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "I", "<nop>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "a", "<nop>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "A", "<nop>", opts)
end

function M.scandir(dir)
	local dirs = {}

	local paths = vim.fn.glob(dir .. "/**", false, true)

	table.insert(dirs, dir)

	for _, path in ipairs(paths) do
		if vim.fn.isdirectory(path) == 1 then
			local basename = vim.fn.fnamemodify(path, ":t")
			if not basename:match("^%.") then
				table.insert(dirs, path)
			end
		end
	end

	return dirs
end

function M.scandir_recursive(dir, max_depth)
	max_depth = max_depth or 10
	local dirs = {}

	local function scan(path, depth)
		if depth > max_depth then
			return
		end

		local handle = vim.loop.fs_scandir(path)
		if not handle then
			return
		end

		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then
				break
			end

			-- Skip hidden files/directories
			if not name:match("^%.") and type == "directory" then
				local full_path = path .. "/" .. name
				table.insert(dirs, full_path)
				scan(full_path, depth + 1)
			end
		end
	end

	table.insert(dirs, dir)
	scan(dir, 1)

	return dirs
end

return M
