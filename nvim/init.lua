require "me.options"
require "me.keymaps"
require "me.lsp"
require "me.plugins"

local autocmd = vim.api.nvim_create_autocmd
local user_command = vim.api.nvim_create_user_command
local map = vim.keymap.set
local cmd = vim.cmd
local log = vim.log.levels
local notify = vim.notify

-- close some windows quicker using `q` instead of typing :q<CR>
autocmd("FileType", {
    pattern = { "help", "qf", "messages", "checkhealth" },
    callback = function()
        map("n", "q", cmd.quit, { buffer = 0 })
    end
})

-- open the quickfix window whenever a qf command is executed
autocmd("QuickFixCmdPost", {
    pattern = "[^l]*",
    callback = function() cmd.cwindow() end
})

-- know what has been yanked
autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.hl.on_yank { higroup = "IncSearch", timeout = 128, silent = true }
    end
})

-- generate tags in the background
user_command("Tags", function()
    if vim.fn.executable("ctags") == 0 then
        notify("no ctags installation found", log.WARN)
        return
    end
    local job = vim.system({ "ctags", "--tag-relative=never", "-G", "-R", "." }, { text = true })
    notify("generate tags..., pid: " .. job.pid, log.INFO)
end, { nargs = 0 })
