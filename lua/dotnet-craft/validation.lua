local M = {}

local VALID_IDENTIFIER_PATTERN = "^[%a_][%w_]*$"

local CSHARP_KEYWORDS = {
	"abstract",
	"as",
	"base",
	"bool",
	"break",
	"byte",
	"case",
	"catch",
	"char",
	"checked",
	"class",
	"const",
	"continue",
	"decimal",
	"default",
	"delegate",
	"do",
	"double",
	"else",
	"enum",
	"event",
	"explicit",
	"extern",
	"false",
	"finally",
	"fixed",
	"float",
	"for",
	"foreach",
	"goto",
	"if",
	"implicit",
	"in",
	"int",
	"interface",
	"internal",
	"is",
	"lock",
	"long",
	"namespace",
	"new",
	"null",
	"object",
	"operator",
	"out",
	"override",
	"params",
	"private",
	"protected",
	"public",
	"readonly",
	"ref",
	"return",
	"sbyte",
	"sealed",
	"short",
	"sizeof",
	"stackalloc",
	"static",
	"string",
	"struct",
	"switch",
	"this",
	"throw",
	"true",
	"try",
	"typeof",
	"uint",
	"ulong",
	"unchecked",
	"unsafe",
	"ushort",
	"using",
	"virtual",
	"void",
	"volatile",
	"while",
}

local keyword_set = {}
for _, keyword in ipairs(CSHARP_KEYWORDS) do
	keyword_set[keyword] = true
end

function M.validate_name(name)
	if not name or name == "" then
		return false, "Name cannot be empty"
	end

	if #name > 100 then
		return false, "Name is too long (max 100 characters)"
	end

	if not name:match(VALID_IDENTIFIER_PATTERN) then
		return false,
			"Invalid name. Must start with letter or underscore, and contain only letters, digits, or underscores"
	end

	if keyword_set[name:lower()] then
		return false, "'" .. name .. "' is a reserved C# keyword"
	end

	return true, nil
end

function M.validate_directory(path)
	if not path or path == "" then
		return false, "Directory path is empty"
	end

	if vim.fn.isdirectory(path) ~= 1 then
		return false, "Directory does not exist: " .. path
	end

	return true, nil
end

function M.check_file_exists(filepath)
	local file = io.open(filepath, "r")
	if file then
		file:close()
		return true
	end
	return false
end

function M.validate_directory_writable(path)
	local test_file = path .. "/.dotnet_craft_test_" .. os.time()
	local file = io.open(test_file, "w")

	if not file then
		return false, "Directory is not writable: " .. path
	end

	file:close()
	os.remove(test_file)
	return true, nil
end

function M.validate_path_in_project(path, project_root)
	if not project_root then
		return true, nil
	end

	local normalized_path = vim.fn.fnamemodify(path, ":p")
	local normalized_root = vim.fn.fnamemodify(project_root, ":p")

	if normalized_path:sub(1, #normalized_root) ~= normalized_root then
		return false, "Path is outside project boundaries"
	end

	return true, nil
end

function M.validate_template(template_name, templates)
	if not template_name or template_name == "" then
		return false, "No template selected"
	end

	if not templates[template_name] then
		return false, "Template '" .. template_name .. "' does not exist"
	end

	return true, nil
end

function M.validate_all_selections(selections, templates)
	local errors = {}

	local folder_valid, folder_error = M.validate_directory(selections.selected_folder)
	if not folder_valid then
		table.insert(errors, folder_error)
	else
		local writable, write_error = M.validate_directory_writable(selections.selected_folder)
		if not writable then
			table.insert(errors, write_error)
		end
	end

	local template_valid, template_error = M.validate_template(selections.selected_template, templates)
	if not template_valid then
		table.insert(errors, template_error)
	end

	local name_valid, name_error = M.validate_name(selections.selected_name)
	if not name_valid then
		table.insert(errors, name_error)
	end

	if #errors > 0 then
		return false, errors
	end

	return true, nil
end

return M
