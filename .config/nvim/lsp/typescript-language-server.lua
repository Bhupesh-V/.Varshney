return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"typescript",
		"javascript",
	},
	root_markers = { "package.json" },
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}
