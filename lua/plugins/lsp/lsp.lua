local ensure_installed = require("utils.mason-ensure-installed")

local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Config
    "mason-org/mason.nvim",
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = ensure_installed.lsp,
        automatic_installation = true,
      },
      config = function(_, opts)
        local msn = require("mason-lspconfig")
        msn.setup(opts)
      end,
    },

    -- Languages
    "mfussenegger/nvim-jdtls",
  },
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = true,
      virtual_text = false,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      severity_sort = true,
    },
    inlay_hints = {
      enabled = true,
    },
    icons = {
      error = " ",
      warn = " ",
      info = " ",
      hint = "󰌵",
    },
  },

  config = function(_, opts)
    local mason_registry = require("mason-registry")

    -- Mason plugins manual ensure installed
    for _, name in ipairs(ensure_installed.plugins) do
      local pkg = mason_registry.get_package(name)
      if not pkg:is_installed() then
        pkg:install()
      end
    end

    -- Borders
    pcall(function()
      require("lspconfig.ui.windows").default_options.border = "rounded"
    end)

    -- Diagnostic signs
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = opts.icons.error,
          [vim.diagnostic.severity.WARN] = opts.icons.warn,
          [vim.diagnostic.severity.INFO] = opts.icons.info,
          [vim.diagnostic.severity.HINT] = opts.icons.hint,
        },
        texthl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
      },
    })

    -- Diagnostic text colors
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#a3333a", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#d1ab69", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#47a4a6", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#47a4a6", bg = "NONE" })

    -- Diagnostic config
    if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
      opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and ""
          or function(diagnostic)
            for d, icon in pairs(opts.icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
    end
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    -- Capabilities
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      opts.capabilities or {}
    )

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"

      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    -- Handlers
    local handlers = {}

    local servers = ensure_installed.lsp

    if #servers > 0 then
      for _, server in ipairs(servers) do
        local ok, custom_opts = pcall(require, "plugins.lsp.settings." .. server)
        local server_opts = vim.tbl_deep_extend(
          "force",
          { handlers = handlers, capabilities = vim.deepcopy(capabilities) },
          ok and custom_opts or {}
        )

        vim.lsp.config[server] = server_opts
        vim.lsp.enable(vim.lsp.config[server])
      end
    end
  end,
}

return M
