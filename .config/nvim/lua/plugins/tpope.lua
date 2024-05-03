return {
  {
    'tpope/vim-unimpaired',
    config = function()
      vim.cmd [[
    unmap =s
    unmap =s<Esc>
    unmap =p
    unmap =P
    ]]
    end,
  },
  'tpope/vim-sensible',
  'tpope/vim-abolish',
  {
    'tpope/vim-projectionist',
    init = function()
      vim.cmd [[
    let g:projectionist_heuristics = {
          \ "package.json": {
          \   "app/*.tsx": {"type": "source","alternate": "app/{}.test.tsx"},
          \   "app/*.test.tsx": {"type": "test","alternate": "app/{}.tsx"},
          \   "app/*.ts": {"type": "source","alternate": "app/{}.test.ts"},
          \   "app/*.test.ts": {"type": "test","alternate": "app/{}.ts"}
          \ }}
    ]]
    end,
  },
}
