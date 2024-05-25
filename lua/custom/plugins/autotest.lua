local namespace = vim.api.nvim_create_namespace 'autotest'
-- local bufnr = 4

-- vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

local function mark_success(buf, ns, line)
  vim.api.nvim_buf_set_extmark(buf, ns, line, -1, {
    virt_text = { { ' --  Pass', 'DiagnosticOk' } },
    virt_text_pos = 'overlay',
    hl_group = 'AutoTestSuccess',
  })
end

local function mark_fail(buf, ns, line)
  vim.api.nvim_buf_set_extmark(buf, ns, line, -1, {
    virt_text = { { '--  Failed', 'DiagnosticError' } },
    virt_text_pos = 'overlay',
    hl_group = 'AutoTestFail',
  })
end

local function make_key(entry)
  assert(entry.Package, 'Must have package' .. vim.inspect(entry))
  assert(entry.Test, 'Must have test' .. vim.inspect(entry))
  return string.format('%s/%s', entry.Package, entry.Test)
end

local function find_test_line(entry)
  return 0
end

local function add_golang_test(state, entry)
  state.tests[make_key(entry)] = {
    name = entry.Test,
    line = find_test_line(entry),
    output = {},
  }
  return state
end

local function add_golang_test_output(state, entry)
  local key = make_key(entry)
  local test = state.tests[key]
  if not test then
    return state
  end
  table.insert(test.output, entry.Output)
  return state
end

local function get_handlers()
  return {
    ['start'] = function(state, _)
      print 'start test'
      return state
    end,
    ['output'] = add_golang_test_output,
    ['run'] = add_golang_test,
  }
end

local function run_tests(bufnr, path)
  vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
  local _state = {
    tests = {},
  }

  vim.fn.jobstart('go test ' .. path .. '/... -json', {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then
        return
      end

      for _, line in ipairs(data) do
        local decoded = vim.json.decode(line)
        if decoded == nil then
          return
        end
        local handlers = get_handlers()
        if not decoded.Action then
          return
        end
        local handler = handlers[decoded.Action]
        if handler then
          _state = handler(_state, decoded)
          print('decoded' .. vim.inspect(decoded))
        end
      end
    end,
    on_exit = function()
      local failed = {}
      for _, test in pairs(_state.tests) do
        if test.line then
          if not test.success then
            table.insert(failed, {
              bufnr = bufnr,
              lnum = test.line,
              col = 0,
              severity = vim.diagnostic.severity.ERROR,
              source = 'autotest',
              message = 'Failed: ' .. test.name,
              user_data = {},
            })
          end
        end
      end
      vim.diagnostic.set(_state.ns, bufnr, failed, {})
    end,
  })
end

vim.api.nvim_create_user_command('GoTest', function()
  local bufnr = vim.api.nvim_get_current_buf()
  run_tests(bufnr, vim.fn.expand '%:p:h')
end, {})

return {}
