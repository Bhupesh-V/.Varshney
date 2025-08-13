local get_visual_selection = require("utils").get_visual_selection
local trim = require("utils").trim

-- Toggle transparent mode (make sure this is always below colorscheme setting)
function ToggleTransparent()
	if vim.g.is_transparent == 0 then
		vim.cmd("hi Normal guibg=NONE ctermbg=NONE ctermfg=NONE guifg=NONE")
		vim.g.is_transparent = 1
	else
		vim.g.is_transparent = 0
		vim.o.background = "dark"
	end
end
vim.api.nvim_create_user_command("ToggleTransparent", ToggleTransparent, {})

-- Run command on the current line and paste its output in next line inside a markdown code block
function AddCmdOutput()
	local line_num = vim.fn.line(".")
	local cmd = vim.fn.getline(".")
	local ok, cmd_output = pcall(vim.fn.systemlist, cmd)

	if not ok or not cmd_output then
		print("Not a command")
		return
	end

	vim.fn.append(line_num, "```")
	vim.fn.append(line_num + 1, cmd_output)
	vim.fn.append(line_num + 1 + #cmd_output, "```")
end
vim.api.nvim_create_user_command("AddCmdOutput", AddCmdOutput, {})

-- Auto pair brackets and stuff
-- Helper function to eat whitespace characters
local function eatchar(pat)
	local c = vim.fn.nr2char(vim.fn.getchar(0))
	return (c:match(pat) and "") or c
end

-- Bracket pairs map
local bracket_pairs = {
	["("] = ")",
	["{"] = "}",
	["["] = "]",
	['"'] = '"',
	["'"] = "'",
	["`"] = "`",
	["<"] = ">",
}
-- Set keymaps dynamically
for open, close in pairs(bracket_pairs) do
	vim.keymap.set("i", open, function()
		local _, col = unpack(vim.api.nvim_win_get_cursor(0))
		local line = vim.api.nvim_get_current_line()

		-- Get chars before/after cursor
		local before = col > 0 and line:sub(col, col) or ""
		local after = line:sub(col + 1, col + 1)

		-- Only insert the pair if both before and after are non-whitespace chars
		if before:match("%S") or after:match("%S") then
			return open -- insert the typed char
		end
		return open .. close .. "<Left>" .. eatchar("%s")
	end, { silent = true, expr = true })
end

local comment_chars = {
	vim = { prefix = '"', suffix = "" },
	python = { prefix = "#", suffix = "", isUnified = true },
	sh = { prefix = "#", suffix = "", isUnified = true },
	go = { single = { prefix = "//", suffix = "" }, multi = { prefix = "/*", suffix = "*/" } },
	html = { prefix = "<!--", suffix = "-->", isUnified = true },
	css = { prefix = "/*", suffix = "*/", isUnified = true },
	javascript = { single = { prefix = "//", suffix = "" }, multi = { prefix = "/*", suffix = "*/" } },
	typescript = { single = { prefix = "//", suffix = "" }, multi = { prefix = "/*", suffix = "*/" } },
	yaml = { prefix = "#", suffix = "", isUnified = true },
	markdown = { prefix = "<!--", suffix = "-->", isUnified = true },
	lua = { single = { prefix = "--", suffix = "" }, multi = { prefix = "--[[", suffix = "]]" } },
}

function ToggleComment()
	-- TODO: Set an undo point?
	-- TODO: [Optional] fix cursor position b/w toggles
	local ft = vim.bo.filetype
	local comment = comment_chars[ft]
	local prefix, suffix

	if comment == nil then
		error("Comment toggle not supported for filetype:" .. ft)
	end

	local lines, s_start, s_end = get_visual_selection()

	if comment["isUnified"] then
		prefix = comment["single"]["prefix"]
		suffix = comment["single"]["suffix"]
	else
		prefix = comment["multi"]["prefix"]
		suffix = comment["multi"]["suffix"]
	end

	if #lines > 1 then
		-- visual selection
		if #lines == 0 then
			-- Nothing to comment/uncomment
			return
		end

		local start_lnum = s_start[2] - 1
		local end_lnum = s_end[2]

		if start_lnum > end_lnum then
			start_lnum, end_lnum = end_lnum, start_lnum
		end

		local currentfirstLine = lines[1]
		local currentLastLine = lines[#lines]

		local trimmedFirstLine = trim(currentfirstLine)
		local trimmedLastLine = trim(currentLastLine)

		print("currentfirstLine len", #currentfirstLine)
		print("currentfirstLine", currentfirstLine)
		print("currentLastLine len", #currentLastLine)
		print("currentLastLine", currentLastLine)

		print("trimmedFirstLine", trimmedFirstLine)
		print("trimmedFirstLine length", #trimmedFirstLine)
		print("trimmedLastLine", trimmedLastLine)
		print("trimmedLastLine length", #trimmedLastLine)

		print("prefix", #prefix)
		print("suffix", #suffix)

		if string.sub(trimmedFirstLine, 1, #prefix) == prefix then
			print("uncommenting in visual")
			-- current line is already commentencomment it
			local firstLine =
				string.sub(currentfirstLine, #prefix + 1 + (#currentfirstLine - #trimmedFirstLine), #currentfirstLine)
			local lastLine = string.sub(currentLastLine, 1, #currentLastLine - #suffix)

			lines[1] = firstLine
			lines[#lines] = lastLine

			vim.api.nvim_buf_set_lines(0, start_lnum, end_lnum, false, lines)
		else
			local firstLine = prefix .. currentfirstLine

			local lastLine = currentLastLine .. suffix

			lines[1] = firstLine
			lines[#lines] = lastLine

			vim.api.nvim_buf_set_lines(0, start_lnum, end_lnum, false, lines)
		end
	else
		-- Only support single line toggle on normal mode
		local line = vim.api.nvim_get_current_line()
		local trimmed = trim(line)

		if string.sub(trimmed, 1, #prefix) == prefix then
			-- current line is already commented, so uncomment it
			local new_line = string.sub(line, #prefix + 1 + (#line - #trimmed), #line - #suffix)
			vim.api.nvim_set_current_line(new_line)
		else
			vim.api.nvim_set_current_line(prefix .. line .. suffix)
		end
	end
end
vim.api.nvim_create_user_command("ToggleComment", ToggleComment, {})
vim.keymap.set("v", "<C-/>", ":<C-u>lua ToggleComment()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-/>", ":lua ToggleComment()<CR>", { noremap = true, silent = true })

-- vim.keymap.set("v", "<C-/>", ToggleComment, { noremap = true, silent = true })

-- Normal mode mapping that works on the *last* visual selection
-- vim.keymap.set("n", "<C-/>", "gv<cmd>lua ToggleComment()<CR>", { noremap = true, silent = true })
