local get_register = function()
  local register_value = vim.fn.getreg '"'
  return register_value or "'here'"
end

return {
  s('c', fmt('console.log({})', extras.partial(get_register))),
  s('co', fmt('console.log({})', i(1))),
  s(
    'i',
    fmt([[import {} from '{}']], {
      f(function(import_name)
        local parts = vim.split(import_name[1][1], '/', true)
        return parts[#parts] or ''
      end, { 1 }),
      i(1),
    })
  ),
}
