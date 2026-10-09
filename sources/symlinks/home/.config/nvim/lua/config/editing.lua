-- Editing and clipboard
-- -------------------------------------------------------

-- Use spaces instead of tab characters when indenting.
vim.opt.expandtab = true
-- Use four spaces for each automatic indentation level.
vim.opt.shiftwidth = 4
-- Display existing tab characters as four spaces wide.
vim.opt.tabstop = 4

-- Make backspace remove indentation, line breaks, and text before the cursor.
vim.opt.backspace = { "indent", "eol", "start" }

-- Move the current line down one line while remaining in normal mode.
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
-- Move the current line up one line while remaining in normal mode.
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
-- Move the selected lines down one line and keep them selected.
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
-- Move the selected lines up one line and keep them selected.
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
-- Select the word under the cursor.
vim.keymap.set('n', '<leader>v', 'viw', { desc = 'Select word under cursor' })

-- Use the system clipboard for yank, delete, and paste operations.
-- vim.opt.clipboard = "unnamedplus"

-- Clipboard: yank to the OS clipboard without making it the default register.
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })

-- Files and undo
-- -------------------------------------------------------

-- Reload files changed outside Neovim.
vim.opt.autoread = true

-- Keep a persistent undo history across Neovim restarts.
vim.opt.undofile = true
