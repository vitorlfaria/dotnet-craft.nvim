local utils = require("dotnet-craft.utils")

local callbacks = {}

local function trim_folder(selected)
    local folder = string.gsub(selected, " ", "")
    local trimed_folder = string.gsub(folder, " ", "")
    return trimed_folder
end

local function get_parent_folder(tree, selected)
    local file_index = utils.get_index(tree, selected)
    local previous_node = tree[file_index - 1]

    while not string.find(previous_node, "") do
        file_index = file_index - 1
        previous_node = tree[file_index - 1]
    end

    return previous_node
end

local function get_folder_path(tree, selected)
    print("getting folder path")
    local splited = utils.split(selected, " ")
    local level = 0
    for i = 1, #splited do
        print(splited[i])
    end
end

function callbacks.select_folder(selected, tree)
    if string.find(selected, "") then
        local folder = get_folder_path(tree, selected)
    else
        local previous_node = get_parent_folder(tree, selected)
        return trim_folder(previous_node)
    end
end

return callbacks
