return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telescope").load_extension("harpoon")
  end,
  keys = {
    vim.keymap.set("n", "<leader>hm", ":Telescope harpoon marks<CR>", { desc = "Harpoon [M]arks" }),
    vim.keymap.set("n", "<leader>ha", ":lua require('harpoon.mark').add_file()<CR>", { desc = "Harpoon [A]dd File" }),
  },
  lazy = true,
}
