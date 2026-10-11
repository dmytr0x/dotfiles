-- Tree-sitter parsers and queries for Searchlight syntax colors
-- -------------------------------------------------------

vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

require('nvim-treesitter').install({
    'python',
})
