-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

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
    vim.keymap.set("n", "<leader>d<F5>", dap.continue, { desc = "Start/Continue" })
    vim.keymap.set("n", "<leader>d<F10>", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>d<F11>", dap.step_into, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>d<F12>", dap.step_out, { desc = "Step Out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle [B]reakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to [C]ursor" }) -- [B]reakpoint [H]ere

    vim.keymap.set("n", "<space>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint Condition: "))
    end, { desc = "Set [B]reakpoint [C]ondition" })

    vim.keymap.set("n", "<leader>dm", function()
      require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, { desc = "Set Breakpint [M]essage" })

    vim.keymap.set("n", "<leader>de", function()
      require("dapui").eval(nil, { enter = false })
    end, { desc = "[E]val Under Cursor" })

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
    vim.keymap.set("n", "<leader>d<F7>", dapui.toggle, { desc = "See last session result." })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end,
}
