-- consistent behaviours across language servers
vim.lsp.config("*", {
    on_attach = function(client, bufnr)
        vim.lsp.inlay_hint.enable(true)
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
        vim.diagnostic.config { virtual_text = true, underline = true }

        -- mappings.
        -- see `:help vim.lsp.*` for documentation on any of the below functions
        -- lsp navigation keymaps, use default wherever possible
        vim.keymap.set("n", "gd", vim.lsp.buf.definition) -- better than pressing C-]
    end,
    detached = true,
})

-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can be applied too
require("kdnguyen.lsp.clangd")
require("kdnguyen.lsp.tsserver")
require("kdnguyen.lsp.pylsp")
require("kdnguyen.lsp.luals")

-- can be disabled by `:lua vim.lsp.enable("tsserver", false)` for example
vim.lsp.enable({ "clangd", "tsserver", "pylsp", "luals" })
