return {
  {
    'akinsho/nvim-toggleterm.lua',
    lazy = false,
    config = function()
      require('toggleterm').setup {
        size = 20,
        open_mapping = [[<c-\>]],
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 1,
        start_in_insert = true,
        persist_size = true,
        direction = 'horizontal',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 3,
          highlights = {
            border = 'normal',
          },
        },
      }
      vim.keymap.set('n', '<leader>;', ':ToggleTerm<cr>', { desc = 'Toggle terminal new tab' })
    end,
  },
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
  },
}
