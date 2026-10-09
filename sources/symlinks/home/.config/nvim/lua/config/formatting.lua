local group = vim.api.nvim_create_augroup('config_formatting', { clear = true })

-- Formatting
-- -------------------------------------------------------

vim.g.autoformat = false

local function format_buffer()
    vim.lsp.buf.format()
end

local function format_on_save(ev)
    local formatters = vim.lsp.get_clients({ bufnr = ev.buf, method = 'textDocument/formatting' })
    if vim.g.autoformat and #formatters > 0 then
        vim.lsp.buf.format({ bufnr = ev.buf })
    end
end

vim.api.nvim_create_user_command('Format', format_buffer, {})
vim.api.nvim_create_autocmd('BufWritePre', { group = group, callback = format_on_save })

-- local function toggle_autoformat()
--     vim.g.autoformat = not vim.g.autoformat
--     vim.notify('autoformat: ' .. tostring(vim.g.autoformat))
-- end
-- vim.keymap.set('n', '<leader><leader>f', toggle_autoformat, { desc = 'Toggle auto-format' })
