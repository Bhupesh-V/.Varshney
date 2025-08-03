return {
    'junegunn/fzf.vim',
    dependencies = {'junegunn/fzf'},
    lazy = false, -- Load lazily
    -- check https://github.com/junegunn/fzf.vim
    cmd = {'FZF', 'FZFPreview', 'FZFPreviewFile', 'FZFPreviewBuffer', 'FZFPreviewGrep'},
}
