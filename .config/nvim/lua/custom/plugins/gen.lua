return {
  "David-Kunz/gen.nvim",
  config = function()
    require("gen").setup({
      model = "dmytr0x-ai",
      -- model = "codeqwen",
      -- model = "llama3.1",
      display_mode = "horizontal-split",
      host = "192.168.178.38",
      -- host = "127.0.0.1",
      port = "11434",
    })
    vim.keymap.set({ "n", "v" }, "<leader>]", ":Gen<CR>")
    vim.keymap.set("n", "<leader>[", ":Gen Chat<CR>")
  end,
}
