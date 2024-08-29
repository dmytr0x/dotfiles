return {
  -- Highlight, edit, and navigate code
  -- See `:help nvim-treesitter`
  --
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    -- Syntax aware text-objects, select, move, swap, and peek support.
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function(_, opts)
    require("nvim-treesitter.install").prefer_git = true

    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      -- Ensure these language parsers are installed
      ensure_installed = {
        "lua",
        "json",
        "yaml",
        "markdown",
        "python",
        "javascript",
        "typescript",
      },
      auto_install = true,

      indent = {
        enable = true,
        disable = { "ruby" },
      },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = false, -- disabled
          node_decremental = "<BS>",
        },
      },

      -- nvim-treesitter-textobjects
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["at"] = "@comment.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist

          goto_next_start = {
            ["]af"] = "@function.outer",
            ["]ac"] = "@class.outer",
          },
          goto_previous_start = {
            ["[af"] = "@function.outer",
            ["[ac"] = "@class.outer",
          },

          goto_next_end = {
            ["]aF"] = "@function.outer",
            ["]aC"] = "@class.outer",
          },
          goto_previous_end = {
            ["[aF"] = "@function.outer",
            ["[aC"] = "@class.outer",
          },

          goto_next = {
            ["]ai"] = "@conditional.outer",
            ["]ii"] = "@conditional.inner",
          },
          goto_previous = {
            ["[ai"] = "@conditional.outer",
            ["[ii"] = "@conditional.inner",
          },
        },
        swap = {
          enable = true,

          swap_next = {
            ["]ip"] = "@parameter.inner",
          },
          swap_previous = {
            ["[ip"] = "@parameter.inner",
          },
        },
      },
    })
  end,
}
