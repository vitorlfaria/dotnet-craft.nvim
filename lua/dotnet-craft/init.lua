local M = {}
local popup = require("plenary.popup")
local scandir = require("plenary.scandir")

local function openFolderExplorerPopup()
    local height = math.floor(vim.o.lines / 2)
    local width = math.floor(vim.o.columns / 2)
    local line = math.floor(((vim.o.lines - height) / 2) - 1)
    local col = math.floor((vim.o.columns - width) / 2)
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

    local cwd = vim.fn.getcwd()
    local files = scandir.scan_dir(cwd)

    local items = {}
    local split = vim.fn.split(cwd, "/")
    local current_folder = split[#split]
    for _, file in ipairs(files) do
        local file_split = Split(file, "/")
        local index = 0
        for i, v in ipairs(file_split) do
            if v == current_folder then
                index = i
                break
            end
        end

        for i = index + 1, #file_split do
            local item = file_split[i]
            local indent = string.rep("  ", i - index - 1)
            if i == #file_split then
                item = "󰈔 " .. item
            else
                item = " " .. item
            end

            local found = false
            for _, v in ipairs(items) do
                if v == indent .. item then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(items, indent .. item)
            end
        end
    end

    Win_id = popup.create(items, {
        title = "Select Folder",
        line = line,
        col = col,
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        padding = { 0, 0, 0, 3 },
        callback = function(_, selected)
            -- check if selected is a folder by checking if it contains a 
            if string.find(selected, "") then
                local folder = string.gsub(selected, " ", "")
                local trimed_folder = string.gsub(folder, " ", "")
                print("Selected folder: " .. trimed_folder)
            end
        end
    })

    local bufnr = vim.api.nvim_win_get_buf(Win_id)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":lua ClosePopup()<CR>", { silent = false })
end

function Split(str, sep)
    local result = {}
    for token in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(result, token)
    end
    return result
end

function ClosePopup()
    vim.api.nvim_win_close(Win_id, true)
end

function M.craft()
	openFolderExplorerPopup()
end

return M
