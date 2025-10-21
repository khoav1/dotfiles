require "me.options"
require "me.keymaps"
require "me.lsp"
require "me.plugins"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local user_command = vim.api.nvim_create_user_command
local map = vim.keymap.set
local cmd = vim.cmd
local log = vim.log.levels
local notify = vim.notify

-- close some windows quicker using `q` instead of typing :q<CR>
autocmd("FileType", {
    pattern = { "help", "qf", "messages", "checkhealth" },
    group = augroup("quick_quit", { clear = true }),
    callback = function() map("n", "q", cmd.quit, { buffer = 0 }) end
})

-- open the quickfix window whenever a qf command is executed
autocmd("QuickFixCmdPost", {
    pattern = "[^l]*",
    group = augroup("qf_post_cmd_open", { clear = true }),
    callback = function() cmd.cwindow() end
})

-- know what has been yanked
autocmd("TextYankPost", {
    pattern = "*",
    group = augroup("hl_on_yank", { clear = true }),
    callback = function() vim.hl.on_yank { higroup = "Visual", timeout = 128, silent = true } end
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
