return {
	{
		"uhs-robert/oasis.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("oasis").setup({
				style = "starlight",
			})
			vim.o.background = "dark"
			vim.cmd.colorscheme("oasis")
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "oasis",
		},
	},
}
