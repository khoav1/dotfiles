local setlocal = vim.opt_local
setlocal.shiftwidth = 4
setlocal.tabstop = 4
setlocal.softtabstop = 4
setlocal.expandtab = true
-- cmake
if vim.fn.findfile("CMakeLists.txt", ".;") ~= "" then
    setlocal.makeprg = "cmake -S %:p:h -B build && cmake --build build"
    setlocal.errorformat = "%f:%l:%c: %m"
end
