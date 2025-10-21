local set = vim.opt
local cmd = vim.cmd
-- don't want to clutter disk, haven't thought about any usages for this
set.swapfile = true
-- see the matching bracket
set.showmatch = true
-- only override the 'ignorecase' option if the search pattern contains upper case characters
set.ignorecase = true
set.smartcase = true
-- preferred split behaviour, easier when looking for a new pop-up
set.splitbelow = true
set.splitright = true
-- faster update
set.updatetime = 256
set.timeoutlen = 512
-- default indentation, can be overriden by ftplugin
set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 2
set.expandtab = true
set.shiftround = true
-- save change history to files in undodir
set.undofile = true
-- change titlestring for better recognition
set.title = true
-- don't like beeping
set.visualbell = true
-- colors
cmd.colorscheme "retrobox"
set.termguicolors = false
-- show invisible characters explicitly
set.list = true
set.showbreak = "+++ "
-- don't load external providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
