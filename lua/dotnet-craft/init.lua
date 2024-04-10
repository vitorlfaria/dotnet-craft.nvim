local popup = require("plenary.popup")
local scandir = require("plenary.scandir")
local utils = require("dotnet-craft.utils")
local callbacks = require("dotnet-craft.callbacks")

Height = math.floor(vim.o.lines / 2)
Width = math.floor(vim.o.columns / 2)
Line = math.floor(((vim.o.lines - Height) / 2) - 1)
Col = math.floor((vim.o.columns - Width) / 2)
Borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

UserSelections = {}

local dotnet_craft = {}

local function create_folder_tree()
	local cwd = vim.fn.getcwd()
	local files = scandir.scan_dir(cwd)

	local items = {}
	local split = vim.fn.split(cwd, "/")
	local current_folder = split[#split]
	for _, file in ipairs(files) do
		local file_split = utils.split(file, "/")
		local index = utils.get_index(file_split, current_folder)

		for i = index + 1, #file_split do
			local item = file_split[i]
			local indent_level = i - index - 1
			if i == #file_split then
				item = "󰈔 " .. item
			else
				item = " " .. item
			end

            local node = { level = indent_level, item = item }
			local found = false
			for _, v in ipairs(items) do
				if v.item == node.item and v.level == node.level then
					found = true
					break
				end
			end
			if not found then
				table.insert(items, node)
			end
		end
	end

    return items
end

local function create_tree_layout()
    local items = create_folder_tree()
    local tree = {}

    for _, item in ipairs(items) do
        local indent = string.rep("  ", item.level)
        table.insert(tree, indent .. item.item)
    end

    return tree
end

local function open_folder_explorer_popup()
    local tree = create_tree_layout()

	Win_id = popup.create(tree, {
		title = "Select Folder",
		line = Line,
		col = Col,
		minwidth = Width,
		minheight = Height,
		borderchars = Borderchars,
		padding = { 0, 0, 0, 2 },
		callback = function(_, selected)
			local selected_folder = callbacks.select_folder(selected, tree)
            print(selected_folder)
		end,
	})

	local bufnr = vim.api.nvim_win_get_buf(Win_id)
	utils.disable_insert_mode_for_buffer(bufnr)
end

function ClosePopup()
	vim.api.nvim_win_close(Win_id, true)
end

function dotnet_craft.craft()
    open_folder_explorer_popup()
end

return dotnet_craft
