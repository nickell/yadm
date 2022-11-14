require 'plugins'
require 'keymaps'
require 'options'

require 'my_treesitter'
require 'my_lsp'
require 'my_telescope'
require 'my_git'

-- Git abbreviation
vim.cmd.cnoreabbrev { '<buffer>', 'G', 'Git' }
