--  See `:help vim.keymap.set()`

-- TIPS:
--
--  ** How to remove keybind:
--   vim.keymap.set("n", key, "<nop>")
--
--  ** How to close all windows except the current one
--   :on[ly]
--
--  ** Join lines
--  J - join two lines with space delimiter
--  gJ - join two lines without any delimiter
--
--  ** Insert / Append the same text to few lines
--   ctrl+v    - select lines
--   shift+i   - insert text at the beginning
--   esc
--   gv        - return previous selection
--   shift+4   - move to the end of the lines
--   shift+a   - append text at the end

-- DEFAULT KEY MAPS:
--
--  ** Resize windows
-- `              - Reverse text of selected text
-- %              - Jump to the pared symbol, e.g. {},[],"", ...
--
-- ctrl + w |     - Expand window vertically
-- ctrl + w _     - Expand window horizontally - press Ctrl + w and then press "_"
-- ctrl + w =     - This will resize all the windows and make them equal.

-- ctrl + v       - Activate "Visual Block" mode
-- gv             - Return previous selection
--
--
local map = require("core.keymap").map

-- Set highlight on search
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", function()
  vim.cmd("nohlsearch") -- Stop the highlighting for the 'hlsearch' option
  vim.cmd("NoiceDismiss") -- Dismiss Noice message (plug-in)
end)

-- -- Turn off in-line diagnostic messages
-- vim.g.diagnostic_virtual_text = false
-- vim.diagnostic.config({
--   virtual_text = vim.g.diagnostic_virtual_text,
--   float = { border = "single" },
-- })

-- Diagnostic key maps
map("n", "[d", vim.diagnostic.goto_prev, "Go to previous [D]iagnostic message")
map("n", "]d", vim.diagnostic.goto_next, "Go to next [D]iagnostic message")
map("n", "<leader>e", vim.diagnostic.open_float, "Show Diagnostic M[e]ssages")

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", "Move focus to the left window")
map("n", "<C-l>", "<C-w><C-l>", "Move focus to the right window")
map("n", "<C-j>", "<C-w><C-j>", "Move focus to the lower window")
map("n", "<C-k>", "<C-w><C-k>", "Move focus to the upper window")

-- Use "Black hole register" (Deleting without yanking):
map({ "n", "v" }, "x", '"_x')
map({ "n", "v" }, "X", '"_X')

-- Keep cursor centred when scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Move selected line / block of text
map("x", "J", ":m '>+1<CR>gv=gv")
map("x", "K", ":m '<-2<CR>gv=gv")

-- Better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Paste over currently selected text without yanking it
map("v", "p", '"_dp')
map("v", "P", '"_dP')

-- Move to start/end of line
map({ "n", "x" }, "H", "^")
map({ "n", "x" }, "L", "g_")

-- Select all
map("n", "<S-C-a>", "ggVG")

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- External Apps
-- Text Editor
map("n", "<leader>lz", "<cmd>!zed % &<enter>", "[Z]ed")
-- Git Client
map("n", "<leader>lf", function()
  vim.fn.system("fork --git-dir=" .. vim.fn.getcwd())
end, "[F]ork")

-- Handy
-- vim.keymap.set("i", "jk", "<esc>")
map("n", "<Space>q", "<cmd>q<enter>", "[Q]uit window")
map("n", "<Space>Q", "<cmd>bdelete<enter>", "[Q]uit buffer")
map("n", "<Space>w", "<cmd>w<enter>", "[W]rite")
map("n", "<c-c>", "<cmd>q!<enter>", "[Q]uit force")
map({ "n", "x" }, "<Space>'", '"_', "Activate wormhole register")
-- Easy way to record and replay macro
map("n", "Q", "qj")
map("x", "Q", ":norm @j<CR>")

-- Scroll to the middle after jump to the line jump
map("n", "<s-g>", "Gzz")

-- Moving through quickfix list
map("n", "]q", "<cmd>cnext<enter>", "Next [Q]uickfix List")
map("n", "[q", "<cmd>cprev<enter>", "Previous [Q]uickfix List")

-- Moving through buffers
map("n", "]b", ":bnext<enter>", "Next [B]uffer (by order)")
map("n", "[b", ":bprev<enter>", "Previous [B]uffer (by order)")
map("n", "[o", ":b#<enter>", "Previous [O]pened buffer")

-- Insert new line
map("n", "[<space>", "O<esc>j", "Insert line above")
map("n", "]<space>", "o<esc>k", "Insert line below")

-- vim: ts=2 sts=2 sw=2 et
