-- unify command mode keys with shell
vim.keymap.set("c", "<c-a>", "<home>")
vim.keymap.set("c", "<c-e>", "<end>")
vim.keymap.set("c", "<m-bs>", "<c-w>")
vim.keymap.set("c", "<m-left>", "<c-left>")
vim.keymap.set("c", "<m-right>", "<c-right>")

-- extend vim grep abilities with ripgrep, result can be accessible through qf list
if vim.fn.executable("rg") > 0 then
    vim.opt.grepprg = "rg --vimgrep --smart-case --no-heading --column"
    vim.opt.grepformat:prepend("%f:%l:%c:%m")
    vim.keymap.set("n", "<space>gg", [[:silent grep! --fixed-strings ''<left>]])
    vim.keymap.set("v", "<space>gg", [["0y:silent grep! --case-sensitive --fixed-strings '<c-r>0'<left>]])
    vim.keymap.set("n", "<space>gw", [[:silent grep! --case-sensitive --fixed-strings '<c-r><c-w>'<cr>]])
    vim.keymap.set("n", "<space>/", [[:silent grep! --hidden --no-ignore --fixed-strings ''<left>]])
end

-- some proper ways to browse/search stuff
vim.keymap.set("v", "//", [["0y/\V<c-r>=escape(@0,'/\')<cr><cr>]])
vim.keymap.set("n", "<space>e", ":e %:h<c-z>")
vim.keymap.set("n", "<space>b", ":b <c-z>")

-- replace word/marked text
vim.keymap.set("n", "<space>r", [[:%s/<c-r><c-w>//gI<left><left><left>]])
vim.keymap.set("v", "<space>r", [["0y:%s/<c-r>=escape(@0,'/\')<cr>//gI<left><left><left>]])

-- copy to system clipboard, all motions after `<space>y` work the same as normal `y`
vim.keymap.set({ "n","v" }, "<space>y", [["+y]])
vim.keymap.set({ "n","v" }, "<space>p", [["+p]])
vim.keymap.set("n", "<space>P", [["+P]])

-- better keymap to toggle netrw
vim.keymap.set("n", "-", vim.cmd.Explore)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function(e) vim.keymap.set("n", "<c-c>", vim.cmd.Rexplore, { buffer = 0 }) end
})

-- -- minimal fuzzy files finding using rigrep
-- local files_cmd = "rg --files --hidden --follow --glob '!.git' | grep -i "
-- vim.api.nvim_create_user_command("Files", function(opts)
--     local pattern = opts.args
--     if vim.fn.filereadable(pattern) > 0 then
--         vim.cmd.edit(vim.fn.fnameescape(pattern))
--         return
--     end
--     local files = vim.fn.systemlist(files_cmd .. vim.fn.shellescape(pattern))
--     if #files > 0 and vim.fn.filereadable(files[1]) > 0 then
--         vim.cmd.edit(vim.fn.fnameescape(files[1]))
--     else
--         vim.notify("no file matches", vim.log.levels.WARN)
--     end
-- end, { nargs = "*", complete = function(arg_lead, _, _)
--         return vim.fn.systemlist(files_cmd .. vim.fn.shellescape(arg_lead))
--     end })
-- vim.keymap.set("n", "<space>ff", [[:Files ]])
-- vim.keymap.set("n", "<space>fw", [[:Files <c-r><c-w>]])
