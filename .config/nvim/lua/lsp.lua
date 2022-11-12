local keymaps = require 'keymaps'
local lspconfig = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local ls = require 'luasnip'
local cmp = require 'cmp'

require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/lua/snippets' }
require('luasnip.loaders.from_vscode').lazy_load()

ls.setup { history = false }

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

  keymaps.lsp(bufnr, lsp_formatting)
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
    expand = function(args) ls.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-l>'] = cmp.mapping(function(fallback)
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        fallback()
      end
    end, { 'i' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif ls.jumpable(-1) then
        ls.jump(-1)
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
          diagnostics = {
            globals = { 'vim', 's', 't', 'i', 'f' },
          },
        },
      },
    }
  end,
}

local null_ls = require 'null-ls'

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.code_actions.gitsigns,
    -- null_ls.builtins.completion.spell,
  },
}
