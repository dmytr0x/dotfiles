return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "[A]dd" })

    vim.keymap.set("n", "<leader>hc", function()
      harpoon:list():clear()
    end, { desc = "[C]lear" })

    vim.keymap.set("n", "<leader>hh", function()
      harpoon:list():prev()
    end, { desc = "Show [P]revious" })

    vim.keymap.set("n", "<leader>hl", function()
      harpoon:list():next()
    end, { desc = "Show [N]ext" })

    -- Set <leader>1..<leader>5 be shortcuts to moving to the files
    for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
      vim.keymap.set("n", string.format("<leader>h%d", idx), function()
        harpoon:list():select(idx)
      end, { desc = string.format("Show mark %d", idx) })
    end

    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({
          layout_strategy = "vertical",
          prompt_title = "Harpoon Marks",
          results_title = "Marks",
          preview_title = "Preview",
        }, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end

    vim.keymap.set("n", "<leader>hm", function()
      toggle_telescope(harpoon:list())
    end, { desc = "Show [M]arks" })
  end,
}
