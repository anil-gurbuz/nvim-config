local plugin = {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = {
        "zbirenbaum/copilot-cmp",
    },
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = "<C-k>",
                    accept_word = false,
                    accept_line = false,
                    next = "<C-l>",
                    prev = "<C-H>",
                    dismiss = "<C-]>",
                },
            },
            panel = {
                enabled = false,
            },
            filetypes = {
                markdown = true,
                help = true,
            },
        })
        
        -- Setup copilot-cmp
        require("copilot_cmp").setup()
    end,
}

return plugin
