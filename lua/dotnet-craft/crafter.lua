local templates = require("dotnet-craft.templates")
local state = require("dotnet-craft.state")
local namespace = require("dotnet-craft.namespace")
local validation = require("dotnet-craft.validation")

local Crafter = {}

local function write_file(location, content)
	local success, err = pcall(function()
		local file = io.open(location, "w")
		if not file then
			error("Could not open file for writing")
		end
		file:write(content)
		file:close()
	end)

	if not success then
		vim.notify("Error writing file: " .. tostring(err), vim.log.levels.ERROR)
		return false
	end

	return true
end

local function open_file(location)
	local success, err = pcall(function()
		vim.cmd("stopinsert")
		vim.cmd("edit " .. vim.fn.fnameescape(location))
	end)

	if not success then
		vim.notify("Error opening file: " .. tostring(err), vim.log.levels.ERROR)
		return false
	end

	return true
end

function Crafter.craft_item()
	local selections = state.get_all_selections()

	if not state.is_complete() then
		vim.notify("Error: Missing required selections", vim.log.levels.ERROR)
		return
	end

	local valid, validation_errors = validation.validate_all_selections(selections, templates)
	if not valid then
		for _, error in ipairs(validation_errors) do
			vim.notify("Validation Error: " .. error, vim.log.levels.ERROR)
		end
		return
	end

	local location = selections.selected_folder .. "/" .. selections.selected_name .. ".cs"

	if validation.check_file_exists(location) then
		local choice =
			vim.fn.confirm("File '" .. selections.selected_name .. ".cs' already exists. Overwrite?", "&Yes\n&No", 2)

		if choice ~= 1 then
			vim.notify("File creation cancelled", vim.log.levels.INFO)
			return
		end
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

	local content = string.gsub(template, "{{name}}", selections.selected_name)
	content = string.gsub(content, "{{namespace}}", ns)

	if write_file(location, content) then
		if open_file(location) then
			vim.notify("Created: " .. selections.selected_name .. ".cs", vim.log.levels.INFO)
		end
	end
end

return Crafter
