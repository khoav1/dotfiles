local map = vim.keymap.set
local g = vim.g
local cmd = vim.cmd
local set = vim.opt

-- set runtime path to include fzf
set.runtimepath = set.runtimepath + "~/.fzf"
g.fzf_layout = { down = "41%" }
g.fzf_vim = { preview_window = { "right,41%,<70(up,41%)" } }

map("n", "<Space>f", cmd.Files)
map("n", "<Space>F", [[:let @+=expand('<cword>') | Files<CR>]])
map("n", "<Space>b", cmd.Buffers)
