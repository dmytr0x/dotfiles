return {
  {
    "tomasiser/vim-code-dark",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      vim.g.codedark_transparent = 1
      vim.cmd.colorscheme("codedark")

      -- diff Added line
      vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#383E2B" })
      -- diff Deleted line
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4E211E" })
      -- diff Changed line
      -- vim.api.nvim_set_hl(0, "DiffChange", { bg = "#00ff00" })
      -- diff Changed text within a changed line
      -- vim.api.nvim_set_hl(0, "Difftext", { bg = "#00ff00", fg = "#00ff00" })

      -- GitSigns plugin
      vim.api.nvim_set_hl(0, "GitSignsAddInline", { bg = "#4C5C2D" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { bg = "#72201D" })
      -- vim.api.nvim_set_hl(0, "GitSignsChangeInline", { bg = "#00ff00" })
      -- vim.api.nvim_set_hl(0, "Difftext", { bg = "#00ff00", fg = "#00ff00" })
    end,
  },
  { "folke/tokyonight.nvim" },
}
