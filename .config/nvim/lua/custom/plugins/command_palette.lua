local fns = {}

function fns.toggle_virtual_text()
  vim.g.diagnostic_virtual_text = not vim.g.diagnostic_virtual_text
  vim.diagnostic.config({ virtual_text = vim.g.diagnostic_virtual_text })
end

function fns.init_virtual_text()
  -- turn off in-line diagnostic messages by default
  vim.g.diagnostic_virtual_text = false
  vim.diagnostic.config({
    virtual_text = vim.g.diagnostic_virtual_text,
    float = { border = "single" },
  })
end

function fns.show_treesitter_position()
  vim.show_pos()
end

function fns.show_treesitter_inspect_tree()
  vim.treesitter.inspect_tree()
end

function fns.toggle_inlay_hints()
  if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end
end

function fns.restart_lsp()
  vim.cmd("LspRestart")
end

return {
  "dmytr0x/command-palette.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local command_palette = require("command_palette")
    local cmd = command_palette.command

    local sources = {
      -- toggle functionality
      cmd("Toggle Virtual Text", fns.toggle_virtual_text, "lsp", fns.init_virtual_text),
      cmd("Toggle Inlay Hints", fns.toggle_inlay_hints, "lsp"),
      -- show functionality
      cmd("Show Treesitter Position", fns.show_treesitter_position),
      cmd("Show Treesitter Inspect Tree", fns.show_treesitter_inspect_tree),
      -- restart functionality
      cmd("Restart LSP", fns.restart_lsp, "lsp:reload"),
    }

    command_palette.setup(sources)

    vim.keymap.set("n", "<leader><leader>", function()
      command_palette.picker({})
    end)
  end,
}
