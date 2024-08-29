return { -- Useful plugin to show you pending keybinds.
  "folke/which-key.nvim",
  event = "VimEnter", -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    --
    -- Example of disabling the operator "v"
    -- local presets = require("which-key.plugins.presets")
    -- presets.operators["v"] = nil

    local wk = require("which-key")
    wk.setup({
      preset = "modern",
      delay = 500,
      plugins = {
        spelling = {
          enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        },
      },
      show_help = false, -- show a help message in the command line for using WhichKey
      show_keys = false, -- show the currently pressed key and its label as a message in the command line
      icons = {
        rules = false,
      },
      sort = { "order" },
      expand = 0,
    })

    wk.add({
      { "g", group = "Go To" },
      { "<leader>", group = "Main" },
      { "<leader>c", group = "Code" },
      { "<leader>t", group = "Toggle" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>s", group = "Search" },
      { "<leader>l", group = "Launch" },
      { "<leader><leader>", group = "Command Palette" },
    })
  end,
}
