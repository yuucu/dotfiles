-- Git related plugins
return {
  {
    'tpope/vim-fugitive',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = function()
      return not vim.g.vscode
    end,
    dependencies = {
      'tpope/vim-rhubarb',
    },
    config = function()
      -- vim-rhubarb does not recognize ssh://<user>@<host>.ghe.com remotes.
      -- Convert only the URL passed to :GBrowse; Git fetch/push stays unchanged.
      vim.cmd([[
        function! DotfilesGheComBrowse(opts) abort
          if type(a:opts) != type({})
            return ''
          endif

          let remote = get(a:opts, 'remote', '')
          let match = matchlist(remote, '^ssh://[^@/]\+@\([^/]\+\.ghe\.com\)/')
          if empty(match)
            return ''
          endif

          let enterprise_url = 'https://' . match[1]
          let enterprise_urls = get(g:, 'github_enterprise_urls', [])
          if type(enterprise_urls) != type([])
            let enterprise_urls = []
          endif
          if index(enterprise_urls, enterprise_url) < 0
            call add(enterprise_urls, enterprise_url)
            let g:github_enterprise_urls = enterprise_urls
          endif

          let browse_opts = extend(copy(a:opts), {
                \ 'remote': substitute(remote, '^ssh://[^@/]\+@', 'https://', '')})
          return rhubarb#FugitiveUrl(browse_opts)
        endfunction

        if !exists('g:dotfiles_ghe_com_browse_handler_installed')
          call insert(g:fugitive_browse_handlers, function('DotfilesGheComBrowse'))
          let g:dotfiles_ghe_com_browse_handler_installed = 1
        endif
      ]])
    end,
  },
}
