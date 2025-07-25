vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<C-BS>", "<C-w>")

if vim.fn.executable("rg") then
    vim.opt.grepprg = "rg --vimgrep --smart-case --no-heading --column"
    vim.opt.grepformat:prepend("%f:%l:%c:%m")
    vim.keymap.set("n", "<Space>gg", [[:silent grep! --fixed-strings ''<Left>]])
    vim.keymap.set("v", "<Space>gg", [["0y:silent grep! --case-sensitive --fixed-strings '<C-r>0'<Left>]])
    vim.keymap.set("n", "<Space>gw", [[:silent grep! --case-sensitive --fixed-strings '<C-r><C-w>'<CR>]])
    vim.keymap.set("n", "<Space>/", [[:silent grep! --hidden --no-ignore --fixed-strings ''<Left>]])
end

vim.keymap.set("v", "//", [["0y/\V<C-r>=escape(@0,'/\')<CR><CR>]])
vim.keymap.set("n", "<Space>e", ":e %:h<C-z>")

vim.keymap.set("n", "<Space>r", [[:%s/<C-r><C-w>//gI<Left><Left><Left>]])
vim.keymap.set("v", "<Space>r", [["0y:%s/<C-r>=escape(@0,'/\')<CR>//gI<Left><Left><Left>]])

vim.keymap.set({ "n","v" }, "<Space>y", [["+y]])
vim.keymap.set({ "n","v" }, "<Space>p", [["+p]])
vim.keymap.set("n", "<Space>P", [["+P]])

vim.keymap.set("n", "-", vim.cmd.Explore)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function(e) vim.keymap.set("n", "<C-c>", vim.cmd.Rexplore, { buffer = 0 }) end
})

vim.keymap.set("n", "<Space>tg", function()
    if vim.fn.executable("ctags") < 1 then
        vim.notify("no ctags installation found", vim.log.levels.WARN)
        return
    end
    local job = vim.fn.jobstart { "ctags", "--tag-relative=never", "-G", "-R", "." }
    vim.notify("generate tags..., id: " .. job, vim.log.levels.INFO)
end)
