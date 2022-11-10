local keymaps = require 'keymaps'
local lspconfig = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local luasnip = require 'luasnip'
local cmp = require 'cmp'

local lsp_formatting = function(bufnr, isAsync)
  vim.lsp.buf.format {
    async = isAsync,
    filter = function(client) return client.name == 'null-ls' end,
    bufnr = bufnr,
  }
end

local lspFormattingAugroup = vim.api.nvim_create_augroup('LspFormatting', {})

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.supports_method 'textDocument/formatting' then
    vim.api.nvim_clear_autocmds { group = lspFormattingAugroup, buffer = bufnr }
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lspFormattingAugroup,
      buffer = bufnr,
      callback = function() lsp_formatting(bufnr, false) end,
    })
  end

  keymaps.lsp({ noremap = true, silent = true, buffer = bufnr }, lsp_formatting)
end

require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = {
    'cssls',
    'dockerls',
    'eslint',
    'html',
    'jsonls',
    'pyright',
    'sumneko_lua',
    'tailwindcss',
    'tsserver',
    'vimls',
    'yamlls',
  },
  automatic_installation = true,
}

cmp.setup {
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

require('mason-lspconfig').setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name)
    lspconfig[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ['tsserver'] = function()
    lspconfig.tsserver.setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        on_attach(client, bufnr)

        keymaps.tsserver(bufopts)
      end,
    }
  end,
  ['sumneko_lua'] = function()
    lspconfig.sumneko_lua.setup {
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    }
  end,
}
