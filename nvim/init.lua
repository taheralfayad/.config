-- installed packages
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

-- mason setup
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"prettier",
		"svelte-language-server",
		"golangci-lint",
		"gopls",
		"tailwindcss-language-server"
	},
})

-- lsp config
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})
vim.lsp.enable({ "gopls", "svelte-language-server", "tailwindcss-language-server", "html" })
vim.lsp.inlay_hint.enable(true)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
		end
	end,
})

-- telescope
local builtin = require("telescope.builtin")

-- visuals
vim.cmd.colorscheme("kanagawa")
vim.wo.number = true
vim.g.vim_svelte_plugin_use_typescript = 1
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { current_line = true },
})

vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.o.autocomplete = true

-- whitespace
vim.opt["tabstop"] = 4
vim.opt["shiftwidth"] = 4

-- keymaps
vim.keymap.set("n", "<leader>ev", ":e $MYVIMRC<CR>", { desc = "Edit init.lua" })
vim.keymap.set("n", "<leader>ff", function()
	builtin.find_files()
end, { desc = "Telescope find files including hidden" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>th", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
vim.keymap.set("i", "<leader>c", function()
	vim.lsp.completion.get()
end, { desc = "Trigger LSP completion" })

-- autoimport missing imports
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
		for _, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
				else
					vim.lsp.buf.execute_command(r.command)
				end
			end
		end
	end,
})
