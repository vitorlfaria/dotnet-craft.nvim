local M = {}

local function find_csproj_file(start_dir)
	local current_dir = start_dir
	local max_depth = 10
	local depth = 0

	while depth < max_depth do
		local csproj_files = vim.fn.glob(current_dir .. "/*.csproj", false, true)

		if #csproj_files > 0 then
			return csproj_files[1], current_dir
		end

		local parent = vim.fn.fnamemodify(current_dir, ":h")

		if parent == current_dir or parent == "" then
			break
		end

		current_dir = parent
		depth = depth + 1
	end

	return nil, nil
end

local function parse_root_namespace_from_csproj(csproj_path)
	local file = io.open(csproj_path, "r")
	if not file then
		return nil
	end

	local content = file:read("*all")
	file:close()

	local root_ns = content:match("<RootNamespace>([^<]+)</RootNamespace>")

	if not root_ns then
		root_ns = content:match("<AssemblyName>([^<]+)</AssemblyName>")
	end

	return root_ns
end

local function parse_namespace_from_cs_file(file_path)
	local file = io.open(file_path, "r")
	if not file then
		return nil
	end

	for line in file:lines() do
		local ns_modern = line:match("^%s*namespace%s+([%w%.]+)%s*;")
		if ns_modern then
			file:close()
			return ns_modern
		end

		local ns_classic = line:match("^%s*namespace%s+([%w%.]+)%s*{?")
		if ns_classic then
			file:close()
			return ns_classic
		end
	end

	file:close()
	return nil
end

local function find_cs_file_in_directory(dir)
	local cs_files = vim.fn.glob(dir .. "/*.cs", false, true)

	if #cs_files > 0 then
		return cs_files[1]
	end

	return nil
end

local function get_relative_path(from_dir, to_dir)
	from_dir = vim.fn.fnamemodify(from_dir, ":p"):gsub("/$", "")
	to_dir = vim.fn.fnamemodify(to_dir, ":p"):gsub("/$", "")

	if from_dir == to_dir then
		return ""
	end

	if to_dir:sub(1, #from_dir) == from_dir then
		local relative = to_dir:sub(#from_dir + 2)
		return relative
	end

	return nil
end

local function path_to_namespace_segment(path)
	if not path or path == "" then
		return ""
	end

	local namespace_part = path:gsub("[/\\]+", ".")

	namespace_part = namespace_part:gsub("^%.+", ""):gsub("%.+$", "")

	return namespace_part
end

function M.get_namespace_for_directory(target_dir)
	local csproj_path, project_root = find_csproj_file(target_dir)

	if not csproj_path or not project_root then
		local cs_file = find_cs_file_in_directory(target_dir)
		if cs_file then
			local ns = parse_namespace_from_cs_file(cs_file)
			if ns then
				return ns
			end
		end

		local dir_name = vim.fn.fnamemodify(target_dir, ":t")
		return dir_name
	end

	local root_namespace = parse_root_namespace_from_csproj(csproj_path)

	if not root_namespace then
		root_namespace = vim.fn.fnamemodify(csproj_path, ":t:r")
	end

	local relative_path = get_relative_path(project_root, target_dir)

	if not relative_path or relative_path == "" then
		return root_namespace
	end

	local namespace_suffix = path_to_namespace_segment(relative_path)

	if namespace_suffix == "" then
		return root_namespace
	end

	return root_namespace .. "." .. namespace_suffix
end

function M.is_dotnet_project(dir)
	local csproj_path = find_csproj_file(dir)
	return csproj_path ~= nil
end

function M.get_project_root(start_dir)
	local _, project_root = find_csproj_file(start_dir)
	return project_root
end

function M.debug_namespace_detection(target_dir)
	print("=== Namespace Detection Debug ===")
	print("Target directory:", target_dir)

	local csproj_path, project_root = find_csproj_file(target_dir)
	print("Project root:", project_root or "NOT FOUND")
	print("CsProj file:", csproj_path or "NOT FOUND")

	if csproj_path then
		local root_ns = parse_root_namespace_from_csproj(csproj_path)
		print("Root namespace from .csproj:", root_ns or "NOT FOUND")

		local relative_path = get_relative_path(project_root, target_dir)
		print("Relative path:", relative_path or "SAME DIR")
	end

	local cs_file = find_cs_file_in_directory(target_dir)
	if cs_file then
		print("Found CS file:", cs_file)
		local ns = parse_namespace_from_cs_file(cs_file)
		print("Namespace from CS file:", ns or "NOT FOUND")
	end

	local final_ns = M.get_namespace_for_directory(target_dir)
	print("Final namespace:", final_ns)
	print("================================")

	return final_ns
end

return M
