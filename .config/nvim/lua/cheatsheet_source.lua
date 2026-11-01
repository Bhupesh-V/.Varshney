-- Per-markdown-file "cheatsheet" editor. For the currently open .md buffer,
-- edits a sibling cheatsheet-<basename>.md holding answers to the question
-- set defined in data/cheatsheet-template.json (symlinked from the weet
-- repo), so character/setting notes live next to the prose about them.
--
-- The on-disk file is plain, human-readable markdown, and the editing buffer
-- IS that same text verbatim (no virtual-text tricks):
--
--   # Bob — Character Voice
--
--   ## how old they are?
--   34
--
--   ## where they grew up
--   ...
--
-- "Locking" the "# "/"## " header lines works by watching the buffer
-- (nvim_buf_attach's on_lines) and, whenever an edit makes the header
-- sequence diverge from what it should be, immediately repairing just the
-- one divergence found — restoring corrupted header text in place, or
-- re-inserting a header line that got deleted outright. This self-heals
-- within a tick rather than blocking the keystroke, but it means answer
-- content can never actually corrupt the header structure, and — unlike an
-- earlier extmark-based approach — a header can never simply vanish and take
-- an answer down with it, because there's no position-tracking to break.
--
-- A BufReadCmd/BufWriteCmd pair (registered in autocmds.lua) reads/writes
-- this file format directly, so opening cheatsheet-*.md via a plain :e (not
-- just M.pick()) also gets the locked view.
local M = {}

-- bufnr -> { path, entries, attached }. `entries` is the in-memory source of
-- truth for *structure* (names/labels/order) once a buffer is loaded; the
-- buffer's real text is the source of truth for answer content.
local state = {}

local function read_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	return content
end

local function write_file(path, content)
	local file = io.open(path, "w")
	if not file then
		vim.notify("cheatsheet: could not write " .. path, vim.log.levels.ERROR)
		return false
	end
	file:write(content)
	file:close()
	return true
end

-- "character-voice" -> "Character Voice"
local function titleize(slug)
	local words = {}
	for word in slug:gmatch("[^%-_]+") do
		table.insert(words, word:sub(1, 1):upper() .. word:sub(2))
	end
	return table.concat(words, " ")
end

-- Only one template exists today (data/cheatsheet-template.json), and it's
-- only consulted when creating a *new* entry. Entries already saved to disk
-- are self-describing (their own "## question" headers are authoritative),
-- so template rewording later never orphans old answers.
local function load_template()
	local path = vim.fn.stdpath("config") .. "/data/cheatsheet-template.json"
	local content = read_file(path)
	if not content then
		return nil
	end
	local ok, data = pcall(vim.json.decode, content)
	if not ok then
		return nil
	end
	local raw = data and data.cheatsheets
	if not raw or not raw.type or not raw.questions then
		return nil
	end
	return { name = raw.name or titleize(raw.type), questions = raw.questions }
end

local function cheatsheet_path()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname == "" or vim.fn.fnamemodify(bufname, ":e") ~= "md" then
		return nil
	end
	if vim.fn.fnamemodify(bufname, ":t"):match("^cheatsheet%-") then
		return nil -- already viewing a cheatsheet file, not a source file
	end
	local dir = vim.fn.fnamemodify(bufname, ":h")
	local base = vim.fn.fnamemodify(bufname, ":t:r")
	return dir .. "/cheatsheet-" .. base .. ".md"
end

local function trim_blank_edges(lines)
	while #lines > 0 and lines[1] == "" do
		table.remove(lines, 1)
	end
	while #lines > 0 and lines[#lines] == "" do
		table.remove(lines)
	end
	return lines
end

-- "# Bob — Character Voice" / "## how old they are?" -> {entries}
local function parse_cheatsheet_md(content)
	local entries = {}
	local entry, question
	for line in (content .. "\n"):gmatch("(.-)\n") do
		local name, template_name = line:match("^# (.-) — (.+)$")
		if name then
			entry = { name = name, template_name = template_name, questions = {} }
			table.insert(entries, entry)
			question = nil
		else
			local label = line:match("^## (.+)$")
			if label and entry then
				question = { label = label, lines = {} }
				table.insert(entry.questions, question)
			elseif question then
				table.insert(question.lines, line)
			end
		end
	end
	for _, e in ipairs(entries) do
		for _, q in ipairs(e.questions) do
			q.answer = table.concat(trim_blank_edges(q.lines), "\n")
			q.lines = nil
		end
	end
	return entries
end

local function render_cheatsheet_md(entries)
	local lines = {}
	for _, e in ipairs(entries) do
		table.insert(lines, "# " .. e.name .. " — " .. e.template_name)
		table.insert(lines, "")
		for _, q in ipairs(e.questions) do
			table.insert(lines, "## " .. q.label)
			if q.answer and q.answer ~= "" then
				vim.list_extend(lines, vim.split(q.answer, "\n", { plain = true }))
			end
			table.insert(lines, "")
		end
	end
	while #lines > 0 and lines[#lines] == "" do
		table.remove(lines)
	end
	return table.concat(lines, "\n") .. "\n"
end

local function md_to_lines(content)
	if content == "" then
		return { "" }
	end
	return vim.split((content:gsub("\n$", "")), "\n", { plain = true })
end

-- Flat, ordered list of every header line that MUST appear in the buffer,
-- in order (not necessarily contiguous — answer lines fall between them).
local function expected_headers(entries)
	local list = {}
	for _, e in ipairs(entries) do
		table.insert(list, "# " .. e.name .. " — " .. e.template_name)
		for _, q in ipairs(e.questions) do
			table.insert(list, "## " .. q.label)
		end
	end
	return list
end

-- Scans the buffer top-to-bottom against `expected_headers`, fixes the
-- FIRST divergence found (in-place text restore, or re-inserting a deleted
-- header), and returns true if it made a change. Callers loop until it
-- returns false to fully converge, since a single edit can break more than
-- one header (e.g. a multi-line visual delete).
local function repair(bufnr)
	local st = state[bufnr]
	if not st then
		return false
	end
	local expected = expected_headers(st.entries)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local ei, row = 1, 0
	while ei <= #expected and row < #lines do
		local line = lines[row + 1]
		if line == expected[ei] then
			ei = ei + 1
			row = row + 1
		elseif line:match("^#+ ") then
			-- Header-shaped line with unexpected text. If it matches some
			-- LATER expected header, expected[ei] itself was deleted ->
			-- insert it here. Otherwise this line's text was corrupted ->
			-- restore it in place.
			local matches_later = false
			for j = ei + 1, #expected do
				if line == expected[j] then
					matches_later = true
					break
				end
			end
			if matches_later then
				vim.api.nvim_buf_set_lines(bufnr, row, row, false, { expected[ei] })
			else
				vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, { expected[ei] })
			end
			return true
		else
			row = row + 1
		end
	end
	if ei <= #expected then
		vim.api.nvim_buf_set_lines(bufnr, row, row, false, { expected[ei] })
		return true
	end
	return false
end

local function attach_guard(bufnr)
	if state[bufnr].attached then
		return
	end
	state[bufnr].attached = true
	vim.api.nvim_buf_attach(bufnr, false, {
		on_lines = function()
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(bufnr) then
					repair(bufnr)
				end
			end)
		end,
		on_detach = function()
			state[bufnr] = nil
		end,
	})
end

local function focus_entry(bufnr, entry_idx)
	local st = state[bufnr]
	if not st then
		return
	end
	local e = st.entries[entry_idx]
	local header = "# " .. e.name .. " — " .. e.template_name
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for i, line in ipairs(lines) do
		if line == header then
			vim.api.nvim_win_set_cursor(0, { i, 0 })
			return
		end
	end
end

local function ensure_open(path)
	vim.cmd.edit(vim.fn.fnameescape(path))
	return vim.api.nvim_get_current_buf()
end

-- BufReadCmd handler for cheatsheet-*.md, wired from autocmds.lua.
function M._read(bufnr)
	local path = vim.api.nvim_buf_get_name(bufnr)
	local content = read_file(path)
	local entries = content and parse_cheatsheet_md(content) or {}

	vim.bo[bufnr].modifiable = true
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, #entries > 0 and md_to_lines(render_cheatsheet_md(entries)) or { "" })

	state[bufnr] = { path = path, entries = entries }
	attach_guard(bufnr)

	vim.bo[bufnr].filetype = "markdown"
	vim.bo[bufnr].buftype = "acwrite"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].modified = false
end

-- BufWriteCmd handler for cheatsheet-*.md, wired from autocmds.lua.
function M._write(bufnr)
	local st = state[bufnr]
	if not st then
		return
	end
	-- Synchronous safety net in case an on_lines repair from the last edit
	-- hasn't had its scheduled callback run yet.
	while repair(bufnr) do
	end

	local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") .. "\n"
	if write_file(st.path, content) then
		st.entries = parse_cheatsheet_md(content)
		vim.bo[bufnr].modified = false
		vim.notify("Saved " .. vim.fn.fnamemodify(st.path, ":t"), vim.log.levels.INFO)
	end
end

local function new_entry(path)
	local template = load_template()
	if not template then
		vim.notify(
			"cheatsheet: couldn't load data/cheatsheet-template.json (run weet/scripts/link_nvim_data?)",
			vim.log.levels.WARN
		)
		return
	end

	vim.ui.input({ prompt = "Name (character/setting this is about): " }, function(name)
		if not name or name == "" then
			return
		end

		local bufnr = ensure_open(path)
		local st = state[bufnr]

		local questions = {}
		for _, label in ipairs(template.questions) do
			table.insert(questions, { label = label, answer = "" })
		end
		local entry = { name = name, template_name = template.name, questions = questions }
		table.insert(st.entries, entry)

		local block = md_to_lines(render_cheatsheet_md({ entry }))
		local existing = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		if #existing > 0 and existing[#existing] ~= "" then
			table.insert(block, 1, "")
		end

		local last = vim.api.nvim_buf_line_count(bufnr)
		vim.api.nvim_buf_set_lines(bufnr, last, last, false, block)

		focus_entry(bufnr, #st.entries)
	end)
end

function M.pick()
	local path = cheatsheet_path()
	if not path then
		vim.notify("cheatsheet: open a source markdown (.md) file first", vim.log.levels.WARN)
		return
	end

	local loaded_bufnr = vim.fn.bufnr(path)
	local entries
	if loaded_bufnr ~= -1 and vim.api.nvim_buf_is_loaded(loaded_bufnr) and state[loaded_bufnr] then
		entries = state[loaded_bufnr].entries
	else
		local content = read_file(path)
		entries = content and parse_cheatsheet_md(content) or {}
	end

	local display = { "+ New entry" }
	local by_display = {}
	for i, e in ipairs(entries) do
		local label = e.name .. "  [" .. e.template_name .. "]"
		table.insert(display, label)
		by_display[label] = i
	end

	require("fzf-lua").fzf_exec(display, {
		prompt = "Cheatsheet: " .. vim.fn.fnamemodify(path, ":t") .. "❯ ",
		fzf_opts = { ["--exact"] = true, ["-i"] = true },
		winopts = { preview = { hidden = true } },
		actions = {
			["default"] = function(selected)
				local choice = selected[1]
				if choice == "+ New entry" then
					new_entry(path)
				else
					local bufnr = ensure_open(path)
					focus_entry(bufnr, by_display[choice])
				end
			end,
		},
	})
end

return M
