local utils = require("dotnet-craft.utils")
local templates = require("dotnet-craft.templates")

local M = {}

local EXCLUDED_DIRS = {
	"bin",
	"obj",
	"node_modules",
	".git",
	".vs",
	".vscode",
	"packages",
	"TestResults",
}

local function should_exclude_path(path)
	local normalized_path = path:gsub("\\", "/")

	local path_segments = utils.split(normalized_path, "/")

	for _, segment in ipairs(path_segments) do
		for _, excluded in ipairs(EXCLUDED_DIRS) do
			if segment == excluded then
				return true
			end
		end
	end

	return false
end

function M.create_folder_tree()
	local cwd = vim.fn.getcwd()
	local paths = utils.scandir(cwd)

	local tree = {}
	local split = vim.fn.split(cwd, "/")
	local current_folder = split[#split]

	for _, path in ipairs(paths) do
		if should_exclude_path(path) then
			goto continue
		end

		local path_split = utils.split(path, "/")
		local base_folder_index = utils.get_index(path_split, current_folder)

		if base_folder_index then
			for i = base_folder_index + 1, #path_split do
				local item = path_split[i]
				local parent = path_split[i - 1]
				local indent_level = i - base_folder_index - 1
				local icon = " "

				local node = {
					name = item,
					level = indent_level,
					parent = parent,
					icon = icon,
					path = path,
				}

				local found = false
				for _, existing_node in ipairs(tree) do
					if
						existing_node.name == node.name
						and existing_node.level == node.level
						and existing_node.parent == node.parent
					then
						found = true
						break
					end
				end

				if not found then
					table.insert(tree, node)
				end
			end
		end

		::continue::
	end

	return tree
end

function M.create_template_tree()
	local templates_tree = {}

	for template_name, _ in pairs(templates) do
		table.insert(templates_tree, template_name)
	end

	table.sort(templates_tree)

	return templates_tree
end

return M
