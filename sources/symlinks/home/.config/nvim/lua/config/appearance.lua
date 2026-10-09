local group = vim.api.nvim_create_augroup('config_appearance', { clear = true })

-- Appearance and status line
-- -------------------------------------------------------

-- Enable 24-bit color support in compatible terminals.
vim.opt.termguicolors = true

-- Show the sign column consistently to avoid text shifting when signs appear.
vim.opt.signcolumn = "yes"

-- Keep the command line hidden except when needed.
vim.opt.cmdheight = 0

-- Use one status line for all splits.
vim.opt.laststatus = 3

vim.o.showmode = false

local base = "#101018"
local modes = {
  n = { "NORMAL",  "#efc5c5" },
  i = { "INSERT",  "#a6d9e4" },
  v = { "VISUAL",  "#e8cf91" },
  V = { "VISUAL",  "#e8cf91" },
  ["\22"] = { "VISUAL", "#e8cf91" }, -- Ctrl-V
  R = { "REPLACE", "#e49a9a" },
  c = { "COMMAND", "#a8d5aa" },
  t = { "TERMINAL", "#c8b6e8" },
}

local function current_mode()
  return modes[vim.fn.mode(1):sub(1, 1)] or modes.n
end

local function update_colors()
  local color = current_mode()[2]
  vim.api.nvim_set_hl(0, "StatusLine", { fg = "#d9d9e8", bg = base })
  vim.api.nvim_set_hl(0, "ModeBadge", { fg = base, bg = color, bold = true })
  vim.api.nvim_set_hl(0, "ModeEdge", { fg = color, bg = base })
  vim.cmd("redrawstatus")
end

local function mode_statusline()
  return "%#ModeBadge# " .. current_mode()[1]
    .. " %#ModeEdge#%#StatusLine# %f%m%=%l:%c "
end

_G.ModeStatusline = mode_statusline
vim.o.statusline = "%!v:lua.ModeStatusline()"
vim.api.nvim_create_autocmd({ "ModeChanged", "ColorScheme" }, { group = group, callback = update_colors })
update_colors()

-- Load the colorscheme last so a theme error cannot interrupt the other features.
vim.cmd.colorscheme('dmytr0x-dark-modern')
