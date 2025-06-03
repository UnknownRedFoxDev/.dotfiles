require("unknownredfoxo.lazy")
require("unknownredfoxo.remap")
vim.cmd.set("relativenumber")

local telescope = require('telescope')
telescope.setup {
	pickers = {find_files = {hidden = true}}
}
