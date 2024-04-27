
local plugin = {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {"nvim-tree/nvim-web-devicons"},
  config = function()
    require("nvim-tree").setup({})

    vim.keymap.set('n', '<leader>lt',':NvimTreeToggle<cr>', { desc = '[L]ayout toggle [T]ree' })

  end
}

return plugin
