local tree = require("dotnet-craft.tree")
local popup = require("dotnet-craft.popup")
local utils = require("dotnet-craft.utils")
local callbacks = require("dotnet-craft.callbacks")

local dotnet_craft = {}

local function open_folder_explorer_popup()
    local layout = tree.create_folder_tree()

	Win_id = popup.create(layout, {
		title = "Select Folder",
		line = Line,
		col = Col,
		minwidth = Width,
		minheight = Height,
		borderchars = Borderchars,
		padding = { 0, 0, 0, 2 },
		callback = function(_, selected)
			local selected_folder = callbacks.select_folder(selected)
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
