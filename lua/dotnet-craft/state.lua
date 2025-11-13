local M = {}

local state = {
	selections = {
		selected_folder = nil,
		selected_template = nil,
		selected_name = nil,
	},
	ui = {
		current_win_id = nil,
	},
}

function M.init()
	state.selections = {
		selected_folder = nil,
		selected_template = nil,
		selected_name = nil,
	}
	state.ui.current_win_id = nil
end

function M.set_folder(folder_path)
	state.selections.selected_folder = folder_path
end

function M.get_folder()
	return state.selections.selected_folder
end

function M.set_template(template_name)
	state.selections.selected_template = template_name
end

function M.get_template()
	return state.selections.selected_template
end

function M.set_name(name)
	state.selections.selected_name = name
end

function M.get_name()
	return state.selections.selected_name
end

function M.get_all_selections()
	return vim.deepcopy(state.selections)
end

function M.set_current_win(win_id)
	state.ui.current_win_id = win_id
end

function M.get_current_win()
	return state.ui.current_win_id
end

function M.close_current_win()
	if state.ui.current_win_id and vim.api.nvim_win_is_valid(state.ui.current_win_id) then
		vim.api.nvim_win_close(state.ui.current_win_id, true)
		state.ui.current_win_id = nil
	end
end

function M.is_complete()
	return state.selections.selected_folder ~= nil
		and state.selections.selected_template ~= nil
		and state.selections.selected_name ~= nil
end

function M.debug_print()
	print("=== DotNet Craft State ===")
	print("Selections:", vim.inspect(state.selections))
	print("Current Win ID:", state.ui.current_win_id)
	print("========================")
end

return M
