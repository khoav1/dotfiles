-- set default regexp engine to nfa
vim.opt.regexpengine = 2
-- don't want to clutter disk, haven't thought about any usages for this
vim.opt.swapfile = true
-- see the matching bracket
vim.opt.showmatch = true
-- only override the 'ignorecase' option if the search pattern contains upper case characters
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- preferred split behaviour, easier when looking for a new pop-up
vim.opt.splitbelow = true
vim.opt.splitright = true
-- faster update
vim.opt.updatetime = 100
-- default indentation, can be overriden by ftplugin
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftround = true
-- disables editor background
vim.cmd.colorscheme("unokai")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- save change history to files in undodir
vim.opt.undofile = true
-- don't like fold, but it's the default in neovim now
vim.opt.foldenable = false
-- change titlestring for better recognition
vim.opt.title = true
-- don't like beeping
vim.opt.visualbell = true
-- show invisible characters explicitly
vim.opt.list = true
vim.opt.showbreak = "+++ "
-- don't load external providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
-- enable an experimental interface which is intended to replace the message grid in the tui.
require("vim._extui").enable({ enable = true, msg = { target = "cmd" } })
