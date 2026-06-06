vim.pack.add{
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
}

require('mason').setup()
require('mason-lspconfig').setup()

vim.opt["tabstop"]=4
vim.opt["shiftwidth"]=4

vim.keymap.set('n', '<leader>ev', ':e $MYVIMRC<CR>', { desc = 'Edit init.lua' })
