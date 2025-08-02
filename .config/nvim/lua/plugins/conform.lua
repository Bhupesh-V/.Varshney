-- Module for configuring the "conform" plugin for formatting using LSP

return {
  "stevearc/conform.nvim",
  event = { "LspAttach", "BufReadPost", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      html = { "prettier" },
      javascript = { "prettier" },
      go = { "goimports-reviser", "golines", "gofmt" },
      hcl = { "hclfmt" },
      markdown = { "prettier" },
      lua = { "stylua" },
      scss = { "prettier" },
      sh = { "shfmt" },
      python = { "ruff_organize_imports", "ruff_format" },
      typescript = { "prettier" },
      vue = { "prettier" },
      yaml = { "prettier" },
    },
    format_on_save = function(bufnr)
      local bufname = vim.api.nvim_buf_get_name(bufnr)

      -- Disable file formatting on any temporary buffer contents
      if bufname:match("/tmp/") then
        return
      else
        return {
          timeout_ms = 10000,
          lsp_fallback = true,
        }
      end
    end,
  },
  config = function(_, opts)
    local conform = require("conform")

    -- Setup "conform.nvim" to work
    conform.setup(opts)

    -- Customise the default "prettier" command to format Markdown files as well
    conform.formatters.prettier = {
      prepend_args = { "--prose-wrap", "always" },
    }

    -- Add proper indents to the formatted Shell files
    conform.formatters.shfmt = {
      prepend_args = {
        "--indent=2",
        "--binary-next-line",
        "--case-indent",
        "--space-redirects",
        "--keep-padding",
      },
    }

    -- Format long lines in Go source code
    conform.formatters.golines = {
      prepend_args = {
        "--max-len=88",
        "--reformat-tags",
        "--shorten-comments",
      },
    }

    -- Format the import statements in Go source code
    conform.formatters["goimports-reviser"] = {
      prepend_args = {
        -- FIXME: It removes "used" statements too!!!!
        -- "-rm-unused", -- Remove unused imports
        "-set-alias", -- Create aliases for versioned imports
      },
    }
  end,
  dependencies = { "neovim/nvim-lspconfig" },
}
