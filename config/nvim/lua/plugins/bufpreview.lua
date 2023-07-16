return {
    'kat0h/bufpreview.vim',
    build = 'deno task prepare',
    ft = {
        "markdown",
    },
    dependencies = {
        'vim-denops/denops.vim'
    }
}
