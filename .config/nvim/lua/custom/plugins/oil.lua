return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        columns = {
          -- "icon",
          -- "size",
          -- "mtime",
        },
        keymaps = {
          ["<C-h>"] = false,
          -- ['<M-h>'] = 'actions.select_split',
          ["gx"] = false,
        },
        view_options = {
          show_hidden = true,
        },
      })

      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

      -- Open parent directory in floating window
      -- vim.keymap.set("n", "<space>-", require("oil").toggle_float)
    end,
  },
}
