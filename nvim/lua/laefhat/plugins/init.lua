vim.pack.add({
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/tpope/vim-surround" },
    { src = "https://github.com/mhinz/vim-signify" },
    { src = "https://github.com/junegunn/fzf" },
    { src = "https://github.com/junegunn/fzf.vim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/ziglang/zig.vim" },
})
require("laefhat.plugins.fuzzy")
require("laefhat.plugins.treesitter")
