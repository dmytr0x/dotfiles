return {
  "jvgrootveld/telescope-zoxide",
  config = function()
    vim.keymap.set("n", "<leader>cd", require("telescope").extensions.zoxide.list)
  end,
}
