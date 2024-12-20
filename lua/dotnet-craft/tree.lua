local utils = require("dotnet-craft.utils")
local templates = require("dotnet-craft.templates")

local M = {}

function M.create_folder_tree()
	local cwd = vim.fn.getcwd()
	local paths = utils.scandir(cwd)

	local tree = {}
	local split = vim.fn.split(cwd, "/")
	local current_folder = split[#split]
	for _, path in ipairs(paths) do
        if string.match(path, "bin") or string.match(path, "obj") then
            goto continue
        end
		local path_split = utils.split(path, "/")
		local base_folder_index = utils.get_index(path_split, current_folder)

		for i = base_folder_index + 1, #path_split do
			local item = path_split[i]
			local parent = path_split[i - 1]
			local indent_level = i - base_folder_index - 1
			local icon = " "
			local node = {
				name = item,
				level = indent_level,
				parent = parent,
				icon = icon,
                path = path,
			}

			local found = false
			for _, f in ipairs(tree) do
				if f.name == node.name and f.level == node.level and f.parent == node.parent then
					found = true
					break
				end
			end
			if not found then
				table.insert(tree, node)
			end
		end
        ::continue::
	end

	return tree
end

function M.create_template_tree()
    local templates_tree = {}

    for template, _ in pairs(templates) do
        table.insert(templates_tree, template)
    end

    return templates_tree
end

return M
