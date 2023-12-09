return {
  "ggandor/leap.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- makes some plugins dot-repeatable like leap
    { "tpope/vim-repeat", event = "VeryLazy" },
  },
  config = function(_, opts)
    require('leap').add_default_mappings()
    vim.keymap.del({ 'x', 'o' }, 'x')
    vim.keymap.del({ 'x', 'o' }, 'X')

    vim.keymap.set('n', 's', function()
      local current_window = vim.fn.win_getid()
      require('leap').leap { target_windows = { current_window } }
    end)

    -- The below settings make Leap's highlighting closer to what you've been
    -- used to in Lightspeed.
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' }) -- or some grey
    vim.api.nvim_set_hl(0, 'LeapMatch', {
      -- For light themes, set to 'black' or similar.
      fg = 'white',
      bold = true,
      nocombine = true,
    })

    -- Lightspeed colors
    -- primary labels: bg = "#f02077" (light theme) or "#ff2f87"  (dark theme)
    -- secondary labels: bg = "#399d9f" (light theme) or "#99ddff" (dark theme)
    -- shortcuts: bg = "#f00077", fg = "white"
    -- You might want to use either the primary label or the shortcut colors
    -- for Leap primary labels, depending on your taste.
    vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
      fg = 'red', bold = true, nocombine = true,
    })
    vim.api.nvim_set_hl(0, 'LeapLabelSecondary', {
      fg = 'blue', bold = true, nocombine = true,
    })
    -- Try it without this setting first, you might find you don't even miss it.
    require('leap').opts.highlight_unlabeled_phase_one_targets = true
  end,
}
