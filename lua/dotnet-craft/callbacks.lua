local state = require("dotnet-craft.state")
local validation = require("dotnet-craft.validation")

local M = {}

function M.select_folder(selected)
	if not selected or not selected.path then
		vim.notify("Error: Invalid folder selection", vim.log.levels.ERROR)
		return
	end

	local valid, error_msg = validation.validate_directory(selected.path)
	if not valid then
		vim.notify("Error: " .. error_msg, vim.log.levels.ERROR)
		return
	end

	state.set_folder(selected.path)
end

function M.select_template(selected)
	if not selected or selected == "" then
		vim.notify("Error: No template selected", vim.log.levels.ERROR)
		return
	end

	state.set_template(selected)
end

function M.select_name(value)
	local trimmed = value:gsub("^%s*(.-)%s*$", "%1")

	local valid, error_msg = validation.validate_name(trimmed)
	if not valid then
		vim.notify("Error: " .. error_msg, vim.log.levels.ERROR)
		return
	end

	state.set_name(trimmed)
end

return M
