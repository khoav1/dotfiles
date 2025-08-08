-- keep things simple, only essential/useful ones
vim.pack.add({
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/tpope/vim-surround" },
    { src = "https://github.com/mhinz/vim-signify" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})
-- prefer separate config per plugin
require("kdnguyen.plugins.treesitter")
