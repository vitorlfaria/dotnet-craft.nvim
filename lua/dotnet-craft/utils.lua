local utils = {}

function utils.get_index(t, value)
    for k, v in pairs(t) do
        if v == value then
            return k
        end
    end
    return nil
end

function utils.split(str, sep)
    local result = {}
    for token in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(result, token)
    end
    return result
end

function utils.disable_insert_mode_for_buffer(bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":lua ClosePopup()<CR>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "o", "<nop>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "O", "<nop>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "i", "<nop>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "I", "<nop>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "a", "<nop>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "A", "<nop>", { silent = false })
end

return utils
