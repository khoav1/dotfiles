local map = vim.keymap.set
local set = vim.opt
local autocmd = vim.api.nvim_create_autocmd
local user_command = vim.api.nvim_create_user_command
local cmd = vim.cmd
local fn = vim.fn
-- extend vim grep abilities with ripgrep, result can be accessible through qf list
if vim.fn.executable("rg") > 0 then
    set.grepprg = "rg --vimgrep --smart-case --no-heading --column"
    set.grepformat:prepend("%f:%l:%c:%m")
    map("n", "<Space>g", [[:silent grep! --fixed-strings ''<Left>]])
    map("v", "<Space>g", [["0y:silent grep! --case-sensitive --fixed-strings '<C-r>0'<Left>]])
    map("n", "<Space>G", [[:silent grep! --case-sensitive --fixed-strings '<C-r><C-w>'<CR>]])
    map("n", "<Space>/", [[:silent grep! --hidden --no-ignore --fixed-strings ''<Left>]])
end
-- some proper ways to browse/search marked text
map("n", "<Space>e", [[:edit %:h<C-z>]])
map("n", "<Space>b", [[:buffer ]])
-- copy to system clipboard, all motions after `<Space>y` work the same as normal `y`
map({ "n", "v" }, "<Space>y", [["+y]])
map({ "n", "v" }, "<Space>p", [["+p]])
map("n", "<Space>P", [["+P]])
-- better keymap to toggle netrw
map("n", "-", cmd.Explore)
autocmd("FileType", {
    pattern = "netrw",
    callback = function() map("n", "<C-c>", cmd.Rexplore, { buffer = 0 }) end
})
-- simple find finder using ripgrep
local function find_complete(pattern)
    local cmd = 'rg --files --hidden --follow | grep -i ' .. fn.shellescape(pattern)
    return fn.systemlist(cmd)
end
user_command('Find',
function(opts)
    local pattern = opts.args
    if fn.filereadable(pattern) == 1 then
        cmd('edit ' .. fn.fnameescape(pattern))
        return
    end
    local files = find_complete(pattern)
    if #files == 0 then
        vim.api.nvim_echo({{'no file matches', 'WarningMsg'}}, false, {})
        return
    end
    cmd('edit ' .. fn.fnameescape(files[1]))
end, {
nargs = 1,
complete = function(arglead, cmdline, cursorpos)
    return find_complete(arglead)
end, bang = false
})
map("n", "<Space>f", [[:Find ]])
map("n", "<Space>F", [[:Find <C-r><C-w><C-z>]])
