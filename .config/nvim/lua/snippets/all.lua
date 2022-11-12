local function fn(args) return args[1][1] end

return {
  s({
    trig = 'fo',
    name = 'Fold',
  }, {
    i(1, '--'),
    t { ' {{{', '' },
    i(2),
    t { '', '' },
    f(fn, { 1 }),
    t { ' }}}' },
  }, {
    line_to_cursor = '',
  }),
}

-- {{{

-- }}}
--
-- {{{

-- }}}
