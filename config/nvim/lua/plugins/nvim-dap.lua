return {
  "mfussenegger/nvim-dap",
  -- optional = true,
  dependencies = {
    {
      "mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "delve")
      end,
    },
  },
}
