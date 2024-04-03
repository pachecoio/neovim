return {
  {
    "github/copilot.vim",
    event = "VeryLazy",
    config = function()
      -- copilot assume mapped
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_no_tab_map = true

      -- Copilot config
      local ok, copilot = pcall(require, "copilot")
      if not ok then
        return
      end
      copilot.setup {
        suggestion = {
          keymap = {
            accept = "<c-l>",
            next = "<c-j>",
            prev = "<c-k>",
            dismiss = "<c-h>",
          },
        },
      }
      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)
    end,
  },
  {
    "hrsh7th/cmp-copilot",
    config = function()
      -- lvim.builtin.cmp.formatting.source_names["copilot"] = "( )"
      -- table.insert(lvim.builtin.cmp.sources, 2, { name = "copilot" })
    end,
  }
}
