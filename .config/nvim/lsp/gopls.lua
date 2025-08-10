-- Configurations for the "gopls" LSP server for Go files
return {
    cmd = {"gopls"},
    filetypes = {"go", "gomod", "gowork", "gotmpl"},
    root_markers = {"go.work", "go.mod", ".git"},
    settings = {
        gopls = {
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            analyses = {
                unusedparams = true,
                shadow = true
            }
        }
    },
    on_init = function(client)
        -- Optional: adjust client config on init if needed
        local path = client.workspace_folders and client.workspace_folders[1].name or nil
        if path and not vim.uv.fs_stat(path .. "/go.mod") then
            vim.notify("gopls: go.mod not found in root dir", vim.log.levels.WARN)
        end
    end,
    capabilities = (function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        return capabilities
    end)()
}
