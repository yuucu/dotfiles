return {
    {
        'tyru/open-browser-github.vim',
        lazy = true,
        cmd = {
            "OpenGithubFile",
            "OpenGithubIssue",
            "OpenGithubPullReq",
            "OpenGithubProject",
        },
        dependencies = {
            {
                'tyru/open-browser.vim',
                lazy = true,
            },
        },
    },
}
