local selections = require("dotnet-craft.selections")
local state = require("dotnet-craft.state")
local config = require("dotnet-craft.config")

local dotnet_craft = {}

function dotnet_craft.setup(user_config)
	config.setup(user_config)
end

function dotnet_craft.craft()
	state.init()
	selections.open_folder_selection_popup()
end

return dotnet_craft
