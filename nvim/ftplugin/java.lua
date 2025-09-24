local setlocal = vim.opt_local
setlocal.shiftwidth = 4
setlocal.tabstop = 4
setlocal.softtabstop = 4
setlocal.expandtab = true

-- maven
if vim.fn.findfile("pom.xml", ".;") ~= "" then
    setlocal.makeprg = "mvn compile"
    setlocal.errorformat = "[ERROR] %f:[%l\\,%v] %m"
end
