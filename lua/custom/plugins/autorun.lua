local _state = {
  buffer_number = nil,
  cmd = 'go test -json ./...',
  ns = vim.api.nvim_create_namespace 'autorun',
}

local group = vim.api.nvim_create_augroup('autorun', { clear = true })

local function make_key(entry)
  assert(entry.Package, 'Must have package' .. vim.inspect(entry))
  assert(entry.Test, 'Must have test' .. vim.inspect(entry))
  return string.format('%s/%s', entry.Package, entry.Test)
end

local function find_test_line(entry)
  print 'test line'
  local line = entry.Line
  if not line then
    return 0
  end
  return line - 1
end

local function add_golang_test(state, entry)
  state.tests[make_key(entry)] = {
    name = entry.Test,
    line = find_test_line(entry),
    output = {},
  }
end

local function add_golang_test_output(state, entry)
  local key = make_key(entry)
  local test = state.tests[key]
  if not test then
    return
  end
  table.insert(test.output, entry.Output)
end

local function mark_success(state, entry)
  local key = make_key(entry)
  local test = state.tests[key]
  if not test then
    return
  end
  test.success = entry.Action == 'pass'
end

local function run_job(buffer_number, command)
  if not command then
    return
  end
  local append_data = function(_, data)
    if not data then
      return
    end
    -- vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)

    -- transform json
    for _, line in ipairs(data) do
      local decoded = vim.json.decode(line)
      if decoded == nil then
        return
      end
      if decoded.Action == 'run' then
        add_golang_test(_state, decoded)
      elseif decoded.Action == 'output' then
        if not decoded.Test then
          return
        end

        add_golang_test_output(_state, decoded)
      elseif decoded.Action == 'pass' or decoded.Action == 'fail' then
        mark_success(_state, decoded)
        local test = _state.tests[decoded.Test]
        if test.success then
          local text = { 'Success', '✅' }
          vim.api.nvim_buf_set_extmark(buffer_number, _state.ns, test.line, 0, {
            virt_text = { text },
          })
        end
      elseif decoded.Action == 'pause' or decoded.Action == 'cont' then
        print 'do nothing'
      else
        print 'Unknown action'
        print(vim.inspect(decoded))
      end
    end
  end

  -- vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, {
  --   'Output: ',
  -- })

  vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = append_data,
    on_exit = function()
      local failed = {}
      for _, test in pairs(_state.tests) do
        if test.line then
          if not test.success then
            table.insert(failed, {
              bufnr = buffer_number,
              lnum = test.line,
              col = 0,
              severity = vim.diagnostic.severity.ERROR,
              source = 'autorun',
              message = 'Failed: ' .. test.name,
              user_data = {},
            })
          end
        end
      end
      vim.diagnostic.set(_state.ns, buffer_number, failed, {})
    end,
  })
end

local attach_to_buffer = function(output_bufnr, pattern, command)
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = pattern,
    callback = function()
      run_job(output_bufnr, command)
    end,
  })
end

local function create_buf()
  if not _state.buffer_number then
    vim.api.nvim_command 'vnew'
    _state.buffer_number = vim.api.nvim_get_current_buf()
    vim.api.nvim_command 'wincmd p'
  end

  -- check if buffer is opened
  local is_opened = false
  if vim.api.nvim_buf_is_valid(_state.buffer_number) then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf == _state.buffer_number then
        is_opened = true
        break
      end
    end
  end
  if not is_opened then
    _state.buffer_number = nil
    create_buf()
    return
  end
end

local function configure_cmd()
  _state.cmd = vim.fn.input 'Command: '
  create_buf()
  local pattern = '*.go'
  attach_to_buffer(_state.buffer_number, pattern, _state.cmd)
end

local function trigger_run()
  if not _state.cmd then
    print 'Command is not configured'
    return
  end
  run_job(_state.buffer_number, _state.cmd)
end

vim.api.nvim_create_user_command('AutoRun', function()
  configure_cmd()
  trigger_run()
end, {})

vim.api.nvim_create_user_command('AutoRunShow', function()
  -- open buffer if not opened
  if not _state.buffer_number then
    create_buf()
  end
  -- show buffer on split vertical
  vim.api.nvim_command('vertical sb ' .. _state.buffer_number)
end, {})

vim.api.nvim_create_user_command('GoTest', function()
  _state.buffer_number = vim.api.nvim_get_current_buf()
  attach_to_buffer(_state.buffer_number, '*.go', 'go test -json ./...')
  if not _state.cmd then
    print 'Command is not configured'
    return
  end
  run_job(_state.buffer_number, _state.cmd)
end, {})

return {}
