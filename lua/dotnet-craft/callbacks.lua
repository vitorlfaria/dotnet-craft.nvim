local M = {}

function M.select_folder(selected)
    UserSelections["selected_folder"] = selected.path
end

function M.select_template(selected)
    UserSelections["selected_template"] = selected
end

function M.select_name(value)
    UserSelections["selected_name"] = value
    print("Selected values")
    print("Folder: " .. UserSelections["selected_folder"])
    print("Template: " .. UserSelections["selected_template"])
    print("Name: " .. UserSelections["selected_name"])
end

return M
