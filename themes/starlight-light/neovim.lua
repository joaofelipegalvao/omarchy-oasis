return {
	{
		"uhs-robert/oasis.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("oasis").setup({
				style = "starlight",
				light_style = "starlight",
				light_intensity = 1,
			})

			vim.o.background = "light"
		end,
	},

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "oasis",
		},
	},
}
