return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'tomasiser/vim-code-dark',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  -- opts = {
  --   transparent = true,
  --   styles = {
  --     sidebars = 'transparent',
  --     floats = 'transparent',
  --   },
  -- },
  config = function()
    vim.g.codedark_transparent = 1
    -- vim.g.codedark_conservative = 1

    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme 'codedark'

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
}
