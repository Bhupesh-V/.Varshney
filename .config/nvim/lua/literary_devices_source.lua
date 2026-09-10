-- Structured fzf-lua picker over data/literary_devices_reference.txt.
-- Parses the file into {name, definition, example} entries so search and
-- preview work on clean fields instead of raw grep lines.
local M = {}

local function parse()
	local entries = {}
	local path = vim.fn.stdpath("config") .. "/data/literary_devices_reference.txt"
	local file = io.open(path, "r")
	if not file then
		return entries
	end

	local lines = {}
	for line in file:lines() do
		table.insert(lines, line)
	end
	file:close()

	local i = 1
	while i <= #lines do
		local line = lines[i]
		-- A device name is a non-indented line immediately followed by an
		-- indented "Definition:" line (distinguishes it from section
		-- headers/dividers/table-of-contents lines).
		if line ~= "" and line:match("^%S") and lines[i + 1] and lines[i + 1]:match("^%s+Definition:") then
			local entry = { name = line }
			i = i + 1
			while lines[i] and (lines[i] == "" or lines[i]:match("^%s")) do
				local def = lines[i]:match("^%s*Definition:%s*(.*)")
				local ex = lines[i]:match("^%s*Example:%s*(.*)")
				if def then
					entry.definition = def
				elseif ex then
					entry.example = ex
				end
				i = i + 1
			end
			table.insert(entries, entry)
		else
			i = i + 1
		end
	end
	return entries
end

local entries = nil
local by_name = nil

local function load()
	if not entries then
		entries = parse()
		by_name = {}
		for _, e in ipairs(entries) do
			by_name[e.name] = e
		end
	end
	return entries, by_name
end

-- Function-based fzf-lua previews render as raw terminal output (not a real
-- Neovim buffer), so highlighting has to be done via ANSI codes rather than
-- highlight groups/extmarks.
local ANSI_RESET = "\27[0m"
local ANSI_NAME = "\27[1;33m" -- bold yellow
local ANSI_LABEL = "\27[1;36m" -- bold cyan

local function preview_text(e)
	local lines = { ANSI_NAME .. e.name .. ANSI_RESET, "" }
	if e.definition then
		table.insert(lines, ANSI_LABEL .. "Definition:" .. ANSI_RESET .. " " .. e.definition)
	end
	if e.example then
		table.insert(lines, "")
		table.insert(lines, ANSI_LABEL .. "Example:" .. ANSI_RESET .. " " .. e.example)
	end
	return table.concat(lines, "\n")
end

function M.pick()
	local list, index = load()
	local display = {}
	for _, e in ipairs(list) do
		table.insert(display, e.name)
	end

	require("fzf-lua").fzf_exec(display, {
		prompt = "Literary Devices❯ ",
		winopts = {
			preview = { wrap = true },
		},
		preview = function(selected)
			local e = index[selected[1]]
			return e and preview_text(e) or ""
		end,
		actions = {
			-- Insert the device name at the cursor in the buffer you were writing in
			["default"] = function(selected)
				local e = index[selected[1]]
				if e then
					vim.api.nvim_paste(e.name, false, -1)
				end
			end,
		},
	})
end

return M
