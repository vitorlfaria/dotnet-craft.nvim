local M = {}

local default_config = {
	ui = {
		width = 60,
		height_percentage = 0.2,
		max_height_percentage = 0.6,
		line = 5,
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	},

	excluded_dirs = {
		"bin",
		"obj",
		"node_modules",
		".git",
		".vs",
		".vscode",
		"packages",
		"TestResults",
		"coverage",
		"artifacts",
	},

	template_placeholders = {
		author = os.getenv("USER") or os.getenv("USERNAME") or "Developer",
		company = "MyCompany",
		year = os.date("%Y"),
		date = os.date("%Y-%m-%d"),
	},

	add_file_header = false,

	file_header = [[
// -----------------------------------------------------------------------
// <copyright file="{{name}}.cs" company="{{company}}">
//     Copyright (c) {{year}} {{company}}. All rights reserved.
// </copyright>
// <author>{{author}}</author>
// <date>{{date}}</date>
// -----------------------------------------------------------------------
]],

	add_common_usings = true,

	common_usings = {
		["Class"] = {},
		["Interface"] = {},
		["Record"] = {},
		["Enum"] = {},
		["Api Controller"] = {
			"using Microsoft.AspNetCore.Mvc;",
		},
	},

	custom_templates = {},

	notifications = {
		enabled = true,
		on_success = true,
		warn_no_csproj = true,
	},

	behavior = {
		open_file_after_creation = true,
		confirm_overwrite = true,
		auto_format = false,
	},
}

local config = vim.deepcopy(default_config)

function M.setup(user_config)
	if not user_config then
		return
	end

	config = vim.tbl_deep_extend("force", config, user_config)
end

function M.get()
	return config
end

function M.get_value(path)
	local keys = vim.split(path, ".", { plain = true })
	local value = config

	for _, key in ipairs(keys) do
		if type(value) ~= "table" then
			return nil
		end
		value = value[key]
	end

	return value
end

function M.set_value(path, new_value)
	local keys = vim.split(path, ".", { plain = true })
	local current = config

	for i = 1, #keys - 1 do
		local key = keys[i]
		if type(current[key]) ~= "table" then
			current[key] = {}
		end
		current = current[key]
	end

	current[keys[#keys]] = new_value
end

function M.reset()
	config = vim.deepcopy(default_config)
end

function M.get_ui_config()
	local ui = config.ui
	return {
		height = math.floor(vim.o.lines * ui.height_percentage),
		max_height = math.floor(vim.o.lines * ui.max_height_percentage),
		width = ui.width,
		line = ui.line,
		col = math.floor((vim.o.columns - ui.width) / 2),
		borderchars = ui.borderchars,
	}
end

function M.get_excluded_dirs()
	return config.excluded_dirs
end

function M.add_template(name, template_content)
	config.custom_templates[name] = template_content
end

function M.get_all_templates()
	local builtin = require("dotnet-craft.templates")
	return vim.tbl_extend("force", builtin, config.custom_templates)
end

function M.get_template_placeholders()
	config.template_placeholders.year = os.date("%Y")
	config.template_placeholders.date = os.date("%Y-%m-%d")

	return config.template_placeholders
end

function M.replace_placeholders(content, name, namespace)
	local placeholders = M.get_template_placeholders()

	content = content:gsub("{{name}}", name)
	content = content:gsub("{{namespace}}", namespace)

	for key, value in pairs(placeholders) do
		content = content:gsub("{{" .. key .. "}}", value)
	end

	return content
end

function M.build_file_content(template_name, template_content, name, namespace)
	local parts = {}

	if config.add_file_header then
		local header = M.replace_placeholders(config.file_header, name, namespace)
		table.insert(parts, header)
		table.insert(parts, "")
	end

	if config.add_common_usings then
		local usings = config.common_usings[template_name] or {}
		if #usings > 0 then
			for _, using in ipairs(usings) do
				table.insert(parts, using)
			end
			table.insert(parts, "")
		end
	end

	table.insert(parts, template_content)

	local full_content = table.concat(parts, "\n")

	full_content = M.replace_placeholders(full_content, name, namespace)

	return full_content
end

return M
