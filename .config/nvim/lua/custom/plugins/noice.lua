return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      presets = {
        -- long messages will be sent to a split
        long_message_to_split = true,
        command_palette = false,
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", kind = "", find = "; before" },
          opts = { skip = true },
        },
        {
          filter = { event = "notify", find = "No information available" },
          opts = { skip = true },
        },
      },
    })

    require("notify").setup({
      background_colour = "#000000",
    })

    require("telescope").load_extension("noice")
  end,
}
