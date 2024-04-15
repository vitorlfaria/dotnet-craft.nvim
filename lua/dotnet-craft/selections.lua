local tree = require("dotnet-craft.tree")
local popup = require("dotnet-craft.popup")
local utils = require("dotnet-craft.utils")
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
            callbacks.select_folder(_, selected)
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
        callback = function()
            callbacks.select_template()
            M.open_name_selection_popup()
        end
    })

    local bufnr = vim.api.nvim_win_get_buf(Win_id)
    utils.disable_insert_mode_for_buffer(bufnr)
end

function M.open_name_selection_popup()
    -- create popup with input field to get the name
    Win_id = popup.create("", {
        title = "Enter Name",
        line = Line,
        col = Col,
        minwidth = Width,
        minheight = Height,
        borderchars = Borderchars,
        padding = { 0, 0, 0, 2 },
        callback = callbacks.select_name,
    })

    local bufnr = vim.api.nvim_win_get_buf(Win_id)
    utils.enable_insert_mode_for_buffer(bufnr)
end

return M