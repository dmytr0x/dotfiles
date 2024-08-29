-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do

return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "nvim-web-devicons",
  },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signs_staged = {
      add = { text = "＋" },
      change = { text = "～" },
      delete = { text = "⎵" },
      topdelete = { text = "⎴" },
      changedelete = { text = "～" },
    },
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, { desc = "Hunk Next" })

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, { desc = "Hunk Previous" })

      -- Actions
      map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Hunk [S]tage" })
      map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "[U]ndo Stage Hunk", noremap = true, silent = false })
      map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Hunk [R]eset" })
      map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "[P]review Hunk" })
      map("n", "<leader>hB", gitsigns.toggle_current_line_blame)
      map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = false })
      end, { desc = "[B]lame Line" })
    end,
  },
}
