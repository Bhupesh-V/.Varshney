-- Toggle transparent mode (make sure this is always below colorscheme setting)
function ToggleTransparent()
    if vim.g.is_transparent == 0 then
        vim.cmd("hi Normal guibg=NONE ctermbg=NONE ctermfg=NONE guifg=NONE")
        vim.g.is_transparent = 1
    else
        vim.g.is_transparent = 0
        vim.o.background = "dark"
    end
end
vim.api.nvim_create_user_command("ToggleTransparent", ToggleTransparent, {})

-- Run command on the current line and paste its output in next line inside a markdown code block
function AddCmdOutput()
    local line_num = vim.fn.line(".")
    local cmd = vim.fn.getline(".")
    local ok, cmd_output = pcall(vim.fn.systemlist, cmd)

    if not ok or not cmd_output then
        print("Not a command")
        return
    end

    vim.fn.append(line_num, "```")
    vim.fn.append(line_num + 1, cmd_output)
    vim.fn.append(line_num + 1 + #cmd_output, "```")
end
vim.api.nvim_create_user_command("AddCmdOutput", AddCmdOutput, {})

-- Auto pair brackets and stuff
-- Helper function to eat whitespace characters
local function eatchar(pat)
    local c = vim.fn.nr2char(vim.fn.getchar(0))
    return (c:match(pat) and '') or c
end

-- Bracket pairs map
local bracket_pairs = {
    ['('] = ')',
    ['{'] = '}',
    ['['] = ']',
    ['"'] = '"',
    ["'"] = "'",
    ['`'] = '`',
    ['<'] = '>',
}

-- Set keymaps dynamically
for open, close in pairs(bracket_pairs) do
    vim.keymap.set('i', open, function()
        local _, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()

        -- Get chars before/after cursor
        local before = col > 0 and line:sub(col, col) or ''
        local after = line:sub(col + 1, col + 1)

        -- Only insert the pair if both before and after are non-whitespace chars
        if before:match('%S') or after:match('%S') then
            return open -- insert the typed char
        end
        return open .. close .. '<Left>' .. eatchar('%s')
    end, { silent = true, expr = true })
end
