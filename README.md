# taskra.nvim

- [w] A3 test
  - [ ] A1 test sub
- [f] B2 testing
- [x] . A3 testing another one with the '.' indicating work happened
- [x] C7 and anther test

.config/nvim/lua/plugins/user.lua entry for taskra

```lua
  {
    "robertarles/taskra.nvim",
    ft = "markdown",
    lazy = true,

    -- dir = "user.plugins.taskra", -- This points to the file we created
    config = function()
      local taskra = require "taskra"
      vim.api.nvim_set_hl(0, "TaskraRed", { fg = "#FF4060" })
      vim.api.nvim_set_hl(0, "TaskraRed", { fg = "#FF4000" })
      vim.api.nvim_set_hl(0, "TaskraYellow", { fg = "#C7F000" })
      vim.api.nvim_set_hl(0, "TaskraGreen", { fg = "#008B00" })
      vim.api.nvim_set_hl(0, "TaskraBlue", { fg = "#00008B" })

      taskra.add_syntax_rule("- %[.%] [ .]*([aA])%d ", "TaskraRed")
      taskra.add_syntax_rule("- %[.%] [ .]*([bB])%d ", "TaskraYellow")
      taskra.add_syntax_rule("- %[.%] [ .]*([cCdDeEfF])%d ", "TaskraGreen")
      taskra.add_syntax_rule("- %[([^xX])%] ", "Warning")
      taskra.add_syntax_rule("- %[([xX])%] ", "Error")

      -- Add text manipulation functions
      taskra.add_text_function("upper", function()
        local line = vim.api.nvim_get_current_line()
        vim.api.nvim_set_current_line(line:upper())
      end)

      -- create a vim command
      vim.api.nvim_create_user_command("ReloadTaskra", function()
        package.loaded["taskra"] = nil
        require("taskra").setup()
        vim.cmd "bufdo e"
      end, {})

      -- Setup the plugin
      taskra.setup()
    end,
  },
```
