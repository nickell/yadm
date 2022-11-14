return {
  s(
    'r',
    fmt([[local {} = require '{}']], {
      f(function(import_name)
        local parts = vim.split(import_name[1][1], '.', true)
        return parts[#parts] or ''
      end, { 1 }),
      i(1),
    })
  ),
  s(
    'lf',
    fmt(
      [[
    local {} = function()
      {}
    end
      ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  s(
    'f',
    fmt(
      [[
    function()
      {}
    end
      ]],
      {
        i(0),
      }
    )
  ),
}
