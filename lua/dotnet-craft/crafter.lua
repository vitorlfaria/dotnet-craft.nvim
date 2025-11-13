local templates = require("dotnet-craft.templates")
local state = require("dotnet-craft.state")

local Crafter = {}

local function write_file(location, content)
	local file = io.open(location, "w")

	if file == nil then
		print("Error: Could not create file")
		return false
	end

	file:write(content)
	file:close()
	return true
end

local function get_file_on_selected_folder(folder)
	local files_names = io.popen("/bin/ls " .. folder)
	if files_names == nil then
		return nil
	end
	for file in files_names:lines() do
		return folder .. "/" .. file
	end
end

local function read_namespace_from_file(file_to_read)
	local file = io.open(file_to_read, "r")
	if file == nil then
		return nil
	end
	local namespace = ""
	for line in file:lines() do
		if string.match(line, "namespace") then
			namespace = line
			break
		end
	end
	file:close()
	return namespace
end

local function get_namespace(folder_path)
	local file = get_file_on_selected_folder(folder_path)

	if file == nil then
		return ""
	end

	local namespace = read_namespace_from_file(file)
	return namespace or ""
end

local function open_file(location)
	vim.cmd("stopinsert")
	vim.cmd("edit " .. location)
end

function Crafter.craft_item()
	local selections = state.get_all_selections()

	if not state.is_complete() then
		print("Error: Missing required selections")
		return
	end

	local namespace = get_namespace(selections.selected_folder)
	local template = templates[selections.selected_template]

	if not template then
		print("Error: Template not found: " .. selections.selected_template)
		return
	end

	local content = string.gsub(template, "{{name}}", selections.selected_name)
	content = string.gsub(content, "{{namespace}}", namespace)

	local location = selections.selected_folder .. "/" .. selections.selected_name .. ".cs"

	if write_file(location, content) then
		open_file(location)
	end
end

return Crafter
