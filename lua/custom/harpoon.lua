local harpoon = require 'harpoon'

-- REQUIRED
harpoon:setup {}
-- REQUIRED

vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end)
-- vim.keymap.set('n', '<leader>e', function()
--   harpoon.ui:toggle_quick_menu(harpoon:list())
-- end)

vim.keymap.set('n', '<leader>1', function()
  harpoon:list():select(1)
end)
vim.keymap.set('n', '<leader>2', function()
  harpoon:list():select(2)
end)
vim.keymap.set('n', '<leader>3', function()
  harpoon:list():select(3)
end)
vim.keymap.set('n', '<leader>4', function()
  harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set('n', '<S-h>', function()
  harpoon:list():prev()
end)
vim.keymap.set('n', '<S-l>', function()
  harpoon:list():next()
end)

-- basic telescope configuration
local conf = require('telescope.config').values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
      attach_mappings = function(_, map)
        map('i', '<c-d>', function(prompt_bufnr)
          local selection = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
          harpoon:list():remove_at(selection.index)
          print('Deleted ' .. selection.value)
        end)
        return true
      end,
    })
    :find()
end

vim.keymap.set('n', '<leader>e', function()
  toggle_telescope(harpoon:list())
end, { desc = 'Open harpoon window' })
