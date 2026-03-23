return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require("nvim-treesitter.config").setup({
            highlight = { enable = true },
            indent = { enable = true },
            autotag = { enabled = true },
            ensure_installed = {
                'c',
                'cpp',
                'json',
                'lua',
                'tsx',
                'typescript',
                'python',
                'rust',
            },
            auto_install = false,
        })
    end,
}
