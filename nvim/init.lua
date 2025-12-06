local autocmd = vim.api.nvim_create_autocmd
local user_command = vim.api.nvim_create_user_command
local set = vim.opt
local cmd = vim.cmd
local map = vim.keymap.set
local log = vim.log.levels
local notify = vim.notify
local fn = vim.fn
local lsp = vim.lsp

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

set.termguicolors = false
cmd.colorscheme("retrobox")
set.swapfile = true
set.showmatch = true
set.ignorecase = true
set.smartcase = true
set.splitbelow = true
set.splitright = true
set.updatetime = 256
set.timeoutlen = 512
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.expandtab = true
set.shiftround = true
set.relativenumber = true
set.undofile = true
set.title = true
set.visualbell = true
set.showbreak = "+++ "
set.list = true

-- close some windows quicker using `q` instead of typing :q<CR>
autocmd("FileType", {
    pattern = { "help", "qf", "messages", "checkhealth" },
    callback = function() map("n", "q", cmd.quit, { buffer = 0 }) end
})
-- open the quickfix window whenever a qf command is executed
autocmd("QuickFixCmdPost", {
    pattern = "[^l]*",
    callback = function() cmd.cwindow() end
})
-- know what has been yanked
autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.hl.on_yank { higroup = "IncSearch", timeout = 128, silent = true }
    end
})
-- generate tags in the background
user_command("Tags", function()
    if vim.fn.executable("ctags") == 0 then
        notify("no ctags installation found", log.WARN)
        return
    end
    local job = vim.system({ "ctags", "--tag-relative=never", "-G", "-R", "." }, { text = true })
    notify("generate tags..., pid: " .. job.pid, log.INFO)
end, { nargs = 0 })

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
        notify("no file matches", log.WARN)
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

-- consistent behaviours across language servers
lsp.config("*", {
    on_attach = function(client, bufnr)
        lsp.semantic_tokens.enable(false)
        lsp.inlay_hint.enable(true)
        lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
        vim.diagnostic.config { virtual_text = true, underline = true }
        -- mappings.
        -- see `:help vim.lsp.*` for documentation on any of the below functions
        map("n", "gi", lsp.buf.implementation)
        map("n", "gr", lsp.buf.references)
        map("n", "gR", lsp.buf.rename)
        map("n", "ga", lsp.buf.code_action)
    end,
    detached = true,
})
-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can be applied too
vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git/" }
})
vim.lsp.config("pylsp", {
    cmd = { "pylsp" },
    filetypes = { "python" },
    -- root_markers = {
    --   "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt",
    --   "Pipfile", "pyrightconfig.json", ".git"
    -- },
    root_dir = vim.uv.cwd(),
    settings = {
        pylsp = {
            plugins = { pycodestyle = { ignore = { "W391" }, maxLineLength = 150 } }
        }
    }
})
vim.lsp.config("tsserver", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "typescript" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    init_options = { hostInfo = "neovim" },
})
-- can be disabled by `:lua vim.lsp.enable("tsserver", false)` for example
lsp.enable { "gopls", "pylsp", "tsserver" }
