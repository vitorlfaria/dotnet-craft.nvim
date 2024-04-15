local M = {}

function M.select_folder(_, selected)
    UserSelections["selected_folder"] = selected.path
end

function M.select_template(_, selected)
    UserSelections["selected_template"] = selected
end

function M.select_name(_, selected)
    UserSelections["selected_name"] = selected
end

return M
