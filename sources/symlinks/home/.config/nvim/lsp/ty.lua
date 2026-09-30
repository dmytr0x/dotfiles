---@type vim.lsp.Config
return {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = { { 'pyproject.toml', 'ty.toml', 'setup.py', 'poetry.lock' }, '.git' },
  -- Only open trusted workspaces with uv integration enabled.
  init_options = {
    experimental = { useUv = 'on' },
  },
  settings = {
    ty = {
      completions = { completeFunctionParentheses = true },
    },
  },
}
