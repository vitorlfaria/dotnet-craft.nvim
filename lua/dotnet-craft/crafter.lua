local templates = require("dotnet-craft.templates")
local utils = require("dotnet-craft.utils")

local Crafter = {}

local function write_file(location, content)
	local file = io.open(location, "w")

	if file == nil then
		print("Error: Could not create file")
		return
	end

	file:write(content)
	file:close()
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

local function get_namespace()
	local path = UserSelections["selected_folder"]
	local file = get_file_on_selected_folder(path)

	if file == nil then
		return ""
	end

	local namespace = read_namespace_from_file(file)
	return namespace
end

local function open_file(location)
	vim.cmd("stopinsert")
	vim.cmd("edit " .. location)
end

function Crafter.craft_item()
	local namespace = get_namespace()
	local template = templates[UserSelections["selected_template"]]
	local content = string.gsub(template, "{{name}}", UserSelections["selected_name"])
	content = string.gsub(content, "{{namespace}}", namespace)
	local location = UserSelections["selected_folder"] .. "/" .. UserSelections["selected_name"] .. ".cs"
	write_file(location, content)
	open_file(location)
end

return Crafter
