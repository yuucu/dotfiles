return {
  "nvim-neotest/neotest",
  -- optional = true,
  dependencies = {
    "nvim-neotest/neotest-go",
  },
  opts = {
    adapters = {
      ["neotest-go"] = {
        -- Here we can set options for neotest-go, e.g.
        -- args = { "-tags=integration" }
      },
    },
  },
}
