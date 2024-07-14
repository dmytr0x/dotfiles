-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

local map = require("core.keymap").map

return {
  -- NOTE: Yes, you can install new plugins here!
  "mfussenegger/nvim-dap",
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",
    -- Required dependency for nvim-dap-ui
    "nvim-neotest/nvim-nio",

    -- Installs the debug adapters for you
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",

    -- Add your own debuggers here
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        "debugpy",
      },
    })

    -- Basic debugging keymaps, feel free to change to your liking!
    map("n", "<leader>d<F5>", dap.continue, "Start/Continue")
    map("n", "<leader>d<F10>", dap.step_over, "Step Over")
    map("n", "<leader>d<F11>", dap.step_into, "Step Into")
    map("n", "<leader>d<F12>", dap.step_out, "Step Out")
    map("n", "<leader>db", dap.toggle_breakpoint, "Toggle [B]reakpoint")
    map("n", "<leader>dc", dap.run_to_cursor, "Run to [C]ursor") -- [B]reakpoint [H]ere

    map("n", "<space>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint Condition: "))
    end, "Set [B]reakpoint [C]ondition")

    map("n", "<leader>dm", function()
      require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, "Set Breakpint [M]essage")

    map("n", "<leader>de", function()
      ---@diagnostic disable-next-line: missing-fields
      require("dapui").eval(nil, { enter = false })
    end, "[E]val Under Cursor")

    -- Load the .vscode/launch.json
    if vim.fn.filereadable(".vscode/launch.json") then
      local dap_vscode = require("dap.ext.vscode")
      dap_vscode.load_launchjs(nil, {})
    end

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup()

    require("dap-python").setup("python")

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    map("n", "<leader>d<F7>", dapui.toggle, "See last session result.")

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end,
}
