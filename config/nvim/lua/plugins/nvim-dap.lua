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
        require("nvim-dap-virtual-text").setup()
        local dapui = require('dapui')
        local dap = require('dap')
        dapui.setup()
        dap.configurations.go = {
            {
                type = 'go',
                name = 'debug',
                request = 'launch',
                program = "${file}",
            },
            {
                type = 'go',
                name = 'run_mep',
                request = 'launch',
                program = "${file}",
                env = {
                    STORAGE_EMULATOR_HOST = "localhost:4443",
                    PUBSUB_EMULATOR_HOST  = "localhost:8681",
                    SPANNER_EMULATOR_HOST = "localhost:9010",
                    APP_ENV               = "local"
                },
            },
        }
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

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
