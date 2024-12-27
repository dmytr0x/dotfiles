return {
  -- LSP Configuration & Plugins

  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- Useful status updates for LSP.
    { "j-hui/fidget.nvim", opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`

    local keymap = require("core.keymap")

    --  This function gets run when an LSP attaches to a particular buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        function map(modes, keys, func, desc)
          keymap.map(modes, keys, func, "LSP: " .. desc, {
            buffer = event.buf,
          })
        end

        -- Jump to the definition of the word under your cursor.
        --  To jump back, press <C-t>.
        map("n", "gd", function()
          require("telescope.builtin").lsp_definitions({
            layout_strategy = "vertical",
          })
        end, "Goto [D]efinition")

        -- Jump to the definition of the word under your cursor
        -- in a separate window with a view which has been centred
        map("n", "gh", function()
          vim.cmd("split")
          require("telescope.builtin").lsp_definitions({
            layout_strategy = "vertical",
          })
          vim.cmd.normal("zz")
        end, "Goto [D]efinition Split")

        map("n", "gD", vim.lsp.buf.declaration, "Goto [D]eclaration")

        -- Find references for the word under your cursor.
        map("n", "gf", function()
          require("telescope.builtin").lsp_references({
            layout_strategy = "vertical",
          })
        end, "Goto Re[f]erences")

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map("n", "gi", function()
          require("telescope.builtin").lsp_implementations({
            layout_strategy = "vertical",
          })
        end, "Goto [I]mplementation")

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map("n", "gt", function()
          require("telescope.builtin").lsp_type_definitions({
            layout_strategy = "vertical",
          })
        end, "Goto [T]ype Definition")

        -- Fuzzy find all the symbols in your current document.
        map("n", "gs", function()
          require("telescope.builtin").lsp_document_symbols({
            layout_strategy = "vertical",
          })
        end, "Document [S]ymbols")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map("n", "gS", function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            layout_strategy = "vertical",
          })
        end, "Workspace [S]ymbols")

        -- Rename the variable under your cursor.
        map("n", "<leader>cr", vim.lsp.buf.rename, "[R]ename")

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map("n", "<leader>ca", vim.lsp.buf.code_action, "[A]ction")

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        map("n", "K", vim.lsp.buf.hover, "Hover Do[c]umentation")

        -- Change the Diagnostic symbols in the sign column (gutter)
        local signs = {
          Error = "e",
          Warn = "!",
          Hint = "?",
          Info = "i",
        }
        for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
          })
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs

      -- rust_analyzer = {},
      -- gopls = {},

      --> python <--
      pyright = {},
      ruff = {},
      ruff_lsp = {},

      --> ... <--
      bashls = {},
      jsonls = {},
      markdownlint = {},
      html = {},
      dockerls = {},

      -- javascript / typescript
      denols = {},
      ts_ls = {
        init_options = {
          preferences = {
            -- disableSuggestions = true,
            -- Enable inlay hints
            includeInlayParameterNameHints = "literals",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        on_init = function(client)
          -- Disable formatting
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentFormattingRangeProvider = false
        end,
      },
      ["eslint-lsp"] = {},
      prettierd = {},

      -- CSS
      ["tailwindcss-language-server"] = {},

      -- Lua
      stylua = {}, -- Used to format Lua code
      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },

      --
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require("mason").setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
