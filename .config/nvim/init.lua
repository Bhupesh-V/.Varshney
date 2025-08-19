-- ├── init.lua
-- ├── lazy-lock.json
-- └── lua
--     ├── autocmds.lua
--     ├── keymaps.lua
--     ├── options.lua
--     └── plugins
--         ├── colorscheme.lua
--         ├── conform.lua
--         ├── devicons.lua
--         ├── filetree.lua
--         ├── floatterm.lua
--         ├── gitsigns.lua
--         ├── lualine.lua
--         ├── neoscroll.lua
--         ├── surround.lua
--         ├── telescope.lua
--         ├── treesitter.lua
--         └── zen.lua
-- Original Vimscript Config: https://github.com/Bhupesh-V/.Varshney/blob/master/init.vim
-- References from: https://github.com/Jarmos-san/dotfiles

-- TODO
-- 1. Debugging for Typescript and Go
-- 2. Formatters

-- Path to install "lazy.nvim" at
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo(
			{ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" }, { "\nPress any key to exit..." } },
			true,
			{}
		)
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Update the Neovim runtimepath for "lazy.nvim" to source the plugins.
vim.opt.rtp:prepend(lazypath)

-- Map the <Leader> key to <Space>.
vim.g.mapleader = " "

-- Disable some in-built features which are unnecessary (and probably affects performance?)
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Install the necessary plugins through "lazy.nvim"
require("lazy").setup("plugins", {
	defaults = {
		lazy = true,
	}, -- Make all plugins to be lazy-loaded.
	ui = {
		border = "rounded", -- Enable rounded borders for the "lazy.nvim" UI.
	},
	performance = {
		rtp = {
			disabled_plugins = { -- Disable certain in-built plugins which are useful af.
				"gzip",
				"matchit",
				"matchparen", -- "tarPlugin",
				"tohtml", -- "tutor",
				-- "zipPlugin",
				"rplugin",
				"man",
				"spellfile",
			},
		},
	},
	rocks = {
		enabled = false,
	},
	change_detection = {
		-- enabled = false, -- disable config change detection notifications
		notify = false, -- also disables the annoying message
	},
})

-- Safely load the necessary user-defined Lua modules meant to customise Neovim.
for _, module in ipairs({ "options", "autocmds", "keymaps", "extras" }) do
	local ok, error = pcall(require, module)

	if not ok then
		print("Error loading module: " .. error)
	end
end

vim.cmd.colorscheme("ayu")

-- INFO: Enable an experimental fast module loader. See the PR for more information:
-- https://github.com/neovim/neovim/pull/22668
-- vim.loader.enable()
