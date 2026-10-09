local group = vim.api.nvim_create_augroup('config_lsp', { clear = true })

-- Language features
-- -------------------------------------------------------

-- Control how built-in completion suggestions are displayed.
-- vim.o.completeopt = 'menuone,noselect,popup,fuzzy'
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
})

-- LSP
vim.lsp.enable({ 'ty', 'ruff' })
vim.o.updatetime = 250

local function on_lsp_attach(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    -- Show LSP completion suggestions automatically while typing.
    if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    -- Use LSP folding ranges to calculate folds in the current window.
    if client:supports_method('textDocument/foldingRange') then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldmethod = 'expr'
        vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    -- Highlight references to the symbol under the cursor after a pause, and clear them on movement.
    if client:supports_method('textDocument/documentHighlight') then
        local hl_group = vim.api.nvim_create_augroup('lsp_highlight_' .. ev.buf, { clear = true })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { group = hl_group, buffer = ev.buf, callback = vim.lsp.buf.document_highlight })
        vim.api.nvim_create_autocmd('CursorMoved', { group = hl_group, buffer = ev.buf, callback = vim.lsp.buf.clear_references })
    end
end

vim.api.nvim_create_autocmd('LspAttach', { group = group, callback = on_lsp_attach })

local function show_subtypes()
    vim.lsp.buf.typehierarchy('subtypes')
end

local function show_supertypes()
    vim.lsp.buf.typehierarchy('supertypes')
end

local function ruff_fix_all()
    vim.lsp.buf.code_action({ context = { only = { 'source.fixAll.ruff' } }, apply = true })
end

local function toggle_inlay_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

-- LSP keymaps
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Definition' })
vim.keymap.set('n', 'gL', '<Cmd>vertical wincmd ]<CR>', { desc = 'Definition in vsplit' })
vim.keymap.set('n', 'gJ', '<C-w>]', { desc = 'Definition in split' })
vim.keymap.set('n', 'grc', vim.lsp.buf.incoming_calls, { desc = 'Incoming calls' })
vim.keymap.set('n', 'grC', vim.lsp.buf.outgoing_calls, { desc = 'Outgoing calls' })
vim.keymap.set('n', 'grh', show_subtypes, { desc = 'Subtypes' })
vim.keymap.set('n', 'grH', show_supertypes, { desc = 'Supertypes' })
vim.keymap.set('n', 'grf', ruff_fix_all, { desc = 'Ruff fix all' })
vim.keymap.set('n', '<leader>S', vim.lsp.buf.workspace_symbol, { desc = 'Workspace symbols' })
vim.keymap.set('n', '<leader><leader>a', toggle_inlay_hints, { desc = 'Toggle inlay hints' })
