local ls = require 'luasnip'
-- local keymaps = require 'keymaps'

ls.setup { history = false, updateevents = 'TextChanged,TextChangedI' }

ls.filetype_extend('typescript', { 'javascript' })
ls.filetype_extend('typescriptreact', { 'typescript', 'javascript' })

require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/lua/snippets' }
