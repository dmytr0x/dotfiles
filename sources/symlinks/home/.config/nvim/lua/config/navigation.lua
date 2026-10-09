-- Windows and navigation
-- -------------------------------------------------------

-- Show absolute line numbers so locations are easy to reference.
vim.opt.number = true
-- Show each line's distance from the current line for quick movement.
vim.opt.relativenumber = true
-- Keep a small visual margin around the cursor when scrolling.
vim.opt.scrolloff = 5
-- Keep a small visual margin around the cursor horizontally when scrolling.
vim.opt.sidescrolloff = 5

-- Open horizontal splits below the current window.
vim.opt.splitbelow = true
-- Open vertical splits to the right of the current window.
vim.opt.splitright = true

-- Allow switching buffers while the current buffer has unsaved changes.
vim.opt.hidden = true

-- Quit the current window.
vim.keymap.set('n', '<leader>q', '<Cmd>q<CR>', { desc = 'Quit' })

-- Start with folds open, including those provided by the LSP.
vim.o.foldlevelstart = 99
