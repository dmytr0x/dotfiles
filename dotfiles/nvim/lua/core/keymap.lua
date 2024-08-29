local core = {}

local default_keymap_options = {
  noremap = true,
  silent = true,
}

function core.map(modes, keys, func, description, options)
  opt = vim.tbl_deep_extend("force", default_keymap_options, options or {})
  opt.desc = description
  vim.keymap.set(modes, keys, func, opt)
end

return core
