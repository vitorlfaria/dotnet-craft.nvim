local state = require("dotnet-craft.state")

local M = {}

function M.select_folder(selected)
	state.set_folder(selected.path)
end

function M.select_template(selected)
	state.set_template(selected)
end

function M.select_name(value)
	local trimmed = value:gsub("^%s*(.-)%s*$", "%1")
	state.set_name(trimmed)
end

return M
