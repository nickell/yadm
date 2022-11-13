require 'plugins'
require 'keymaps'
require 'options'

require 'treesitter'
require 'lsp'
require 'mytelescope'
require 'git'

-- Git abbreviation
vim.cmd.cnoreabbrev { '<buffer>', 'G', 'Git' }
