return {
  -- { "github/copilot.vim", lazy = false },
  {
    'supermaven-inc/supermaven-nvim',
    lazy = false,
    config = function()
      require('supermaven-nvim').setup {
        keymaps = {
          accept_suggestion = '<Tab>',
          clear_suggestion = '<C-]>',
          accept_word = '<C-]>',
        },
        ignore_filetypes = { cpp = true },
        -- color = {
        -- suggestion_color = '#ffffff',
        -- cterm = 244,
        -- },
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = false, -- disables built in keymaps for more manual control
      }
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = 'claude',
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-4o', -- your desired model (or use gpt-4o, etc.)
        timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
        temperature = 0,
        max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
        --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      },
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-3-5-sonnet-20241022',
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
        disable_tools = true, -- disable tools!
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'echasnovski/mini.pick', -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
    config = function()
      require('avante').setup {
        -- system_prompt as function ensures LLM always has latest MCP server state
        -- This is evaluated for every message, even in existing chats
        system_prompt = function()
          local hub = require('mcphub').get_hub_instance()
          return hub:get_active_servers_prompt()
        end,
        -- Using function prevents requiring mcphub before it's loaded
        custom_tools = function()
          return {
            require('mcphub.extensions.avante').mcp_tool(),
          }
        end,
      }
    end,
  },
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cmd = 'MCPHub', -- lazy load by default
    build = 'npm install -g mcp-hub@latest', -- Installs globally
    config = function()
      require('mcphub').setup {
        -- Server configuration
        port = 37373, -- Port for MCP Hub Express API
        config = vim.fn.expand '~/.config/mcphub/servers.json', -- Config file path

        native_servers = {}, -- add your native servers here
        -- Extension configurations
        auto_approve = true,
        extensions = {
          avante = {},
          codecompanion = {
            show_result_in_chat = true, -- Show tool results in chat
            make_vars = true, -- Create chat variables from resources
            make_slash_commands = true, -- make /slash_commands from MCP server prompts
          },
        },

        -- UI configuration
        ui = {
          window = {
            width = 0.8, -- Window width (0-1 ratio)
            height = 0.8, -- Window height (0-1 ratio)
            border = 'rounded', -- Window border style
            relative = 'editor', -- Window positioning
            zindex = 50, -- Window stack order
          },
        },

        -- Event callbacks
        on_ready = function(hub) end, -- Called when hub is ready
        on_error = function(err) end, -- Called on errors

        -- Logging configuration
        log = {
          level = vim.log.levels.WARN, -- Minimum log level
          to_file = false, -- Enable file logging
          file_path = nil, -- Custom log file path
          prefix = 'MCPHub', -- Log message prefix
        },
      }
    end,
  },
}
