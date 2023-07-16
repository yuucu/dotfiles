-- Git related plugins
return {
    {
        'tpope/vim-fugitive',
        event = { "BufReadPre", "BufNewFile" },
        -- event = "VeryLazy",
        keys = {
            { "git", mode = "c", "<cmd>Git<cr>", desc = "OpenGit" },
        },
        dependencies =
        {
            'tpope/vim-rhubarb',
        },
    },
}
