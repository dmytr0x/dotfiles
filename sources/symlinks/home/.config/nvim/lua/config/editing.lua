-- Editing and clipboard
-- -------------------------------------------------------

-- Use spaces instead of tab characters when indenting.
vim.opt.expandtab = true
-- Use two spaces for each automatic indentation level.
vim.opt.shiftwidth = 2
-- Display existing tab characters as two spaces wide.
vim.opt.tabstop = 2

-- Set indentation separately for languages that differ from the default.
local indent_width = { python = 4 }
vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(indent_width),
  callback = function(args)
    local width = indent_width[args.match]
    vim.bo[args.buf].shiftwidth = width
    vim.bo[args.buf].tabstop = width
    vim.bo[args.buf].softtabstop = width
    vim.bo[args.buf].expandtab = true
  end,
})

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
