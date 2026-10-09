-- File explorer
-- -------------------------------------------------------

-- Use netrw as a tree-style file explorer.
vim.g.netrw_liststyle = 3 -- tree view
vim.g.netrw_banner = 0 -- hide the top banner
vim.g.netrw_winsize = 25 -- fix the left split width
vim.g.netrw_browse_split = 0 -- open files in the previous window
vim.g.netrw_altfile = 1      -- keep the alternate file correct
vim.keymap.set('n', '<leader>e', '<Cmd>Lexplore<CR>', { silent = true, desc = 'Open explorer' })

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
