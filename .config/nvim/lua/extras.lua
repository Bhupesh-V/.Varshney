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
	-- languages with no special multi-line comment markers
	vim = { prefix = '"', suffix = "", isUnified = true },
	html = { prefix = "<!--", suffix = "-->", isUnified = true },
	markdown = { prefix = "<!--", suffix = "-->", isUnified = true },
	css = { prefix = "/*", suffix = "*/", isUnified = true },
	python = { prefix = "#", suffix = "", isUnified = true },
	sh = { prefix = "#", suffix = "", isUnified = true },
	yaml = { prefix = "#", suffix = "", isUnified = true },
	graphql = { prefix = "#", suffix = "", isUnified = true },
	toml = { prefix = "#", suffix = "", isUnified = true },
	gitignore = { prefix = "#", suffix = "", isUnified = true },
	elixir = { prefix = "#", suffix = "", isUnified = true },
	-- languages with special multi-line comment markers
	go = { single = { prefix = "//", suffix = "" }, multi = { prefix = "/*", suffix = "*/" } },
	javascript = { single = { prefix = "//", suffix = "" }, multi = { prefix = "/*", suffix = "*/" } },
	typescript = { single = { prefix = "//", suffix = "" }, multi = { prefix = "/*", suffix = "*/" } },
	lua = { single = { prefix = "--", suffix = "" }, multi = { prefix = "--[[", suffix = "]]" } },
}

function ToggleComment()
	-- TODO: Set an undo point?
	-- TODO: [Optional] fix cursor position b/w toggles
	-- TODO: fix detection of comment markers in a combination of HTML/CSS/JS code.
	-- TODO: fix comment marker detection for Go (VSCode uses single-line comment for commenting a block of code, wtf?)
	local ft = vim.bo.filetype
	if ft == nil or ft == "" then
		error("Not a valid filetype")
	end

	local comment = comment_chars[ft]
	if comment == nil then
		error("Comment toggle not supported for filetype:" .. ft)
	end

	local prefix, suffix
	local isUnified = false
	local lines, s_start, s_end = get_visual_selection()

	if comment["isUnified"] then
		-- Yeah, I know!
		isUnified = true
	end

	if #lines > 1 then
		-- its a visual selection

		local start_lnum = s_start[2] - 1
		local end_lnum = s_end[2]

		if start_lnum > end_lnum then
			start_lnum, end_lnum = end_lnum, start_lnum
		end

		-- TODO: fix for HTML
		if isUnified then
			prefix = comment["prefix"]
			suffix = comment["suffix"]

			local newLine

			for index, value in ipairs(lines) do
				if value ~= "" then
					-- remove prefix
					if string.sub(trim(value), 1, #prefix) == prefix then
						-- remove prefix
						newLine = string.sub(value, #prefix + 1)
						-- remove suffix
						newLine = string.sub(newLine, 1, #newLine - #suffix)
						lines[index] = newLine
					else
						lines[index] = prefix .. value .. suffix
					end
				end
			end
		else
			local currentfirstLine = lines[1]
			local currentLastLine = lines[#lines]

			prefix = comment["multi"]["prefix"]
			suffix = comment["multi"]["suffix"]

			local newFirstLine, newLastLine

			if
				string.sub(trim(currentfirstLine), 1, #prefix) == prefix
				and string.sub(trim(currentLastLine), -#suffix) == suffix
			then
				-- current line is already commented, un-comment it
				newFirstLine = string.sub(
					currentfirstLine,
					#prefix + 1 + (#currentfirstLine - #trim(currentfirstLine)),
					#currentfirstLine
				)
				newLastLine = string.sub(currentLastLine, 1, #currentLastLine - #suffix)
			else
				newFirstLine = prefix .. currentfirstLine
				newLastLine = currentLastLine .. suffix
			end
			lines[1] = newFirstLine
			lines[#lines] = newLastLine
		end
		vim.api.nvim_buf_set_lines(0, start_lnum, end_lnum, false, lines)
	else
		-- Only support single line toggle on normal mode or visual mode with only single line selection
		local line = vim.api.nvim_get_current_line()
		local trimmed = trim(line)
		local newCurrentLine

		if isUnified then
			prefix = comment["prefix"]
			suffix = comment["suffix"]
		else
			prefix = comment["single"]["prefix"]
			suffix = comment["single"]["suffix"]
		end

		if string.sub(trimmed, 1, #prefix) == prefix then
			newCurrentLine = string.sub(line, #prefix + 1 + (#line - #trimmed), #line - #suffix)
		else
			newCurrentLine = prefix .. line .. suffix
		end
		vim.api.nvim_set_current_line(newCurrentLine)
	end
end
vim.api.nvim_create_user_command("ToggleComment", ToggleComment, {})
vim.keymap.set("v", "<C-/>", ":<C-u>lua ToggleComment()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-/>", ":lua ToggleComment()<CR>", { noremap = true, silent = true })

-- vim.keymap.set("v", "<C-/>", ToggleComment, { noremap = true, silent = true })

-- Normal mode mapping that works on the *last* visual selection
-- vim.keymap.set("n", "<C-/>", "gv<cmd>lua ToggleComment()<CR>", { noremap = true, silent = true })
