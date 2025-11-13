local selections = require("dotnet-craft.selections")
local state = require("dotnet-craft.state")

local dotnet_craft = {}

function dotnet_craft.craft()
	state.init()
	selections.open_folder_selection_popup()
end

return dotnet_craft
