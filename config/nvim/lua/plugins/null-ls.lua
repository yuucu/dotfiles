return {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        local null_ls = require('null-ls')
        local sources = {
            null_ls.builtins.diagnostics.cspell.with({
                diagnostics_postprocess = function(diagnostic)
                    -- レベルをWARNに変更（デフォルトはERROR）
                    diagnostic.severity = vim.diagnostic.severity["WARN"]
                end,
                condition = function()
                    -- cspellが実行できるときのみ有効
                    return vim.fn.executable('cspell') > 0
                end,
                -- 起動時に設定ファイル読み込み
                extra_args = { '--config', '~/.config/cspell/cspell.json' }
            }),
            null_ls.builtins.diagnostics.hadolint,
            null_ls.builtins.formatting.terraform_fmt,
            null_ls.builtins.diagnostics.terraform_validate,
            null_ls.builtins.formatting.stylua,
        }
        null_ls.setup({
            sources = sources,
        })
    end,
    dependencies = {
        "mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { "hadolint" })
        end,
    },
}
