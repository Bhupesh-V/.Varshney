-- Structured fzf-lua picker over data/emotions.json, cross-referencing
-- data/theories.json, data/biases.json, and data/defense_mechanisms.json by
-- name so each emotion's linked psychological theory, cognitive bias, and
-- defense mechanism entries are resolved and shown in full
-- (definition/example/mitigation) rather than just as bare names.
local M = {}

local function read_json(relpath)
	local path = vim.fn.stdpath("config") .. relpath
	local file = io.open(path, "r")
	if not file then
		return {}
	end
	local content = file:read("*a")
	file:close()

	local ok, decoded = pcall(vim.json.decode, content)
	if not ok or type(decoded) ~= "table" then
		return {}
	end
	return decoded
end

local emotions = nil
local theories_by_name = nil
local biases_by_name = nil
local defenses_by_name = nil

local function load()
	if emotions then
		return
	end

	emotions = read_json("/data/emotions.json")

	theories_by_name = {}
	for _, t in ipairs(read_json("/data/theories.json")) do
		theories_by_name[t.name] = t
	end

	biases_by_name = {}
	for _, b in ipairs(read_json("/data/biases.json")) do
		biases_by_name[b.name] = b
	end

	defenses_by_name = {}
	for _, d in ipairs(read_json("/data/defense_mechanisms.json")) do
		defenses_by_name[d.name] = d
	end
end

-- Function-based fzf-lua previews render as raw terminal output (not a real
-- Neovim buffer), so highlighting has to be done via ANSI codes rather than
-- highlight groups/extmarks.
local ANSI_RESET = "\27[0m"
local ANSI_NAME = "\27[1;33m" -- bold yellow
local ANSI_LABEL = "\27[1;36m" -- bold cyan
local ANSI_SUB = "\27[1;35m" -- bold magenta
local ANSI_DIM = "\27[2m" -- dim

local function labeled(label, value)
	if not value or value == "" then
		return nil
	end
	return ANSI_LABEL .. label .. ":" .. ANSI_RESET .. " " .. value
end

-- Resolves a psychological_theory name against theories.json, falling back
-- to a "not found" note if the emotions/theories datasets have drifted.
local function theory_lines(name)
	local t = theories_by_name[name]
	if not t then
		return { ANSI_SUB .. name .. ANSI_RESET .. ANSI_DIM .. "  (not found in theories.json)" .. ANSI_RESET }
	end

	local lines = { ANSI_SUB .. t.name .. ANSI_RESET .. ANSI_DIM .. "  " .. (t.category or "") .. ANSI_RESET }
	if t.originator then
		table.insert(lines, "  Originator: " .. t.originator)
	end
	if t.definition then
		table.insert(lines, "  " .. t.definition)
	end
	if t.example then
		table.insert(lines, "  Example: " .. t.example)
	end
	return lines
end

-- Resolves a cognitive_bias name against biases.json the same way.
local function bias_lines(name)
	local b = biases_by_name[name]
	if not b then
		return { ANSI_SUB .. name .. ANSI_RESET .. ANSI_DIM .. "  (not found in biases.json)" .. ANSI_RESET }
	end

	local lines = { ANSI_SUB .. b.name .. ANSI_RESET .. ANSI_DIM .. "  " .. (b.category or "") .. ANSI_RESET }
	if b.definition then
		table.insert(lines, "  " .. b.definition)
	end
	if b.example then
		table.insert(lines, "  Example: " .. b.example)
	end
	if b.mitigation then
		table.insert(lines, "  Mitigation: " .. b.mitigation)
	end
	return lines
end

-- Resolves a defense_mechanism name against defense_mechanisms.json the same way.
local function defense_lines(name)
	local d = defenses_by_name[name]
	if not d then
		return { ANSI_SUB .. name .. ANSI_RESET .. ANSI_DIM .. "  (not found in defense_mechanisms.json)" .. ANSI_RESET }
	end

	local lines = { ANSI_SUB .. d.name .. ANSI_RESET .. ANSI_DIM .. "  " .. (d.category or "") .. ANSI_RESET }
	if d.definition then
		table.insert(lines, "  " .. d.definition)
	end
	if d.example then
		table.insert(lines, "  Example: " .. d.example)
	end
	if d.healthier_alternative then
		table.insert(lines, "  Healthier alternative: " .. d.healthier_alternative)
	end
	return lines
end

local function preview_text(e)
	local breadcrumb = table.concat({ e.wheel, e.core_emotion, e.subcategory }, " › ")
	local lines = {
		ANSI_NAME .. e.nuance .. ANSI_RESET .. ANSI_DIM .. "  (" .. breadcrumb .. ")" .. ANSI_RESET,
		"",
	}

	for _, l in ipairs({ labeled("Somatic cues", e.somatic_cues), labeled("Action tendency", e.action_tendency) }) do
		if l then
			table.insert(lines, l)
		end
	end

	if e.psychological_theory and #e.psychological_theory > 0 then
		table.insert(lines, "")
		table.insert(lines, ANSI_LABEL .. "Psychological Theory" .. ANSI_RESET)
		for _, name in ipairs(e.psychological_theory) do
			vim.list_extend(lines, theory_lines(name))
		end
	end

	if e.cognitive_bias and #e.cognitive_bias > 0 then
		table.insert(lines, "")
		table.insert(lines, ANSI_LABEL .. "Cognitive Bias" .. ANSI_RESET)
		for _, name in ipairs(e.cognitive_bias) do
			vim.list_extend(lines, bias_lines(name))
		end
	end

	if e.defense_mechanism and #e.defense_mechanism > 0 then
		table.insert(lines, "")
		table.insert(lines, ANSI_LABEL .. "Defense Mechanism" .. ANSI_RESET)
		for _, name in ipairs(e.defense_mechanism) do
			vim.list_extend(lines, defense_lines(name))
		end
	end

	return table.concat(lines, "\n")
end

-- The visible/searchable line packs in every field (wheel, core emotion,
-- subcategory, nuance, cues, tendency, theory + bias + defense mechanism
-- names) so fzf's fuzzy match works against any key in the record, not just
-- the nuance word.
local function display_for(e)
	local parts = {
		e.nuance,
		"[" .. table.concat({ e.wheel, e.core_emotion, e.subcategory }, " › ") .. "]",
	}
	if e.psychological_theory and #e.psychological_theory > 0 then
		table.insert(parts, table.concat(e.psychological_theory, ", "))
	end
	if e.cognitive_bias and #e.cognitive_bias > 0 then
		table.insert(parts, table.concat(e.cognitive_bias, ", "))
	end
	if e.defense_mechanism and #e.defense_mechanism > 0 then
		table.insert(parts, table.concat(e.defense_mechanism, ", "))
	end
	if e.somatic_cues then
		table.insert(parts, e.somatic_cues)
	end
	if e.action_tendency then
		table.insert(parts, e.action_tendency)
	end
	return table.concat(parts, "  │  ")
end

function M.pick()
	load()

	local display = {}
	local by_display = {}
	for _, e in ipairs(emotions) do
		local d = display_for(e)
		table.insert(display, d)
		by_display[d] = e
	end

	require("fzf-lua").fzf_exec(display, {
		prompt = "Emotions Thesaurus❯ ",
		-- Plain (non-fuzzy) case-insensitive substring matching: "joy" only
		-- matches lines containing that exact contiguous substring, instead
		-- of fzf's default scattered-character fuzzy matching.
		fzf_opts = {
			["--exact"] = true,
			["-i"] = true,
		},
		winopts = {
			preview = { wrap = true },
		},
		preview = function(selected)
			local e = by_display[selected[1]]
			return e and preview_text(e) or ""
		end,
		actions = {
			-- Insert just the nuance word at the cursor in the buffer you were writing in
			["default"] = function(selected)
				local e = by_display[selected[1]]
				if e then
					vim.api.nvim_paste(e.nuance, false, -1)
				end
			end,
		},
	})
end

return M
