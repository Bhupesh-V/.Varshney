-- Module for configuring the plugin responsible for handling LSP configurations
return {
	-- Official plugin for more ease in configuring the in-built LSP client.
	"neovim/nvim-lspconfig",
	event = "LspAttach",
	init = function()
		vim.opt.updatetime = 250 -- Make Neovim to display the diagnostic hover window as fast as possible.
		-- Setup the LSP plugin to log only error messages else the log file grows too large eventually!
		vim.lsp.set_log_level(vim.log.levels.ERROR)
		vim.diagnostic.config({
			underline = true, -- Show diagnostic errors with a squigly underline
			update_in_insert = true, -- Update the diagnostic message even when in Insert mode
			severity_sort = true, -- Configure Neovim to sort the error messages according to the severity.
			virtual_lines = true, -- Display prettier diagnostics on the buffer
		})
		-- Configure the floating window containing information about the object under the cursor
		--vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		--	border = "double", -- Enable a distinguishable border for the window
		--	max_width = math.floor(vim.o.columns * 0.5), -- Cap the width of window at 50% of the terminal size
		--})
		local hover_opts = {
			border = "double",
			max_width = math.floor(vim.o.columns * 0.5),
		}
		vim.lsp.buf.hover(hover_opts)
	end,
	config = function()
		local lspconfig = require("lspconfig")
		local map = require("utils").map
		local fzf = require("fzf-lua")

		require("lspconfig.ui.windows").default_options.border = "rounded"

		local on_attach = function(_, bufnr)
			map("n", "gd", fzf.lsp_definitions, {
				desc = "Jump to the object definition",
			})
			map("n", "gD", vim.lsp.buf.declaration, {
				desc = "Jump to the object declaration",
			})
			map("n", "gT", fzf.lsp_typedefs, {
				desc = "Get the type documentations",
			})
			map("n", "gi", vim.lsp.buf.implementation, {
				desc = "Jump to the implementation",
			})
			map("n", "K", vim.lsp.buf.hover, {
				desc = "Open the documentations of the object",
			})
			map("n", "<C-S>", vim.lsp.buf.signature_help, {
				desc = "Get the help documentations",
			})
			map("n", "gr", vim.lsp.buf.rename, {
				desc = "Rename the object under the cursor",
			})
			map("n", "gR", fzf.lsp_references, {
				desc = "Jump to the reference of the object",
			})
			map("n", "gra", vim.lsp.buf.code_action, {
				desc = "Open available code actions",
			})
			map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, {
				desc = "Add workspace folder",
			})
			map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, {
				desc = "Remove workspace folder",
			})
			map("n", "<leader>wl", vim.lsp.buf.list_workspace_folders, {
				desc = "List workspace folders",
			})

			-- Configurations for showing diagnostics in a hover window instead. See the documentations at:
			-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
			vim.api.nvim_create_autocmd("CursorHold", {
				buffer = bufnr,
				callback = function()
					local hover_window_configs = {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						border = "rounded",
						source = "always",
						prefix = " ",
						scope = "cursor",
					}

					vim.diagnostic.open_float(nil, hover_window_configs)
				end,
			})
		end
		-- Setup LSP servers
		-- Load LSP configurations using dofile (keeps your directory structure)
		local function load_lsp_config(config_name)
			local config_path = vim.fn.stdpath("config") .. "/lsp/" .. config_name .. ".lua"
			return dofile(config_path)
		end

		local servers = {
			gopls = load_lsp_config("gopls"),
			lua_ls = load_lsp_config("lua_ls"),
			ts_ls = load_lsp_config("typescript-language-server"),
		}

		for server, config in pairs(servers) do
			config.on_attach = on_attach
			lspconfig[server].setup(config)
		end
	end,
	dependencies = { -- This plugin needs to be loaded as well otherwise Neovim can't find the LSP binary on $PATH.
		"williamboman/mason.nvim",
	},
}
