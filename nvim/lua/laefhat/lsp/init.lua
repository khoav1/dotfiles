vim.lsp.config("*", {
    on_attach = function(client, bufnr)
        vim.lsp.inlay_hint.enable(true)
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
        vim.diagnostic.config { virtual_text = true, underline = true }

        -- mappings.
        -- see `:help vim.lsp.*` for documentation on any of the below functions
        -- lsp navigation keymaps, use default wherever possible
        vim.keymap.set("n", "<Space>xx", function()
            vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR }
        end)
    end,
    detached = true,
})

require("laefhat.lsp.clangd")
require("laefhat.lsp.zls")
require("laefhat.lsp.tsserver")
require("laefhat.lsp.pylsp")

-- can be disabled by `:lua vim.lsp.enable("tsserver", false)` for example
vim.lsp.enable({ "clangd", "zls", "tsserver", "pylsp" })
