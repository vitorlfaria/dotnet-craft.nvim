local templates = require("dotnet-craft.templates")
local utils = require("dotnet-craft.utils")

local Crafter = {}

local function write_file(location, content)
    local file = io.open(location, "w")

    if file == nil then
        print("Error: Could not create file")
        return
    end

    file:write(content)
    file:close()
end

local function get_namespace()
    local cwd = vim.fn.getcwd()
    local split = vim.fn.split(cwd, "/")
    local current_folder = split[#split]
    local path = UserSelections["selected_folder"]
    local path_split = utils.split(path, "/")
    local cwd_index = utils.get_index(path_split, current_folder)
    local namespace = ""
    for i = cwd_index, #path_split do
        namespace = namespace .. path_split[i] .. "."
    end
    namespace = namespace:sub(1, -2)
    return namespace
end

function Crafter.craft_item()
    local namespace = get_namespace()
    local template = templates[UserSelections["selected_template"]]
    local content = string.gsub(template, "{{name}}", UserSelections["selected_name"])
    content = string.gsub(content, "{{namespace}}", namespace)
    local location = UserSelections["selected_folder"] .. "/" .. UserSelections["selected_name"] .. ".cs"
    write_file(location, content)
end

return Crafter
