-- Custom 'thesaurusfunc' for <C-x><C-t>, so the completion menu shows just
-- the synonym instead of Neovim's default "word  <source file path>" row.
local M = {}

-- Maps lowercase word -> its synonym list, built once on first use so each
-- lookup is a hash access instead of scanning the whole ~2.5M-word thesaurus.
local index = nil

local function load_index()
	if index then
		return index
	end
	index = {}
	local file = io.open(vim.fn.stdpath("config") .. "/data/thesaurus/mthesaur.txt", "r")
	if file then
		local lines = {}
		for line in file:lines() do
			if line ~= "" then
				table.insert(lines, vim.split(line, ",", { plain = true }))
			end
		end
		file:close()

		-- First pass: first-come mapping for every word, including as an
		-- incidental member of someone else's loosely-associated cluster.
		for _, synonyms in ipairs(lines) do
			for _, word in ipairs(synonyms) do
				local key = word:lower()
				if not index[key] then
					index[key] = synonyms
				end
			end
		end
		-- Second pass: a word's own dedicated entry (where it's the head,
		-- i.e. the first item on its line) is always a better synonym set
		-- than an incidental mention elsewhere, so it always wins here
		-- regardless of which line came first in the file.
		for _, synonyms in ipairs(lines) do
			index[synonyms[1]:lower()] = synonyms
		end
	end
	return index
end

function M.complete(findstart, base)
	if findstart == 1 then
		local line = vim.api.nvim_get_current_line()
		local col = vim.api.nvim_win_get_cursor(0)[2]
		local start = col
		while start > 0 and line:sub(start, start):match("[%w'-]") do
			start = start - 1
		end
		return start
	end

	local synonyms = load_index()[base:lower()]
	if not synonyms then
		return {}
	end

	local words = {}
	for _, syn in ipairs(synonyms) do
		if syn ~= base then
			table.insert(words, { word = syn, menu = "" })
		end
	end
	return words
end

-- Looks up `word` via sdcv (https://github.com/Dushistov/sdcv, installed via
-- `brew install sdcv`) + the local GCIDE StarDict dictionary, downloaded from:
-- https://stardict.uber.space/dict.org/stardict-dictd_www.dict.org_gcide-2.4.2.tar.bz2
-- (GNU Collaborative International Dictionary of English, public domain/GPL)
-- extracted into data/dictionary/stardict-dictd_www.dict.org_gcide-2.4.2/.
-- Returns cleaned definition text, or nil if sdcv isn't installed or nothing
-- was found. Cached per word since the picker below calls this on every
-- highlight change while scrolling, not just once.
local definition_cache = {}

local function get_definition(word)
	local key = word:lower()
	if definition_cache[key] ~= nil then
		return definition_cache[key] or nil
	end

	local result = nil
	if vim.fn.executable("sdcv") == 1 then
		local dict_dir = vim.fn.stdpath("config") .. "/data/dictionary"
		local raw = vim.fn.system({ "sdcv", "--utf8-output", "--non-interactive", "--data-dir", dict_dir, word })
		if vim.v.shell_error == 0 and raw then
			local cleaned = {}
			for _, line in ipairs(vim.split(raw, "\n")) do
				if not line:match("^Found") and not line:match("^%-%->") and not line:match("^save to cache") then
					table.insert(cleaned, line)
				end
			end
			local text = table.concat(cleaned, "\n"):gsub("^%s+", ""):gsub("%s+$", "")
			result = text ~= "" and text or nil
		end
	end

	definition_cache[key] = result or false
	return result
end

-- fzf-lua picker of synonyms for the word under cursor, complementing the
-- in-flow <C-x><C-t> insert-mode completion above. Selecting an entry
-- replaces the word under cursor with it. The preview pane shows the
-- currently highlighted candidate's own dictionary definition.
function M.pick()
	local word = vim.fn.expand("<cword>")
	if word == "" then
		return
	end

	local synonyms = load_index()[word:lower()]
	if not synonyms then
		vim.notify("No thesaurus entry for '" .. word .. "'", vim.log.levels.WARN)
		return
	end

	local display = {}
	for _, syn in ipairs(synonyms) do
		if syn:lower() ~= word:lower() then
			table.insert(display, syn)
		end
	end

	require("fzf-lua").fzf_exec(display, {
		prompt = "Synonyms for " .. word .. "❯ ",
		winopts = {
			preview = { wrap = true },
		},
		preview = function(selected)
			local candidate = selected[1]
			if not candidate then
				return ""
			end
			return get_definition(candidate) or ("No definition found for '" .. candidate .. "'")
		end,
		actions = {
			["default"] = function(selected)
				local replacement = selected[1]
				if not replacement then
					return
				end
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes("ciw" .. replacement .. "<Esc>", true, false, true),
					"n",
					true
				)
			end,
		},
	})
end

return M
