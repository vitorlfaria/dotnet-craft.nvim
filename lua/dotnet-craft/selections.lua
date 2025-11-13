local tree = require("dotnet-craft.tree")
local popup = require("dotnet-craft.popup")
local utils = require("dotnet-craft.utils")
local callbacks = require("dotnet-craft.callbacks")
local state = require("dotnet-craft.state")
local config = require("dotnet-craft.config")

local M = {}

function M.open_folder_selection_popup()
	local layout = tree.create_folder_tree()
	local ui_config = config.get_ui_config()

	local win_id = popup.create(layout, {
		title = "Select Folder",
		line = ui_config.line,
		col = ui_config.col,
		minwidth = ui_config.width,
		minheight = ui_config.height,
		maxheight = ui_config.max_height,
		borderchars = ui_config.borderchars,
		padding = { 0, 0, 0, 2 },
		callback = function(_, selected)
			callbacks.select_folder(selected)
			M.open_template_selection_popup()
		end,
	})

	state.set_current_win(win_id)

	local bufnr = vim.api.nvim_win_get_buf(win_id)
	utils.disable_insert_mode_for_buffer(bufnr)
end

function M.open_template_selection_popup()
	local layout = tree.create_template_tree()
	local ui_config = config.get_ui_config()

	local win_id = popup.create(layout, {
		title = "Select Template",
		line = ui_config.line,
		col = ui_config.col,
		minwidth = ui_config.width,
		minheight = ui_config.height,
		maxheight = ui_config.max_height,
		borderchars = ui_config.borderchars,
		padding = { 0, 0, 0, 2 },
		callback = function(_, selected)
			callbacks.select_template(selected)
			M.open_name_selection_popup()
		end,
	})

	state.set_current_win(win_id)

	local bufnr = vim.api.nvim_win_get_buf(win_id)
	utils.disable_insert_mode_for_buffer(bufnr)
end

function M.open_name_selection_popup()
	local ui_config = config.get_ui_config()

	local win_id = popup.create("", {
		title = "Enter Name",
		insert = true,
		line = ui_config.line,
		col = ui_config.col,
		minwidth = ui_config.width,
		height = ui_config.height,
		borderchars = ui_config.borderchars,
		padding = { 0, 0, 0, 2 },
		typed_value_callback = function(value)
			callbacks.select_name(value)
		end,
	})

	state.set_current_win(win_id)
end

return M
