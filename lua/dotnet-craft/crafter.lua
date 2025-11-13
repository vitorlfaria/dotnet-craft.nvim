local templates = require("dotnet-craft.templates")
local state = require("dotnet-craft.state")
local namespace = require("dotnet-craft.namespace")

local Crafter = {}

local function write_file(location, content)
	local file = io.open(location, "w")

	if file == nil then
		vim.notify("Error: Could not create file at " .. location, vim.log.levels.ERROR)
		return false
	end

	file:write(content)
	file:close()
	return true
end

local function open_file(location)
	vim.cmd("stopinsert")
	vim.cmd("edit " .. location)
end

local function file_exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

function Crafter.craft_item()
	local selections = state.get_all_selections()

	if not state.is_complete() then
		vim.notify("Error: Missing required selections", vim.log.levels.ERROR)
		return
	end

	if not namespace.is_dotnet_project(selections.selected_folder) then
		vim.notify("Warning: No .csproj file found. This doesn't appear to be a .NET project.", vim.log.levels.WARN)
	end

	local ns = namespace.get_namespace_for_directory(selections.selected_folder)

	if not ns or ns == "" then
		vim.notify("Warning: Could not determine namespace. Using folder name.", vim.log.levels.WARN)
		ns = vim.fn.fnamemodify(selections.selected_folder, ":t")
	end

	local template = templates[selections.selected_template]

	if not template then
		vim.notify("Error: Template not found: " .. selections.selected_template, vim.log.levels.ERROR)
		return
	end

	local content = string.gsub(template, "{{name}}", selections.selected_name)
	content = string.gsub(content, "{{namespace}}", ns)

	local location = selections.selected_folder .. "/" .. selections.selected_name .. ".cs"

	if file_exists(location) then
		local choice =
			vim.fn.confirm("File '" .. selections.selected_name .. ".cs' already exists. Overwrite?", "&Yes\n&No", 2)

		if choice ~= 1 then
			vim.notify("File creation cancelled", vim.log.levels.INFO)
			return
		end
	end

	if write_file(location, content) then
		open_file(location)
		vim.notify("Created: " .. selections.selected_name .. ".cs", vim.log.levels.INFO)
	end
end

return Crafter
