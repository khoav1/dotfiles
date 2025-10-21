local map = vim.keymap.set
local g = vim.g
local cmd = vim.cmd
local set = vim.opt
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- set runtime path to include fzf
set.runtimepath = set.runtimepath + "~/.fzf"
g.fzf_layout = { down = "41%" }
g.fzf_vim = { preview_window = { "right,41%,<70(up,41%)" } }

map("n", "<Space>f", cmd.Files)
map("n", "<Space>F", [[:let @+=expand('<cword>') | Files<CR>]])
map("n", "<Space>b", cmd.Buffers)

autocmd("FileType", {
    pattern = "fzf",
    group = augroup("custom_fzf", { clear = true }),
    callback = function()
        set.laststatus = 0
        set.showmode = false
        set.ruler = false
        autocmd("BufLeave", {
            buffer = 0,
            callback = function()
                set.laststatus = 2
                set.showmode = true
                set.ruler = true
            end
        })
    end
})
