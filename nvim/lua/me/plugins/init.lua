-- keep things simple, only essential/useful ones
vim.pack.add {
    "https://github.com/junegunn/fzf.vim",
    "https://github.com/mhinz/vim-signify",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
}
-- prefer separate config per plugin
require "me.plugins.fzf"
require "me.plugins.cmp"
