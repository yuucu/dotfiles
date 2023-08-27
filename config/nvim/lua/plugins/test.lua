return {
    "olexsmir/gopher.nvim",
    cond = false,
    ft = "go",
    config = function()
        require("gopher").setup()
    end
}
