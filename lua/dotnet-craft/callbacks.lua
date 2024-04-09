local utils = require("dotnet-craft.utils")

local callbacks = {}

local function trim_folder(selected)
    local folder = string.gsub(selected, " ", "")
    local trimed_folder = string.gsub(folder, " ", "")
    return trimed_folder
end

local function get_parent_folder(items, selected)
    local file_index = utils.get_index(items, selected)
    local previous_node = items[file_index - 1]

    while not string.find(previous_node, "") do
        file_index = file_index - 1
        previous_node = items[file_index - 1]
    end

    return previous_node
end

function callbacks.select_folder(selected, items)
    if string.find(selected, "") then
        return trim_folder(selected)
    else
        local previous_node = get_parent_folder(items, selected)
        return trim_folder(previous_node)
    end
end

return callbacks
