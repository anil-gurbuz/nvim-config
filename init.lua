local load = function(mod)
  package.loaded[mod] = nil
  require(mod)
end


load('keymaps')
load('options')
load('autocommands')
require('load_plugins')
require('plugin_keymaps')



