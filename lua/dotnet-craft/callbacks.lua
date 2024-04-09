local utils = require("dotnet-craft.utils")

local callbacks = {}

function callbacks.select_folder(selected, items)
    if string.find(selected, "") then
        local folder = string.gsub(selected, " ", "")
        local trimed_folder = string.gsub(folder, " ", "")
        print("Selected folder: " .. trimed_folder)
    else
        local file_index = utils.get_index(items, selected)
        local previous_node = items[file_index - 1]
        while not string.find(previous_node, "") do
            file_index = file_index - 1
            previous_node = items[file_index - 1]
        end
        local folder = string.gsub(previous_node, " ", "")
        local trimed_folder = string.gsub(folder, " ", "")
        print("Selected folder: " .. trimed_folder)
    end
end

return callbacks
