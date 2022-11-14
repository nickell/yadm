-- vim: foldmethod=marker

local keymaps = require 'keymaps'
local lspconfig = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local mason_lspconfig = require 'mason-lspconfig'
local ls = require 'luasnip'
local cmp = require 'cmp'

require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/lua/snippets' }
require('luasnip.loaders.from_vscode').lazy_load()

ls.setup { history = false, updateevents = 'TextChanged,TextChangedI' }

ls.filetype_extend('typescript', { 'javascript' })
ls.filetype_extend('typescriptreact', { 'typescript', 'javascript' })

local lsp_formatting = function(bufnr, isAsync)
  vim.lsp.buf.format {
    async = isAsync,
    filter = function(client) return client.name == 'null-ls' end,
    bufnr = bufnr,
  }
end

local lspFormattingAugroup = vim.api.nvim_create_augroup('LspFormatting', {})

local on_attach = function(client, bufnr)
  if client.supports_method 'textDocument/formatting' then
    vim.api.nvim_clear_autocmds { group = lspFormattingAugroup, buffer = bufnr }
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lspFormattingAugroup,
      buffer = bufnr,
      callback = function() lsp_formatting(bufnr, false) end,
    })
  end

  keymaps.lsp(bufnr, lsp_formatting)
end

mason_lspconfig.setup {
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
    expand = function(args) ls.lsp_expand(args.body) end,
  },
  mapping = keymaps.cmp(cmp, ls),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

mason_lspconfig.setup_handlers {
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
        on_attach(client, bufnr)
        keymaps.tsserver(bufnr)
      end,
    }
  end,
  ['sumneko_lua'] = function()
    lspconfig.sumneko_lua.setup {
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = { 'vim', 's', 't', 'i', 'f' },
          },
        },
      },
    }
  end,
}
