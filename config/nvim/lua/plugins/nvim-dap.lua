return {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "mfussenegger/nvim-dap",
    },
    config = function()
        require('dap-go').setup()
        require('dapui').setup()
        require("nvim-dap-virtual-text").setup()


        -- keymaps
        vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>", { silent = true })
        vim.keymap.set("n", "<F10>", ":lua require'dap'.step_over()<CR>", { silent = true })
        vim.keymap.set("n", "<F11>", ":lua require'dap'.step_into()<CR>", { silent = true })
        vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>", { silent = true })

        vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
        vim.keymap.set("n", "<leader>d", ":lua require'dapui'.toggle()<CR>", { silent = true })
        vim.keymap.set("n", "<leader><leader>df", ":lua require'dapui'.eval()<CR>", { silent = true })
    end

}
