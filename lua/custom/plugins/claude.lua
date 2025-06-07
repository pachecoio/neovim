return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for git operations
  },
  config = function()
    require('claude-code').setup()

    local map = vim.keymap.set

    -- Keymaps for Claude Code
    -- leader aa toggles claude
    map('n', '<leader>aa', function()
      require('claude-code').toggle()
    end, { desc = 'Toggle Claude Code' })
  end,
}
