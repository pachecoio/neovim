return {
  "vim-test/vim-test",
  lazy = false,
  config = function()
    vim.g["test#preserve_screen"] = false

    local set_test_runner = function(lang, runner)
      vim.cmd(string.format("let g:test#%s#runner = '%s'", lang, runner))
    end

    set_test_runner("javascript", "jest")
    set_test_runner("typescript", "jest")
    set_test_runner("python", "pytest")

    -- remaps
    vim.cmd([[nnoremap <leader>tt :TestNearest<cr>]])
    vim.cmd([[nnoremap <leader>tf :TestFile<cr>]])
    vim.cmd([[nnoremap <leader>tl :TestLast<cr>]])
    vim.cmd([[nnoremap <leader>ts :TestSuite<cr>]])
    vim.cmd([[nnoremap <leader>tc :TestClass<cr>]])
    vim.cmd([[nnoremap <leader>tv :TestVisit<cr>]])

    local set_reactscript_test_runner = function()
      set_test_runner("javascript", "reactscripts")
      set_test_runner("typescript", "reactscripts")
    end

    local set_jest_test_runner = function()
      set_test_runner("javascript", "jest")
      set_test_runner("typescript", "jest")
    end

    -- set map to change test runner using the utility function
    vim.keymap.set(
      "n",
      "<leader>trr",
      set_reactscript_test_runner,
      { desc = "Set reactscripts as testrunner" }
    )

    vim.keymap.set(
      "n",
      "<leader>trj",
      set_jest_test_runner,
      { desc = "Set jest as testrunner" }
    )
  end,
}
