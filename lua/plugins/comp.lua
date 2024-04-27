local plugin = {'hrsh7th/nvim-cmp'}

plugin.event = 'InsertEnter'



plugin.dependencies = { 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path', }

local extra_dep = {'L3MON4D3/LuaSnip'}
function extra_dep.build()
  if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
    return
  end
  return 'make install_jsregexp'
end

table.insert(plugin.dependencies, extra_dep)


function plugin.config()
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
  luasnip.config.setup {}

  local setup_args = {}

  -- cmp.setup = {}
  setup_args.snippet = {}
  function setup_args.snippet.expand(args)
    luasnip.lsp_expand(args.body)
  end

  setup_args.completion = { completeopt = 'menu,menuone,noinsert' }

  local keymaps = {
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
    ['<C-p>'] = cmp.mapping.complete {},
  }

  setup_args.mapping = cmp.mapping.preset.insert(keymaps)
  setup_args.sources = {{name = 'nvim_lsp'}, {name = 'path'}, { name = 'luasnip' } }
  cmp.setup(setup_args)

end

return plugin

