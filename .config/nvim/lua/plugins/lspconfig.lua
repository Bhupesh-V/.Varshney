-- Module for configuring the plugin responsible for handling LSP configurations
return {
    -- Official plugin for more ease in configuring the in-built LSP client.
    "neovim/nvim-lspconfig",
    event = "LspAttach",
    init = function()
        vim.opt.updatetime = 250 -- Make Neovim display the diagnostic hover window quickly.
        -- Setup the LSP plugin to log only error messages else the log file grows too large eventually!
        vim.lsp.log.set_level(vim.log.levels.ERROR)
        vim.diagnostic.config({
            underline = true, -- Show diagnostic errors with a squiggly underline
            update_in_insert = true, -- Update diagnostic messages in Insert mode
            severity_sort = true, -- Sort error messages according to severity
            virtual_lines = true, -- Display prettier diagnostics on the buffer
        })
        -- Configure floating window borders globally via LSP handlers instead of calling vim.lsp.buf.hover() directly
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover,
            {
                border = "double",
                max_width = math.floor(vim.o.columns * 0.5),
            }
        )
    end,
    config = function()
        local map = require("utils").map
        local fzf = require("fzf-lua")

        require("lspconfig.ui.windows").default_options.border = "rounded"

        local on_attach = function(_, bufnr)
            map("n", "gd", fzf.lsp_definitions, {
                desc = "Jump to the object definition",
            })
            map("n", "gD", fzf.lsp_declarations, {
                desc = "Jump to the object declaration",
            })
            map("n", "gT", fzf.lsp_typedefs, {
                desc = "Get the type documentations",
            })
            map("n", "gi", fzf.lsp_implementations, {
                desc = "Jump to the implementation",
            })
            map("n", "gR", fzf.lsp_references, {
                desc = "Jump to the reference of the object",
            })
            map("n", "gra", fzf.lsp_code_actions, {
                desc = "Open available code actions",
            })
            map("n", "<leader>d", fzf.lsp_document_diagnostics, {
                desc = "Show diagnostics",
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
            map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, {
                desc = "Add workspace folder",
            })
            map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, {
                desc = "Remove workspace folder",
            })
            map("n", "<leader>wl", vim.lsp.buf.list_workspace_folders, {
                desc = "List workspace folders",
            })

            -- Configurations for showing diagnostics in a hover window automatically
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

        -- Neovim 0.11+ API setup replacing deprecated require("lspconfig")[server].setup()
        for server, config in pairs(servers) do
            config.on_attach = on_attach
            vim.lsp.config[server] = config
            vim.lsp.enable(server)
        end
    end,
    dependencies = {
        "williamboman/mason.nvim",
    },
}