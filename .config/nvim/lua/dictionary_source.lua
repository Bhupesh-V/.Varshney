-- Minimal blink.cmp source that completes English words from /usr/share/dict/words.
-- Registered only for markdown/text filetypes in lua/plugins/blink.lua.

local source = {}

-- Array of { lower = "word", original = "Word" }, sorted by `lower` so prefix
-- lookups are a binary search instead of a scan over ~235k entries.
local sorted_words = nil
local kind_text = nil

local function load_words()
	if sorted_words then
		return sorted_words
	end
	sorted_words = {}
	local file = io.open("/usr/share/dict/words", "r")
	if file then
		for line in file:lines() do
			if line ~= "" then
				table.insert(sorted_words, { lower = line:lower(), original = line })
			end
		end
		file:close()
	end
	table.sort(sorted_words, function(a, b)
		return a.lower < b.lower
	end)
	return sorted_words
end

-- First index whose `lower` is >= prefix.
local function lower_bound(list, prefix)
	local lo, hi = 1, #list + 1
	while lo < hi do
		local mid = math.floor((lo + hi) / 2)
		if list[mid].lower < prefix then
			lo = mid + 1
		else
			hi = mid
		end
	end
	return lo
end

function source.new()
	return setmetatable({}, { __index = source })
end

function source:enabled()
	return vim.tbl_contains({ "markdown", "text" }, vim.bo.filetype)
end

function source:get_completions(ctx, callback)
	kind_text = kind_text or require("blink.cmp.types").CompletionItemKind.Text

	local prefix = ctx:get_keyword():lower()
	local list = load_words()
	local items = {}

	local i = lower_bound(list, prefix)
	while i <= #list and #items < 50 do
		local entry = list[i]
		if entry.lower:sub(1, #prefix) ~= prefix then
			break
		end
		table.insert(items, { label = entry.original, kind = kind_text })
		i = i + 1
	end

	callback({
		items = items,
		is_incomplete_forward = true,
		is_incomplete_backward = true,
	})

	return function() end
end

return source
