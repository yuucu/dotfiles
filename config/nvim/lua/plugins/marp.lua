return {
  {
    'nwiizo/marp.nvim',
    ft = 'markdown',
    config = function()
      require('marp').setup({
        marp_command = 'npx @marp-team/marp-cli@latest',
        browser = nil,
        server_mode = false,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          local opts = { buffer = true, silent = true }
          vim.keymap.set('n', '<leader>mw', ':MarpWatch<CR>', vim.tbl_extend('force', opts, { desc = 'Marp Watch' }))
          vim.keymap.set('n', '<leader>ms', ':MarpStop<CR>', vim.tbl_extend('force', opts, { desc = 'Marp Stop' }))
          vim.keymap.set('n', '<leader>me', ':MarpExport<CR>', vim.tbl_extend('force', opts, { desc = 'Marp Export' }))
          vim.keymap.set('n', '<leader>mt', ':MarpTheme<CR>', vim.tbl_extend('force', opts, { desc = 'Marp Theme' }))
        end,
      })
    end,
  },
}
