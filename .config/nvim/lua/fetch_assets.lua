-- Downloads/extracts the large data files referenced by thesaurus_source.lua
-- and options.lua, which aren't kept in this config directly. Run
-- :NvimFetchAssets once on a fresh machine.
local DATA_DIR = vim.fn.stdpath("config") .. "/data"

local function ensure(path, label, fetch)
	if vim.uv.fs_stat(path) then
		vim.notify(label .. " already present, skipping", vim.log.levels.INFO)
		return
	end
	vim.notify("Fetching " .. label .. "...", vim.log.levels.INFO)
	fetch()
	if vim.uv.fs_stat(path) then
		vim.notify(label .. " ready", vim.log.levels.INFO)
	else
		vim.notify("Failed to fetch " .. label, vim.log.levels.ERROR)
	end
end

local function fetch_all()
	-- Moby Thesaurus II (public domain): https://www.gutenberg.org/files/3202/files/mthesaur.txt
	ensure(DATA_DIR .. "/thesaurus/mthesaur.txt", "Moby Thesaurus", function()
		vim.fn.mkdir(DATA_DIR .. "/thesaurus", "p")
		vim.fn.system({
			"curl",
			"-sL",
			"https://www.gutenberg.org/files/3202/files/mthesaur.txt",
			"-o",
			DATA_DIR .. "/thesaurus/mthesaur.txt",
		})
	end)

	-- GCIDE StarDict dictionary (public domain/GPL):
	-- https://stardict.uber.space/dict.org/stardict-dictd_www.dict.org_gcide-2.4.2.tar.bz2
	local gcide_dir = DATA_DIR .. "/dictionary/stardict-dictd_www.dict.org_gcide-2.4.2"
	ensure(gcide_dir .. "/dictd_www.dict.org_gcide.ifo", "GCIDE dictionary", function()
		vim.fn.mkdir(DATA_DIR .. "/dictionary", "p")
		local tarball = DATA_DIR .. "/dictionary/gcide.tar.bz2"
		vim.fn.system({
			"curl",
			"-sL",
			"https://stardict.uber.space/dict.org/stardict-dictd_www.dict.org_gcide-2.4.2.tar.bz2",
			"-o",
			tarball,
		})
		vim.fn.system({ "tar", "xjf", tarball, "-C", DATA_DIR .. "/dictionary" })
		vim.fn.delete(tarball)
	end)

	if vim.fn.executable("sdcv") == 0 then
		vim.notify("sdcv not found on PATH - install it with: brew install sdcv", vim.log.levels.WARN)
	end
end

vim.api.nvim_create_user_command("NvimFetchAssets", fetch_all, {
	desc = "Download thesaurus/dictionary data files if missing",
})
