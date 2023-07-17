return {
    "ray-x/lsp_signature.nvim",
    config = function()
        local cfg = {} -- add your config here
        require "lsp_signature".setup(cfg)
    end
}
