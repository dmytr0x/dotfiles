-- Bootstrap: these values must be set before loading feature modules.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.loaded_python3_provider = 0

-- Each feature owns its settings, helpers, mappings, commands, and autocmds.
require('config.editing')
require('config.search')
require('config.navigation')
require('config.explorer')
require('config.telescope')
require('config.lsp')
require('config.formatting')
require('config.reload')
require('config.appearance')
