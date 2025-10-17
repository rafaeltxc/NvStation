local M = {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  opts = {
    ui = {
      auto_open = true,
      auto_close = true,
      floating = {
        border = "rounded",
        mappings = { close = { "q", "<Esc>" } },
      },
    },
  },
  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")
    local dapvt = require("nvim-dap-virtual-text")

    -- Helper function to place a sign in a safe, future-proof way
    local function place_sign(name, line, bufnr)
      vim.fn.sign_place(0, "", name, bufnr or 0, { lnum = line, priority = 10 })
    end

    -- Hook into DAP events to place/update signs
    dap.listeners.after.event_initialized["dapui_config"] = function(session, body)
      if opts.ui.auto_open then
        dapui.open()
      end

      -- Place stopped sign at current line
      local frame = session.current_frame
      if frame then
        place_sign("DapStopped", frame.line, vim.api.nvim_get_current_buf())
      end
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      if opts.ui.auto_close then
        dapui.close()
      end
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      if opts.ui.auto_close then
        dapui.close()
      end
    end

    -- Keymaps
    local map = vim.keymap.set
    local silent = { silent = true }
    map("n", "<F5>", dap.continue, silent)
    map("n", "<F10>", dap.step_over, silent)
    map("n", "<F11>", dap.step_into, silent)
    map("n", "<F12>", dap.step_out, silent)

    -- Highlights
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF0000" })
    vim.api.nvim_set_hl(0, "DapStopped", { fg = "#FFFF00" })

    -- DAP signs
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
      "DapBreakpointRejected",
      { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "➜", texthl = "DapStopped", linehl = "Visual", numhl = "" })

    -- Virtual text setup
    dapvt.setup({
      enabled = true,
      commented = false,
      virt_text_pos = "eol",
    })

    -- DAP UI setup
    dapui.setup({
      floating = opts.ui.floating,
      controls = { enabled = true, element = "repl" },
      layouts = {
        { elements = { "scopes", "breakpoints", "stacks", "watches" }, size = 0.33, position = "left" },
        { elements = { "repl", "console" },                            size = 0.27, position = "bottom" },
      },
    })

    dap.configurations.java = {
      {
        name = "Debug Launch (2GB)",
        type = "java",
        request = "launch",
        vmArgs = "" .. "-Xmx2g ",
      },
      {
        name = "Debug Attach (5005)",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 5005,
      },
      {
        name = "Debug Attach (5005 - IPV6)",
        type = "java",
        request = "attach",
        hostName = "::1",
        port = 5005,
      },
    }
  end,
}

return M
