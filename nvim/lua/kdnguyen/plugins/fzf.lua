if vim.fn.has("mac") > 0 then
    vim.opt.rtp:append("/opt/homebrew/opt/fzf")
end

vim.g.fzf_layout = { down = "41%" }
vim.g.fzf_vim = { preview_window = { "right,41%,<70(up,41%)" } }

vim.keymap.set("n", "<Space>ff", vim.cmd.Files)
vim.keymap.set("n", "<Space>fw", [[:let @+=expand('<cword>') \| Files<CR>]])
vim.keymap.set("n", "<Space>b", vim.cmd.Buffers)
vim.keymap.set("n", "<Space>m", vim.cmd.Marks)
vim.keymap.set("n", "<Space>j", vim.cmd.Jumps)
