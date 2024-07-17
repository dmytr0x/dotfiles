return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { "<leader>lg", "<cmd>LazyGit<CR>", desc = "Lazy[G]it" },
  },
  config = function()
    vim.g.lazygit_use_custom_config_file_path = 1
    vim.g.lazygit_config_file_path = {
      vim.fn.expand("~/.config/lazygit/config.yml"),
    }

    vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "Lazy[G]it" })
  end,
}
