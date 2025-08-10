return {
    'saghen/blink.cmp',

    lazy = false,

    -- use a release tag to download pre-built binaries
    version = '1.6.0',

    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
            preset = 'super-tab'
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },
        snippets = {
            -- Function to use when expanding LSP provided snippets
            expand = function(snippet)
                vim.snippet.expand(snippet)
            end,
            -- Function to use when checking if a snippet is active
            active = function(filter)
                return vim.snippet.active(filter)
            end,
            -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
            jump = function(direction)
                vim.snippet.jump(direction)
            end
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay = 250,
                window = {
                    border = "rounded",
                    winblend = 0
                }
            },
            trigger = {
                prefetch_on_insert = true,
                show_on_keyword = true,
                show_on_insert = true
            },
            accept = {
                create_undo_point = true
            }
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = {'lsp', 'path', 'snippets', 'buffer'}
        }
    },
    opts_extend = {"sources.default"}
}
