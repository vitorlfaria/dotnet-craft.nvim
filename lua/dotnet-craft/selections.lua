local tree = require("dotnet-craft.tree")
local popup = require("dotnet-craft.popup")
local utils = require("dotnet-craft.utils")
local crafter = require("dotnet-craft.crafter")
local callbacks = require("dotnet-craft.callbacks")

local M = {}

function M.open_folder_selection_popup()
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
            callbacks.select_folder(selected)
            M.open_template_selection_popup()
        end,
	})

	local bufnr = vim.api.nvim_win_get_buf(Win_id)
	utils.disable_insert_mode_for_buffer(bufnr)
end

function M.open_template_selection_popup()
    local layout = tree.create_template_tree()

    Win_id = popup.create(layout, {
        title = "Select Template",
        line = Line,
        col = Col,
        minwidth = Width,
        minheight = Height,
        borderchars = Borderchars,
        padding = { 0, 0, 0, 2 },
        callback = function(_, selected)
            callbacks.select_template(selected)
            M.open_name_selection_popup()
        end
    })

    local bufnr = vim.api.nvim_win_get_buf(Win_id)
    utils.disable_insert_mode_for_buffer(bufnr)
end

function M.open_name_selection_popup()
    Win_id = popup.create("", {
        title = "Enter Name",
        insert = true,
        line = Line,
        col = Col,
        minwidth = Width,
        height = Height,
        borderchars = Borderchars,
        padding = { 0, 0, 0, 2 },
        typed_value_callback = function(value)
            callbacks.select_name(value)
            crafter.craft_item()
        end
    })
end

return M
