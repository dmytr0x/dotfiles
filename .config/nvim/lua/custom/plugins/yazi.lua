return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  config = function()
    require("yazi").setup({
      open_for_directories = true,
    })

    vim.keymap.set("n", "-", "<CMD>Yazi<CR>", { desc = "[Y]azi" })
    vim.keymap.set("n", "<leader>ly", "<CMD>Yazi cwd<CR>", { desc = "[Y]azi in cwd" })
  end,
}
