return {
  "jvgrootveld/telescope-zoxide",
  config = function()
    local map = require("core.keymap").map
    map("n", "<leader>cd", require("telescope").extensions.zoxide.list, "c[d] to directory")
  end,
}
