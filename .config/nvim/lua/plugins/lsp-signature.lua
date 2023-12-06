return {
  "ray-x/lsp_signature.nvim",
  event = "InsertEnter",
  config = function()
    local cfg = {} -- add your config here
    require "lsp_signature".setup(cfg)
  end
}
