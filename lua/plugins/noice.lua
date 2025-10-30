local M = {
	"folke/noice.nvim",
	lazy = true,
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("notify").setup({
			timeout = 2000,
			max_height = 15,
			max_width = 80,
			render = "wrapped-compact",
			stages = "static",
		})

		require("noice").setup({
			lsp = {
				progress = {
					enabled = false,
				},
				hover = {
					enabled = false,
				},
				signature = {
					enabled = false,
				},
			},
			cmdline = {
				enabled = false, -- disable Noice commandline UI
			},
			messages = {
				enabled = false, -- disable message UI
			},
			popupmenu = {
				enabled = false, -- disable Noice popup menu
			},
			views = {
				cmdline = {
					position = {
						row = 0,
						col = "50%",
					},
					size = {
						width = 40,
					},
					border = {
						style = "rounded",
						padding = { 0, 0 },
					},
				},
			},
			presets = {
				bottom_search = false,
				command_palette = false,
				long_message_to_split = false,
				inc_rename = false,
				lsp_doc_border = false,
			},
			routes = {
				{
					filter = {
						event = "notify",
						find = "No information available",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "echo",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "",
						any = {
							{ find = "no lines in buffer" },
							{ find = "%d+ less lines" },
							{ find = "%d+ fewer lines" },
							{ find = "%d+ more lines" },
							{ find = "%d+ change;" },
							{ find = "%d+ line less;" },
							{ find = "%d+ more lines?;" },
							{ find = "%d+ fewer lines;?" },
							{ find = '".+" %d+L, %d+B' },
							{ find = "%d+ lines yanked" },
							{ find = "^Hunk %d+ of %d+$" },
							{ find = "%d+L, %d+B$" },
							{ find = "^[/?].*" },
							{ find = "%d+ changes?;" },
							{ find = "%d+ fewer lines" },
							{ find = "%d+ more lines" },
							{ find = "%d+ lines " },
							{ find = '"[^"]+" %d+L, %d+B' },

							{ find = " changes; before #" },
							{ find = " changes; after #" },
							{ find = "1 change; before #" },
							{ find = "1 change; after #" },

							{ find = " lines yanked" },

							{ find = " lines moved" },
							{ find = " lines indented" },

							{ find = " fewer lines" },
							{ find = " more lines" },
							{ find = "1 more line" },
							{ find = "1 line less" },
						},
					},
					opts = { skip = true },
				},
			},
		})

		local null_ls_token = nil
		local ltex_token = nil

		local default_handler = vim.lsp.handlers["$/progress"]

		vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
			local value = result.value
			if not value.kind then
				return
			end

			local client_id = ctx.client_id
			local name = vim.lsp.get_client_by_id(client_id).name

			if name == "null-ls" then
				if result.token == null_ls_token then
					return
				end
				if value.title == "formatting" then
					null_ls_token = result.token
					return
				end
			end

			if name == "ltex" then
				if result.token == ltex_token then
					return
				end
				if value.title == "Checking document" then
					ltex_token = result.token
					return
				end
			end

			if default_handler then
				default_handler(err, result, ctx, config)
			end
		end
	end,
}

return M
