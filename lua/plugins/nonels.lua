local M = {
	"nvimtools/none-ls.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvimtools/none-ls-extras.nvim",
	},

	config = function()
		local null = require("null-ls")
		local formatting = null.builtins.formatting
		local diagnostics = null.builtins.diagnostics

		null.setup({
			border = "rounded",
			debug = true,
			sources = {
				-- https://github.com/nvimtools/none-ls-extras.nvim/tree/main/lua/none-ls/diagnostics
				-- https://github.com/nvimtools/none-ls-extras.nvim/tree/main/lua/none-ls/formatting
				require("none-ls.formatting.eslint"),
				require("none-ls.diagnostics.eslint"),
				require("none-ls.formatting.jq"),
				require("none-ls.formatting.rustfmt"),

				formatting.shfmt,
				formatting.stylua,
				formatting.djlint,
				formatting.google_java_format,
				formatting.sql_formatter,
				formatting.yamlfmt,
				formatting.prettierd,
			},
		})
	end,
}

return M
