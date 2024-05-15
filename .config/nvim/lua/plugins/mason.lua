local opts = { noremap = true, silent = true }

local function map(mode, key, command, options)
  options = options or opts
  vim.keymap.set(mode, key, command, options)
end

local function nmap(key, command, options) map('n', key, command, options) end

local function lsp_keymaps(bufnr)
  local _opts = { noremap = true, silent = true, buffer = bufnr }
  nmap('<Leader>D', vim.lsp.buf.type_definition, _opts)
  nmap('<Leader>lca', vim.lsp.buf.code_action, _opts)
  nmap('<Leader>td', vim.lsp.buf.definition, _opts)
  nmap('<Leader>lr', vim.lsp.buf.rename, _opts)
  nmap('K', vim.lsp.buf.hover, _opts)
  nmap('gD', vim.lsp.buf.declaration, _opts)
  nmap('gi', vim.lsp.buf.implementation, _opts)
end

local function tsserver_keymaps(bufnr)
  local _opts = { noremap = true, silent = true, buffer = bufnr }
  local function code_action(action) vim.lsp.buf.code_action { context = { only = { action } }, apply = true } end
  -- nmap('<Leader>ti', function() code_action 'source.addMissingImports' end, _opts)
  nmap('<Leader>tto', function() code_action 'source.organizeImports' end, _opts)
end

return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'kevinhwang91/nvim-ufo',
  },
  config = function()
    require('mason').setup()
    local lspconfig = require 'lspconfig'
    local mason_lspconfig = require 'mason-lspconfig'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    local on_attach = function(_, bufnr) lsp_keymaps(bufnr) end

    mason_lspconfig.setup {
      ensure_installed = {
        'cssls',
        'denols',
        'dockerls',
        'eslint',
        'html',
        'jsonls',
        'marksman',
        'pyright',
        'lua_ls',
        'tailwindcss',
        'tsserver',
        'vimls',
        'yamlls',
      },
      automatic_installation = true,
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        lspconfig[server_name].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end,
      ['tsserver'] = function()
        local nvim_lsp = require 'lspconfig'

        lspconfig.tsserver.setup {
          capabilities = capabilities,
          single_file_support = false,
          root_dir = nvim_lsp.util.root_pattern 'package.json',
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            tsserver_keymaps(bufnr)
          end,
        }
      end,
      ['denols'] = function()
        local nvim_lsp = require 'lspconfig'

        lspconfig.denols.setup {
          capabilities = capabilities,
          root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc'),
          on_attach = on_attach,
        }
      end,
      ['lua_ls'] = function()
        lspconfig.lua_ls.setup {
          on_attach = on_attach,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { 'vim', 's', 't', 'i', 'f', 'fmt', 'fmta', 'rep', 'conds', 'sn', 'd', 'c', 'extras' },
              },
            },
          },
        }
      end,
    }

    require('ufo').setup()
  end,
}
