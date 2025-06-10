vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", vim.cmd.w)
vim.keymap.set("n", "<leader>q", vim.cmd.q)

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gg", vim.cmd.LazyGit)
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope fuzzy find git files' })
vim.keymap.set('n', '<leader>fs', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
vim.keymap.set("n", "[d", vim.cmd.cprev)
vim.keymap.set("n", "]d", vim.cmd.cnext)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, {})
