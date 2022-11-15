--  vim: foldmethod=marker: foldlevel=0:

--  {{{ helpers
local get_commentstring = function()
  local commentstring = vim.api.nvim_buf_get_option(0, 'commentstring')
  local parts = vim.split(commentstring, '%', true)
  return parts[1] or '#'
end

local dynamic_comment = function(position)
  return d(position, function() return sn(nil, t(get_commentstring())) end, {})
end
--  }}}

return {
  s('modeline', fmt('{} vim: foldmethod=marker: foldlevel=0:', { extras.partial(get_commentstring) })),
  s(
    'fo',
    fmta(
      [[
    <> {{{ <>
    <>
    <> }}}
    ]],
      {
        dynamic_comment(1),
        i(2),
        i(0),
        rep(1),
      }
    ),
    { condition = conds.line_begin }
  ),
}
