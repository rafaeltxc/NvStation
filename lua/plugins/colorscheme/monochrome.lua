local M = {
  "slugbyte/lackluster.nvim",
  lazy = false,
  priority = 1000,
  init = function()
      local lackluster = require("lackluster")

      lackluster.setup({
          tweak_syntax = {
              comment = lackluster.color.gray4,
          },
          tweak_background = {
              normal       = 'none',
              telescope    = 'none',
              menu         = lackluster.color.gray3,
              popup        = 'default',
              tabline      = 'none',
              tabline_fill = 'none',
          }
      })

      vim.cmd.colorscheme("lackluster")

      -- transparent highlights
      vim.api.nvim_set_hl(0, "TabLine", { fg = nil, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TabLineFill", { fg = nil, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#ffffff", bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLine", { fg = nil, bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { fg = nil, bg = "NONE" })
  end,
}

return M
