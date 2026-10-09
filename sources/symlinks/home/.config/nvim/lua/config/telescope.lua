-- Fuzzy finding
-- -------------------------------------------------------

vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
})

require('telescope').setup({
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
        },
        layout_strategy = 'vertical',
        sorting_strategy = 'ascending',
        layout_config = {
            vertical = {
                width = 0.75,
                height = 0.75,
                prompt_position = 'top',
                mirror = true,
                preview_height = 0.5,
            },
        },
    },
    pickers = {
        find_files = { hidden = true },
    },
})

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set({ 'n', 'x' }, '<leader>fw', builtin.grep_string, { desc = 'Grep string' })
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'File symbols' })
vim.keymap.set('n', '<leader>fS', builtin.lsp_workspace_symbols, { desc = 'Project symbols' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>fm', builtin.git_status, { desc = 'Git status' })
vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Resume last picker' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = 'All Telescope pickers' })
