local M = {}

function M.select_folder(_, selected)
    UserSelections["selected_folder"] = selected.path
end

return M
