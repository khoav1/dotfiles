local lsp = vim.lsp
local map = vim.keymap.set

-- consistent behaviours across language servers
lsp.config("*", {
    on_attach = function(client, bufnr)
        lsp.semantic_tokens.enable(false)
        lsp.inlay_hint.enable(true)
        lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
        vim.diagnostic.config { virtual_text = true, underline = true }

        -- mappings.
        -- see `:help vim.lsp.*` for documentation on any of the below functions
        map("n", "gi", lsp.buf.implementation)
        map("n", "gr", lsp.buf.references)
        map("n", "gR", lsp.buf.rename)
        map("n", "ga", lsp.buf.code_action)
    end,
    detached = true,
})

-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can be applied too
require "me.lsp.clangd"
require "me.lsp.tsserver"
require "me.lsp.pylsp"
require "me.lsp.luals"

-- can be disabled by `:lua vim.lsp.enable("tsserver", false)` for example
lsp.enable { "clangd", "tsserver", "pylsp", "luals" }
