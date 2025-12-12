--[[return {
	"junegunn/fzf.vim",
	dependencies = { "junegunn/fzf" },
	lazy = false, -- Load lazily
	-- check https://github.com/junegunn/fzf.vim
	cmd = { "FZF", "FZFPreview", "FZFPreviewFile", "FZFPreviewBuffer", "FZFPreviewGrep" },
}]]

return {
	"ibhagwan/fzf-lua",
	lazy = false,
	--[[	init = function()
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.select = function(...)
			require("fzf-lua").register_ui_select()
			vim.ui.select(...)
		end
	end,]]
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	opts = {},
	config = function(_, opts)
		require("fzf-lua").setup(opts)
		require("fzf-lua").register_ui_select()
	end,
}
