-- Bootstrap: must run before anything that reads the leader or loads ftplugins.
vim.g.mapleader = ' '
-- The Python ftplugin probes the python3 provider, which spawns python3 to look for pynvim.
vim.g.loaded_python3_provider = 0

local map = vim.keymap.set
local group = vim.api.nvim_create_augroup('config', {})

-- Windows: open new splits to the right and below.
vim.o.splitright = true
vim.o.splitbelow = true

-- Editor: line numbers, stable sign column, completion menu, folds open by default.
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.completeopt = 'menuone,noselect,popup,fuzzy'
vim.o.foldlevelstart = 99

-- Diagnostics: inline messages, most severe first.
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
})

-- LSP: servers and per-buffer features enabled on attach.
vim.lsp.enable({ 'ty', 'ruff' })
-- CursorHold delay for document highlights.
vim.o.updatetime = 250

vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    if client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldmethod = 'expr'
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
    if client:supports_method('textDocument/documentHighlight') then
      local hl_group = vim.api.nvim_create_augroup('lsp_highlight_' .. ev.buf, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = hl_group,
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        group = hl_group,
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- Formatting: :Format, optional format-on-save, and its toggle.
vim.g.autoformat = false

vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format() end, {})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = group,
  callback = function(ev)
    local formatters = vim.lsp.get_clients({ bufnr = ev.buf, method = 'textDocument/formatting' })
    if vim.g.autoformat and #formatters > 0 then
      vim.lsp.buf.format({ bufnr = ev.buf })
    end
  end,
})

map('n', '<leader><leader>f', function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify('autoformat: ' .. tostring(vim.g.autoformat))
end, { desc = 'Toggle auto-format' })

-- LSP keymaps: <C-]> jumps to definition via the LSP tagfunc.
map('n', 'gD', vim.lsp.buf.declaration)
map('n', 'gL', '<Cmd>vertical wincmd ]<CR>', { desc = 'Definition in vsplit' })
map('n', 'gJ', '<C-w>]', { desc = 'Definition in split' })
map('n', 'grc', vim.lsp.buf.incoming_calls, { desc = 'Incoming calls' })
map('n', 'grC', vim.lsp.buf.outgoing_calls, { desc = 'Outgoing calls' })
map('n', 'grh', function() vim.lsp.buf.typehierarchy('subtypes') end, { desc = 'Subtypes' })
map('n', 'grH', function() vim.lsp.buf.typehierarchy('supertypes') end, { desc = 'Supertypes' })
map('n', 'grf', function()
  vim.lsp.buf.code_action({ context = { only = { 'source.fixAll.ruff' } }, apply = true })
end, { desc = 'Ruff fix all' })
map('n', '<leader>S', vim.lsp.buf.workspace_symbol, { desc = 'Workspace symbols' })
map('n', '<leader><leader>a', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- Appearance: last, so a colorscheme error cannot abort the rest of the config.
vim.cmd.colorscheme('dmytr0x-dark-modern')
