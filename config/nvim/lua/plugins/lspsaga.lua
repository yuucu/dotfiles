return {
  'nvimdev/lspsaga.nvim',
  -- cond = false,
  event = { "BufReadPre", "BufNewFile" },
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    require("lspsaga").setup({
      ui = {
        title = false,
        border = "single",
      },
      symbol_in_winbar = {
        enable = true,
        priority = 1000,
      },
      code_action_lightbulb = {
        enable = true,
      },
      show_outline = {
        win_width = 50,
        auto_preview = false,
      },
    })

    local keymap = vim.keymap.set
    -- LSP finder - Find the symbol's definition
    -- If there is no definition, it will instead be hidden
    -- When you use an action in finder like "open vsplit",
    -- you can use <C-t> to jump back
    keymap("n", "gh", "<cmd>Lspsaga finder<CR>")

    keymap({ "n", "v" }, "ga", "<cmd>Lspsaga code_action<CR>")

    -- Peek definition
    -- You can edit the file containing the definition in the floating window
    -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
    -- It also supports tagstack
    -- Use <C-t> to jump back
    keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>")

    -- Go to definition
    -- keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>")

    -- Show line diagnostics
    -- You can pass argument ++unfocus to
    -- unfocus the show_line_diagnostics floating window
    keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

    -- Show buffer diagnostics
    keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

    -- Show workspace diagnostics
    keymap("n", "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")

    -- Show cursor diagnostics
    keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

    -- Diagnostic jump
    -- You can use <C-o> to jump back to your previous location
    keymap("n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>")
    keymap("n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>")

    -- Toggle outline
    keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>")

    -- Hover Doc
    -- If there is no hover doc,
    -- there will be a notification stating that
    -- there is no information available.
    -- To disable it just use ":Lspsaga hover_doc ++quiet"
    -- Pressing the key twice will enter the hover window
    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

    -- If you want to keep the hover window in the top right hand corner,
    -- you can pass the ++keep argument
    -- Note that if you use hover with ++keep, pressing this key again will
    -- close the hover window. If you want to jump to the hover window
    -- you should use the wincmd command "<C-w>w"
    keymap("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")

    -- Call hierarchy
    keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
    keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

    keymap("n", "<Leader>t", "<cmd>Lspsaga term_toggle<CR>")
  end,
}
