-- Config reload
-- -------------------------------------------------------

-- Reload the active Lua init file without leaving Neovim.
local function reload_config()
    local config_path = vim.env.MYVIMRC
    if not config_path then
        vim.notify("MYVIMRC is not set", vim.log.levels.ERROR)
        return
    end
    for module in pairs(package.loaded) do
        if module:match('^config%.') then
            package.loaded[module] = nil
        end
    end
    vim.cmd("luafile " .. vim.fn.fnameescape(config_path))
end

vim.api.nvim_create_user_command("ReloadConfig", reload_config, { desc = "Reload Neovim Lua config", force = true })
vim.keymap.set("n", "<leader>R", "<cmd>ReloadConfig<CR>", { desc = "Reload Neovim config" })
