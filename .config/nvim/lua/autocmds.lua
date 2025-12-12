-- autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local general = augroup("GeneralSettings", { clear = true })

-- Reload file if changed externally
autocmd("FocusGained", {
	group = general,
	pattern = "*",
	command = "checktime",
})

-- Highlight on yank
autocmd("TextYankPost", {
	group = general,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

-- Filetype specific indentation
autocmd("FileType", {
	group = general,
	pattern = { "python", "lua" },
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end,
})

-- Automatically resize splits on window resize
autocmd("VimResized", {
	group = general,
	command = "wincmd =",
})
