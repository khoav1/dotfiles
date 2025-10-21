-- keep things simple, only essential/useful ones
vim.pack.add {
    "https://github.com/junegunn/fzf.vim",
    "https://github.com/mhinz/vim-signify",
}
-- prefer separate config per plugin
require "me.plugins.fzf"
