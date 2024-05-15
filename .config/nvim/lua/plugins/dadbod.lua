return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    -- vim.g.db_ui_default_query = 'select * from "{table}" limit 10'

    vim.g.db_ui_table_helpers = {
      postgresql = {
        ['List'] = 'select * from "{table}" limit 10',
      },
    }

    vim.g.db_ui_hide_schemas =
      { 'pg_catalog', 'pg_toast_temp.*', 'crdb_internal', 'information_schema', 'pg_extension' }

    vim.g.db_ui_execute_on_save = 0
  end,
  config = function()
    -- require('vim-dadbod-ui').setup()

    vim.cmd [[
      autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })

      autocmd FileType sql,mysql,plsql nmap <buffer> <leader>e :execute "normal vip\<Plug>(DBUI_ExecuteQuery)"<cr>
    ]]
  end,
}
