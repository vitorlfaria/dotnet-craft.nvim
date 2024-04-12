local utils = require("dotnet-craft.utils")

local M = {}

function M.select_folder(selected)
    print("folder: " .. selected.name)
    print("path: " .. selected.path)
end

return M
