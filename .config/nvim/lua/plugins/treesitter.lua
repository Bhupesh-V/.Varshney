return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	priority = 100,
	build = ":TSUpdate",
	config = function()
		local parsers = {
			"bash",
			"comment",
			"css",
			"diff",
			"dockerfile",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"go",
			"gomod",
			"gosum",
			"hcl",
			"html",
			"javascript",
			"jinja",
			"jsdoc",
			"json",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"mermaid",
			"python",
			"regex",
			"rst",
			"scss",
			"terraform",
			"toml",
			"typescript",
			"yaml",
			"vim",
			"vimdoc",
		}

		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
