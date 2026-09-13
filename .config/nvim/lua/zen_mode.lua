-- Minimal, dependency-free zen/distraction-free-writing mode.
local M = {}

-- Feature flags
M.hide_ruler = true -- hide the bottom-right "1,1 / Top" ruler while zen mode is active

local WIN_OPTS = { "number", "relativenumber", "cursorline", "signcolumn", "foldcolumn", "fillchars", "winhl" }
local CONTENT_WIDTH = 100

local state = nil

local function make_pad_win(direction)
	vim.cmd(direction .. " vnew")
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_get_current_buf()
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.cursorline = false
	vim.wo.signcolumn = "no"
	vim.wo.foldcolumn = "0"
	vim.wo.winfixwidth = true
	vim.wo.winhl = "Normal:Normal,EndOfBuffer:Normal,WinSeparator:Normal"
	vim.wo.fillchars = "eob: ,vert: " -- hide "~" end-of-buffer markers and the window separator line
	return win
end

local function pad_width()
	return math.max(0, math.floor((vim.o.columns - CONTENT_WIDTH) / 2))
end

function M.open()
	if state then
		return
	end

	local main_win = vim.api.nvim_get_current_win()
	local saved = {
		win_opts = {},
		laststatus = vim.o.laststatus,
		showcmd = vim.o.showcmd,
		ruler = vim.o.ruler,
	}
	for _, name in ipairs(WIN_OPTS) do
		saved.win_opts[name] = vim.wo[name]
	end

	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.cursorline = false
	vim.wo.signcolumn = "no"
	vim.wo.foldcolumn = "0"
	vim.wo.fillchars = "eob: ,vert: " -- hide "~" markers and the padding windows' separator line
	vim.wo.winhl = "WinSeparator:Normal"
	vim.o.laststatus = 0
	vim.o.showcmd = false
	if M.hide_ruler then
		vim.o.ruler = false
	end

	local left_win, right_win
	local pad = pad_width()
	if pad > 2 then
		vim.api.nvim_set_current_win(main_win)
		left_win = make_pad_win("leftabove")
		vim.api.nvim_win_set_width(left_win, pad)

		vim.api.nvim_set_current_win(main_win)
		right_win = make_pad_win("rightbelow")
		vim.api.nvim_win_set_width(right_win, pad)

		vim.api.nvim_set_current_win(main_win)
	end

	local group = vim.api.nvim_create_augroup("ZenModeMinimal", { clear = true })
	-- If the main window itself gets closed while zen mode is active, clean
	-- everything up rather than leaving padding windows/autocmds referencing
	-- a dead window id. Deferred via vim.schedule: closing more windows
	-- (the padding ones) from directly within WinClosed, while the original
	-- close is still in progress, triggers E855 (autocommands caused command
	-- to abort) - scheduling runs it after the close has fully finished.
	vim.api.nvim_create_autocmd("WinClosed", {
		group = group,
		pattern = tostring(main_win),
		callback = function()
			vim.schedule(M.close)
		end,
	})
	-- Keep the padding windows out of normal window navigation - jump back
	-- to the main window if you land on one (e.g. via <C-w><C-w>/<Tab>).
	vim.api.nvim_create_autocmd("WinEnter", {
		group = group,
		callback = function()
			if not state then
				return
			end
			if not vim.api.nvim_win_is_valid(state.main_win) then
				-- Deferred for the same reason as the WinClosed handler above:
				-- closing more windows directly from within WinEnter, while a
				-- window layout change is still in progress, raises E1312.
				vim.schedule(M.close)
				return
			end
			local cur = vim.api.nvim_get_current_win()
			if cur == state.left_win or cur == state.right_win then
				vim.api.nvim_set_current_win(state.main_win)
			end
		end,
	})
	-- Keep the padding proportional if the terminal itself is resized.
	vim.api.nvim_create_autocmd("VimResized", {
		group = group,
		callback = function()
			if not state then
				return
			end
			local new_pad = pad_width()
			for _, win in ipairs({ state.left_win, state.right_win }) do
				if win and vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_set_width(win, new_pad)
				end
			end
		end,
	})

	state = { main_win = main_win, saved = saved, left_win = left_win, right_win = right_win, group = group }
end

function M.close()
	if not state then
		return
	end

	pcall(vim.api.nvim_del_augroup_by_id, state.group)

	local main_valid = vim.api.nvim_win_is_valid(state.main_win)

	if not main_valid then
		-- Main content window is already gone (e.g. via :q). If only our own
		-- padding windows are left in this tab, there's nothing worth
		-- keeping open - close the tab (or quit if it's the only one)
		-- instead of individually closing windows, which errors with E444
		-- on the last one remaining.
		local only_padding = true
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if win ~= state.left_win and win ~= state.right_win then
				only_padding = false
				break
			end
		end
		if only_padding then
			state = nil
			if #vim.api.nvim_list_tabpages() > 1 then
				vim.cmd("tabclose")
			else
				vim.cmd("qa")
			end
			return
		end
	end

	for _, win in ipairs({ state.left_win, state.right_win }) do
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	if main_valid then
		vim.api.nvim_set_current_win(state.main_win)
		for name, value in pairs(state.saved.win_opts) do
			vim.wo[name] = value
		end
	end
	vim.o.laststatus = state.saved.laststatus
	vim.o.showcmd = state.saved.showcmd
	vim.o.ruler = state.saved.ruler

	state = nil
end

function M.toggle()
	if state then
		M.close()
	else
		M.open()
	end
end

vim.api.nvim_create_user_command("ZenMode", M.toggle, { desc = "Toggle minimal distraction-free writing mode" })

return M
