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
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	opts = {},
}
