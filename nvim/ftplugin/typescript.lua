local setlocal = vim.opt_local
setlocal.shiftwidth = 2
setlocal.tabstop = 2
setlocal.softtabstop = 2
setlocal.expandtab = true

-- node
if vim.fn.findfile("package.json", ".;") ~= "" then
    setlocal.makeprg = "npm run build"
end
