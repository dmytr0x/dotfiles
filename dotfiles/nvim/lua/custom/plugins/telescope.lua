return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- Live grep with args
    { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.1.0" },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons" },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require("telescope").setup({
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      defaults = {
        file_ignore_patterns = {
          "node_modules",
        },
        mappings = {
          i = { ["<c-f>"] = "to_fuzzy_refine" },
        },
        -- new defaults
        layout_strategy = "bottom_pane",
        layout_config = {
          prompt_position = "top",
          center = {
            mirror = true,
          },
          horizontal = {
            anchor = "NE",
            height = 0.99,
            width = 0.66,
            preview_width = 0.55,
          },
          vertical = {
            anchor = "NE",
            width = 0.95,
            height = 0.95,
            preview_cutoff = 4,
            preview_height = 0.45,
            mirror = true,
          },
        },
      },
      pickers = {
        -- layout strategy = vertical
        live_grep = {
          layout_strategy = "vertical",
        },
        grep_string = {
          layout_strategy = "vertical",
        },
        diagnostics = {
          layout_strategy = "vertical",
        },
        find_files = {
          layout_strategy = "vertical",
          -- find_command = { 'fd', '--exclude', '.git/' },
          -- follow = true,
          -- hidden = true,
          -- no_ignore = false,
        },
        help_tags = {
          layout_strategy = "vertical",
        },
        oldfiles = {
          layout_strategy = "vertical",
          previewer = false,
        },
        git_branches = {
          layout_strategy = "vertical",
        },
        lsp_declarations = {
          layout_strategy = "vertical",
        },
        lsp_definitions = {
          layout_strategy = "vertical",
        },
        lsp_implementations = {
          layout_strategy = "vertical",
        },
        lsp_references = {
          layout_strategy = "vertical",
        },
        -- theme = dropdown
        builtin = {
          theme = "dropdown",
          previewer = false,
        },
        colorscheme = {
          theme = "dropdown",
          enable_preview = true,
        },
        filetypes = {
          theme = "dropdown",
        },
        -- theme cursor
        spell_suggest = {
          theme = "cursor",
          layout_config = {
            height = 14,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "live_grep_args")
    pcall(require("telescope").load_extension, "zoxide")

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[H]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[K]eymaps" })
    vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "[M]arks" })
    vim.keymap.set("n", "<leader>sf", function()
      builtin.find_files({ hidden = true })
    end, { desc = "[F]iles" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Select Tele[s]cope" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Current [W]ord" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[R]esume Picker" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "Recent Files" })
    vim.keymap.set("n", "z=", builtin.spell_suggest, { desc = "Spell Suggestions" })

    vim.keymap.set("n", "<leader>sb", function()
      builtin.buffers({ layout_strategy = "vertical" })
    end, { desc = "Find buffer" })

    -- vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[G]rep" })
    vim.keymap.set("n", "<leader>sg", function()
      require("telescope").extensions.live_grep_args.live_grep_args({ layout_strategy = "vertical" })
    end, { desc = "Live [G]rep" })

    -- Slightly advanced example of overriding default behaviour and theme
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find({
        layout_strategy = "vertical",
        previewer = true,
      })
    end, { desc = "Search In Buffer" })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "In Open Files" })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "In [N]eovim files" })
  end,
}
