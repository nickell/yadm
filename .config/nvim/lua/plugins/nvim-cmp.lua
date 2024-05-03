return {
  {
    'hrsh7th/nvim-cmp',
    -- load cmp on InsertEnter
    event = 'InsertEnter',
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
      },
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets', -- useful snippets
      'onsails/lspkind.nvim', -- vs-code like pictograms
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'

      require('luasnip.loaders.from_vscode').lazy_load()

      luasnip.filetype_extend('typescript', { 'javascript' })
      luasnip.filetype_extend('typescriptreact', { 'typescript', 'javascript' })

      require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/lua/snippets' }

      cmp.setup {
        completion = {
          completeopt = 'menu,menuone,preview,noselect',
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }), -- previous suggestion
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { 'i', 's' }), -- next suggestion
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-k>'] = cmp.mapping(function(fallback)
            if luasnip.expandable() then
              luasnip.expand()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
          ['<C-e>'] = cmp.mapping.abort(), -- close completion window
          ['<CR>'] = cmp.mapping.confirm { select = false },
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        formatting = {
          format = lspkind.cmp_format {
            maxwidth = 50,
            ellipsis_char = '...',
          },
        },
      }
    end,
  },
}

-- local function keymaps(cmp, ls)
--   local has_words_before = function()
--     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--     return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
--   end
--
--   local expand_or_jump = function(fallback)
--     if ls.expand_or_jumpable() then
--       ls.expand_or_jump()
--     else
--       fallback()
--     end
--   end
--
--   local cycle_completion = function(fallback)
--     if cmp.visible() then
--       cmp.select_next_item()
--     elseif has_words_before() then
--       cmp.complete()
--     else
--       fallback()
--     end
--   end
--
--   local cycle_completion_back = function(fallback)
--     if cmp.visible() then
--       cmp.select_prev_item()
--     else
--       fallback()
--     end
--   end
--
--   local luasnip_change_choice = function()
--     if ls.choice_active() then ls.change_choice(1) end
--   end
--
--   return cmp.mapping.preset.insert {
--     -- ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-k>'] = cmp.mapping(expand_or_jump, { 'i', 's' }),
--     ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
--     ['<S-Tab>'] = cmp.mapping(cycle_completion_back, { 'i', 's' }),
--     ['<Tab>'] = cmp.mapping(cycle_completion, { 'i', 's' }),
--     ['<C-l'] = cmp.mapping(luasnip_change_choice, { 'i', 's' }),
--   }
-- end
--
