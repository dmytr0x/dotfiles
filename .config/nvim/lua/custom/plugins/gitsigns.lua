-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do

return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  dependencies = {
    'nvim-web-devicons',
  },
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Hunk Next' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Hunk Previous' })

      -- Actions
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Hunk [S]tage' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Hunk [R]eset' })
      map('v', '<leader>hs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Hunk [S]tage' })
      map('v', '<leader>hr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Hunk [R]eset' })
      map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = '[U]ndo Stage Hunk' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[P]review Hunk' })
      map('n', '<leader>hb', function()
        gitsigns.blame_line { full = true }
      end, { desc = '[B]lame Line' })
      -- ?
      -- map('n', '<leader>hd', gitsigns.diffthis, { desc = '[D]iff This' })
      -- map('n', '<leader>hD', function()
      --   gitsigns.diffthis '~'
      -- end, { desc = '[D]iff This' })
      -- map('n', '<leader>td', gitsigns.toggle_deleted, { desc = '[T]oggle [D]eleted' })
    end,
  },
}
