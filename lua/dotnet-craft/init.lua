local selections = require("dotnet-craft.selections")

local dotnet_craft = {}

UserSelections = {}

Win_id = nil

function ClosePopup()
	vim.api.nvim_win_close(Win_id, true)
end

function dotnet_craft.craft()
    selections.open_folder_selection_popup()
end

return dotnet_craft
