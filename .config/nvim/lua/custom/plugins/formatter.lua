return {
  -- Autoformat
  "stevearc/conform.nvim",
  lazy = false,
  config = function()
    require("conform").setup({
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = {
          c = true,
          cpp = true,
        }

        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        -- Conform can also run multiple formatters sequentially
        --
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
      },
      formatters = {
        stylua = {
          prepend_args = { "--indent-type=Spaces", "--indent-width=2" },
        },
      },
    })

    --
    local map = require("core.keymap").map

    map({ "n", "v" }, "<leader>cf", function()
      require("conform").format({ async = true, lsp_fallback = true })
    end, "[F]ormat")

    -- Auto fix all on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
      command = "silent! EslintFixAll",
      group = vim.api.nvim_create_augroup("MyAutocmdsJSTSFormatting", {}),
    })
  end,
}
