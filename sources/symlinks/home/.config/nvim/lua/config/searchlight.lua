-- Persistent search and replace panel
-- -------------------------------------------------------

vim.pack.add({
    'https://github.com/dmytr0x/searchlight',
})

require('searchlight').setup({ mappings = { search = false, replace = false, recent = false } })

vim.keymap.set('n', '<leader>sf', function()
  require('searchlight').search()
end, { desc = 'Searchlight: search' })

vim.keymap.set('n', '<leader>sk', function()
  require('searchlight').search({ close_on_open = true, case = true })
end, { desc = 'Searchlight: peek at a match' })

vim.keymap.set('n', '<leader>so', function()
  require('searchlight').reopen()
end, { desc = 'Searchlight: reopen most recent panel' })

