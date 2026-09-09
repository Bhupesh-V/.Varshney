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
	local file = io.open(vim.fn.stdpath("config") .. "/thesaurus/mthesaur.txt", "r")
	if file then
		for line in file:lines() do
			if line ~= "" then
				local synonyms = vim.split(line, ",", { plain = true })
				for _, word in ipairs(synonyms) do
					local key = word:lower()
					if not index[key] then
						index[key] = synonyms
					end
				end
			end
		end
		file:close()
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

return M
