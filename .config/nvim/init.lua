require 'plugins'
require 'keymaps'
require 'options'

require 'treesitter'
require 'lsp'
require 'mytelescope'
require 'git'

require('bufferline').setup {}
require('Navigator').setup {}
require('onedark').setup { style = 'deep' }
require('onedark').load()

-- Git abbreviation
vim.cmd.cnoreabbrev { '<buffer>', 'G', 'Git' }
