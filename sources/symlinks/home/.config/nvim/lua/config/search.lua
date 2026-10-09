-- Search
-- -------------------------------------------------------

-- Search without regard to case unless the query contains an uppercase letter.
vim.opt.ignorecase = true
-- Make searches case-sensitive when the query contains uppercase letters.
vim.opt.smartcase = true
-- Highlight matches while a search is being typed.
vim.opt.incsearch = true
-- Keep search matches highlighted until the search highlighting is cleared.
vim.opt.hlsearch = true

-- Clear search highlighting with Escape while in normal mode.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })
