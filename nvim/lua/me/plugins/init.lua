-- keep things simple, only essential/useful ones
vim.pack.add {
    "https://github.com/junegunn/fzf.vim",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/tpope/vim-surround",
    "https://github.com/mhinz/vim-signify",
    "https://github.com/github/copilot.vim",
}

-- prefer separate config per plugin
require "me.plugins.fzf"
