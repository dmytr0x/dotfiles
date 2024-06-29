return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telescope").load_extension("harpoon")
  end,
  keys = {
    vim.keymap.set("n", "<leader>ha", function()
      require("harpoon.mark").add_file()
    end, { desc = "Harpoon [A]dd File" }),

    vim.keymap.set("n", "<leader>hm", function()
      require("telescope").extensions.harpoon.marks({
        layout_strategy = "vertical",
        prompt_title = "Harpoon Marks",
        results_title = "Marks",
        preview_title = "Preview",
      })
    end, { desc = "Harpoon [M]arks" }),

    vim.keymap.set("n", "<leader>hl", function()
      local ui = require("harpoon.ui")
      ui.nav_next()
    end, { desc = "Harpoon [N]ext" }),

    vim.keymap.set("n", "<leader>hh", function()
      local ui = require("harpoon.ui")
      ui.nav_prev()
    end, { desc = "Harpoon [P]revious" }),
  },
  lazy = true,
}
