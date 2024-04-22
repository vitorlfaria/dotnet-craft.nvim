local M = {}

function M.select_folder(selected)
    UserSelections["selected_folder"] = selected.path
end

function M.select_template(selected)
    UserSelections["selected_template"] = selected
end

function M.select_name(value)
    UserSelections["selected_name"] = value:gsub("^%s*(.-)%s*$", "%1")
end

return M
