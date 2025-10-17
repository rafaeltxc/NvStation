local M = {
	"nvim-neotest/neotest",
	event = "VeryLazy",
	lazy = true,
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",

		-- Languages
		"mfussenegger/nvim-jdtls",

		-- Adapters
    "atm1020/neotest-jdtls",
		"nvim-neotest/neotest-jest",
		"marilari88/neotest-vitest",
	},

	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jdtls"),
				require("neotest-jest")({}),
				require("neotest-vitest")({}),
			},
			floating = {
				border = "rounded",
				max_height = 0.6,
				max_width = 0.6,
				options = {},
			},
			output_panel = {
				open = "botright vsplit | vertical resize 50",
			},
		})
	end,
}

return M
