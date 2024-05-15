vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Toggle NeoTree with leader e
vim.cmd [[nnoremap <leader>m :Neotree toggle<cr>]]

vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Close current window' })
vim.keymap.set('n', '<leader>Q', ':q!<CR>', { desc = 'Close current window and ignore save' })
vim.keymap.set('n', '<leader>cc', ':bd<CR>', { desc = 'Close current buffer' })

vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>', { desc = 'Navigate left' })
vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<CR>', { desc = 'Navigate down' })
vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<CR>', { desc = 'Navigate up' })
vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<CR>', { desc = 'Navigate right' })

-- Git remaps
vim.keymap.set('n', '<leader>gs', ':G<CR>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>ga', ':G add %<CR>', { desc = 'Git add current file' })
vim.keymap.set('n', '<leader>gA', ':G add .<CR>', { desc = 'Git add all files' })
vim.keymap.set('n', '<leader>gc', ':G commit<CR>', { desc = 'Git commit' })
-- Push to current branch
vim.keymap.set('n', '<leader>gp', ':G push origin HEAD<CR>', { desc = 'Git push' })
vim.keymap.set('n', '<leader>gd', ':G diff<CR>', { desc = 'Git diff' })
vim.keymap.set('n', '<leader>gl', ':G log<CR>', { desc = 'Git log' })
vim.keymap.set('n', '<leader>gf', ':G fetch<CR>', { desc = 'Git fetch' })
vim.keymap.set('n', '<leader>gF', ':G pull origin HEAD<CR>', { desc = 'Git pull' })
vim.keymap.set('n', '<leader>gS', ':G stash<CR>', { desc = 'Git stash' })

-- Create and checkout branch
vim.keymap.set('n', '<leader>gbn', ':G checkout -b ', { desc = 'Git create and checkout branch' })
vim.keymap.set('n', '<leader>gbc', ':G checkout ', { desc = 'Git checkout branch' })
vim.keymap.set('n', '<leader>gbl', ':G branch -l<CR>', { desc = 'Git list branches' })
vim.keymap.set('n', '<leader>gbb', ':G blame<CR>', { desc = 'Git blame' })

-- Obsidian keymaps
vim.keymap.set('n', '<leader>on', ':ObsidianNew<CR>', { desc = 'Create new note' })
vim.keymap.set('n', '<leader>oo', ':ObsidianOpen<CR>', { desc = 'Open note' })
-- Obsidian links
vim.keymap.set('n', '<leader>olf', ':ObsidianFollowLink<CR>', { desc = 'Follow obsidian link' })
vim.keymap.set('n', '<leader>olb', ':ObsidianBacklinks<CR>', { desc = 'Get references' })
vim.keymap.set('n', '<leader>or', ':ObsidianRename<CR>', { desc = 'Rename note' })
vim.keymap.set('n', '<leader>od', ':ObsidianToday<CR>', { desc = 'Open daily note' })
vim.keymap.set('n', '<leader>os', ':ObsidianSearch<CR>', { desc = 'Search note' })
vim.keymap.set('n', '<leader>ot', ':ObsidianTemplate<CR>', { desc = 'Use template' })

-- Terminal keymaps
-- Exit insert mode within Terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit insert mode within Terminal' })

-- Trouble keymaps
vim.keymap.set('n', '<leader>dt', ':TroubleToggle<CR>', { desc = 'Toggle trouble' })

-- Leap keymaps
require('leap').create_default_mappings()

require('leap').opts.special_keys.prev_target = '<bs>'
require('leap').opts.special_keys.prev_group = '<bs>'
-- require('leap').set_repeat_keys('<cr>', '<bs>')

-- Set remap to change current file to executable
vim.keymap.set('n', '<leader>cx', ':!chmod +x %<CR>', { desc = 'Make file executable' })

local rename_file = function()
  local old = vim.fn.expand '%'
  local new = vim.fn.input('New name: ', vim.fn.expand '%:t', 'file')
  vim.fn.system('mv ' .. old .. ' ' .. new)
  vim.cmd('e ' .. vim.fn.expand '%')
  vim.fn.system('rm -f ' .. old)
end

-- Create a new file in the specified path
-- It will start autocompleting the path with the current file path
local new_file = function()
  local full_path = vim.fn.expand '%:p:h'
  local new_file = vim.fn.input('New file: ', full_path, 'file')
  vim.cmd('e ' .. new_file)
end

-- rename current file
vim.keymap.set('n', '<leader>fr', function()
  rename_file()
end, { desc = 'Rename current file' })

-- create new file
vim.keymap.set('n', '<leader>fn', function()
  new_file()
end, { desc = 'Create new file' })

vim.keymap.set('n', '<leader>ww', ':w<CR>', { desc = 'Save current file' })
vim.keymap.set('n', '<leader>wq', ':wq<CR>', { desc = 'Save and close current file' })
-- source current file
vim.keymap.set('n', '<leader>fs', ':source %<CR>', { desc = 'Source current file' })

-- Workspace delete current file
-- should ask for confirmation
local delete_file = function()
  local file = vim.fn.expand '%'
  local confirm = vim.fn.input('Delete ' .. file .. '? (y/n): ')
  if confirm == 'y' then
    vim.fn.system('rm -f ' .. file)
    vim.cmd 'bd'
  end
end

vim.keymap.set('n', '<leader>fd', function()
  delete_file()
end, { desc = 'Delete current file' })

-- Move current file
local move_file = function()
  local old = vim.fn.expand '%'
  local new = vim.fn.input('Move to: ', vim.fn.expand '%:p:h', 'file')
  vim.fn.system('mv ' .. old .. ' ' .. new)
  vim.cmd('e ' .. vim.fn.expand '%')
end

vim.keymap.set('n', '<leader>fm', function()
  move_file()
end, { desc = 'Move current file' })

-- This function triggers the cht cli tool
-- It will open a terminal and ask for a cheatsheet
-- It opens on insert mode
local trigger_cheatsheet = function()
  vim.cmd 'startinsert'
  vim.cmd 'terminal cht'
end

-- Open cheatsheet cli tool terminal
-- Asks for selection
vim.keymap.set('n', '<leader>cs', trigger_cheatsheet, { desc = 'Open cheatsheet' })

vim.keymap.set('n', '<leader>j', '@q', { desc = 'Replay macro' })

-- Migrate file from commonjs to esm
local function migrateToEsm(filepath)
  print('Migrating ' .. filepath .. ' to esm')
  -- Get the output directory from filepath
  local outputdir = vim.fn.fnamemodify(filepath, ':h')
  print('Output dir: ' .. outputdir)
  vim.fn.system('to-esm ' .. filepath .. ' --output ' .. outputdir)

  print 'Opening newly created mjs file'
  vim.cmd('e ' .. vim.fn.fnamemodify(filepath, ':r') .. '.mjs')
end

local function migratoCurrentFileToEsm()
  migrateToEsm(vim.fn.expand '%')
end

-- keymap to migrate current file to esm
vim.keymap.set('n', '<leader>xm', migratoCurrentFileToEsm, { desc = 'Migrate current file to esm' })
