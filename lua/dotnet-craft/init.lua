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
			local indent = string.rep("  ", i - index - 1)
			if i == #file_split then
				item = "󰈔 " .. item
			else
				item = " " .. item
			end

			local found = false
			for _, v in ipairs(items) do
				if v == indent .. item then
					found = true
					break
				end
			end
			if not found then
				table.insert(items, indent .. item)
			end
		end
	end

    return items
end

local function open_folder_explorer_popup()
    local items = create_folder_tree()

	Win_id = popup.create(items, {
		title = "Select Folder",
		line = Line,
		col = Col,
		minwidth = Width,
		minheight = Height,
		borderchars = Borderchars,
		padding = { 0, 0, 0, 2 },
		callback = function(_, selected)
			callbacks.select_folder(selected, items)
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
