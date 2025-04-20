return {

	-- bufferline
	{
		"akinsho/bufferline.nvim",
		-- enabled = false,
		event = "VeryLazy",
		dependencies = {
			{
				"nvim-tree/nvim-web-devicons",
				lazy = true,
			},
		},
		opts = {
			options = {
				always_show_bufferline = false,
				mode = "buffers",
				buffer_close_icon = require("core.ui.icons").bufferline.close_buffer,
				modified_icon = require("core.ui.icons").bufferline.modified_icon,
				close_icon = require("core.ui.icons").bufferline.close,
				max_name_length = 14,
				max_prefix_length = 13,
				tab_size = 20,
				separator_style = { "", "" },
				diagnostics = false,
				offsets = {
					{
						filetype = "NvimTree",
						text = "NvimTree",
						highlight = "Directory",
						text_align = "left",
						padding = 1,
					},
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
						padding = 1,
					},
					{
						filetype = "Outline",
						text = "Outline",
						-- highlight = "Directory",
						-- text_align = "left",
						padding = 1,
					},
				},
				indicator = {
					style = "none",
				},
			},
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
			vim.opt.termguicolors = true
		end,
		keys = function()
			require("core.mappings").bufferline()
		end,
	},

	-- lualine
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			{
				"nvim-tree/nvim-web-devicons",
				lazy = true,
			},
		},
		opts = function()
			-- return require("plugins.configs.lualine")
			return require("plugins.configs.lualine_minimal")
		end,
	},

	-- colorizer
	{
		"NvChad/nvim-colorizer.lua",
		lazy = true,
		name = "colorizer",
		event = { "BufRead", "BufWinEnter", "BufNewFile" },
		opts = {
			filetypes = { "*" },
			user_default_options = {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = false, -- "Name" codes like Blue
				RRGGBBAA = false, -- #RRGGBBAA hex codes
				rgb_fn = false, -- CSS rgb() and rgba() functions
				hsl_fn = false, -- CSS hsl() and hsla() functions
				css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				mode = "background", -- Set the display mode.
			},
		},
		config = function(_, opts)
			require("colorizer").setup(opts)
			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
		end,
	},

	-- indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		lazy = true,
		dependencies = {
			{ "MunifTanjim/nui.nvim", lazy = true },
		},
		event = { "BufRead", "BufWinEnter", "BufNewFile" },
		opts = {
			-- char = "|"
			enabled = true,
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"Lazy",
					"terminal",
					"lspinfo",
					"TelescopePrompt",
					"TelescopeResults",
					"mason",
				},
				buftypes = { "terminal" },
			},
			whitespace = {
				remove_blankline_trail = false,
			},
			-- scope = {
			--   enabled = false,
			--   show_start = true,
			--   show_exact_scope = true,
			-- },
		},
		keys = function()
			require("core.mappings").blankline()
		end,
	},

	-- active indent guide and indent text objects
	-- {
	--   "echasnovski/mini.indentscope",
	--   version = false, -- wait till new 0.7.0 release to put it back on semver
	--   event = { "BufReadPre", "BufNewFile" },
	--   opts = {
	--     -- symbol = "▏",
	--     symbol = "│",
	--     options = { try_as_border = true },
	--   },
	--   init = function()
	--     vim.api.nvim_create_autocmd("FileType", {
	--       pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
	--       callback = function()
	--         vim.b.miniindentscope_disable = true
	--       end,
	--     })
	--   end,
	--   config = function(_, opts)
	--     require("mini.indentscope").setup(opts)
	--   end,
	-- },

	-- noicer ui (fancy)
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				keys = {
					{
						"<leader>un",
						function()
							require("notify").dismiss({ silent = true, pending = true })
						end,
						desc = "Delete all Notifications",
					},
				},
				opts = {
					fps = 60,
					timeout = 3000,
					max_height = function()
						return math.floor(vim.o.lines * 0.75)
					end,
					max_width = function()
						return math.floor(vim.o.columns * 0.75)
					end,
				},
			},
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>unl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>unh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>una", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
	},

	-- alpha
	{
		"goolord/alpha-nvim",
		-- nvchad
		config = function()
			require("plugins.configs.alpha")
		end,
	},

	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- better vim.ui
	-- {
	--   "stevearc/dressing.nvim",
	--   lazy = true,
	--   init = function()
	--     ---@diagnostic disable-next-line: duplicate-set-field
	--     vim.ui.select = function(...)
	--       require("lazy").load({ plugins = { "dressing.nvim" } })
	--       return vim.ui.select(...)
	--     end
	--     ---@diagnostic disable-next-line: duplicate-set-field
	--     vim.ui.input = function(...)
	--       require("lazy").load({ plugins = { "dressing.nvim" } })
	--       return vim.ui.input(...)
	--     end
	--   end,
	-- },
}
