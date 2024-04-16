return {
  {
    'felipeagc/fleet-theme-nvim',
    name = 'fleet',
  },
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    dependencies = {
      -- Set lualine as statusline
      'nvim-lualine/lualine.nvim',
      -- See `:help lualine.txt`
      opts = {
        options = {
          icons_enabled = false,
          theme = 'tokyonight',
          component_separators = '|',
          section_separators = '',
        },
      },
    },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },
  'morhetz/gruvbox',
}
