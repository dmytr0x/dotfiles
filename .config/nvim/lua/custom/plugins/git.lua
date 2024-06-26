return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = true,
  init = function()
    local neogit = require 'neogit'
    neogit.setup()

    vim.keymap.set('n', '<leader>Go', '<cmd>Neogit kind=replace<CR>', { desc = '[G]it [O]pen' })
    vim.keymap.set('n', '<leader>Gr', ':Telescope git_branches<CR>', { desc = '[G]it B[r]anches' })
    -- vim.keymap.set('n', '<leader>Gb', '', { desc = '[G]it [B]lame' })
  end,
}
