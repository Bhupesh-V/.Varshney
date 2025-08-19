local M = {}

-- Utlity function to make autocommands easily
M.autocmd = vim.api.nvim_create_autocmd

-- Utlity function to make augroups more easily
M.augroup = function(name)
	return vim.api.nvim_create_augroup("augroup" .. name, { clear = true })
end

-- Utlity function to make keybind mappings easier & DRY
M.map = function(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys

	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- Setup highlight groups for Neovim easily
M.highlight = vim.api.nvim_set_hl

-- Check if the current directory is version-controlled using Git
M.is_git_repo = function()
	local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
	local output = handle:read("*a")
	handle:close()

	if output:match("true") then
		return true
	else
		return false
	end
end

-- Check if the ".git" directory exists in the current directory
M.has_git_dir = function()
	local handle = io.popen("ls -a 2>/dev/null")
	local output = handle:read("*a")
	handle:close()

	if output:match("%.git") then
		return true
	else
		return false
	end
end

-- Utlity to get current visual selection along with start and end positions
M.get_visual_selection = function()
	-- Source: https://github.com/kristijanhusak/neovim-config/blob/a84dd777a3c202df880c075f89644b919f4efacb/nvim/lua/partials/utils.lua#L26-L38
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")

	if s_start[2] == 0 and s_end[2] == 0 then
		-- fresh neovim boot, visual markers are empty
		return {}, 0, 0
	end

	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

	lines[1] = string.sub(lines[1], s_start[3], -1)

	if n_lines == 1 then
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	else
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	end
	--return table.concat(lines, "\n")
	return lines, s_start, s_end
end

-- Utlity function to trim a lua string
M.trim = function(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

return M
