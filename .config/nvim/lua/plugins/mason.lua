-- Module for configuring the "mason" plugin for managing LSP servers

return {
  {
    "mason-org/mason.nvim",
    cmd = { "LspInstall", "LspUninstall", "Mason" },
    opts = {
      -- Configure the plugin to have rounded borders
      ui = { border = "rounded" },

      -- Configure the log levels for the plugin
      log_level = vim.log.levels.WARN,
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
    dependencies = { "neovim/nvim-lspconfig" },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    opts = {
      ensure_installed = {
        "bash-language-server",
        "black",
        "css-lsp",
        "debugpy",
        "dockerfile-language-server",
        "eslint-lsp",
        "goimports-reviser",
        "golines",
        "gopls",
        "hadolint",
        "hclfmt",
        "json-lsp",
        "lua-language-server",
        "prettier",
        "pyright",
        "shellcheck",
        "shfmt",
        "stylua",
        "stylelint",
        "sqlls",
        "terraform-ls",
        "typescript-language-server",
        "tinymist",
        "vale-ls",
        "vtsls",
        "yaml-language-server",
        "yamllint",
      },
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },
}
