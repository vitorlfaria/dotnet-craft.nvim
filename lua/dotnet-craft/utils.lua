local M = {}

function M.get_index(t, value)
    for k, v in pairs(t) do
        if v == value then
            return k
        end
    end
    return nil
end

function M.split(str, sep)
    local result = {}
    for token in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(result, token)
    end
    return result
end

function M.disable_insert_mode_for_buffer(bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":lua ClosePopup()<CR>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "o", "<nop>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "O", "<nop>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "i", "<nop>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "I", "<nop>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "a", "<nop>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "A", "<nop>", { silent = false })
end

function M.scandir(dir)
    local p = io.popen('find "' .. dir .. '" -type d')
    local dirs = {}
    for line in p:lines() do
        if not string.match(line, "/%..*") then
            table.insert(dirs, line)
        end
    end
    return dirs
end

return M
