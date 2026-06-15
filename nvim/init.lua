vim.pack.add{
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
	{ src = 'https://github.com/nvim-telescope/telescope.nvim' },
	{ src = 'https://github.com/nvim-lua/plenary.nvim' },
}

require('mason').setup()
require('mason-lspconfig').setup()
local builtin = require('telescope.builtin')

vim.opt["tabstop"]=4
vim.opt["shiftwidth"]=4

vim.keymap.set('n', '<leader>ev', ':e $MYVIMRC<CR>', { desc = 'Edit init.lua' })
vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files({ hidden = true, no_ignore = true })
end, { desc = 'Telescope find files including hidden' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.wo.number=true
