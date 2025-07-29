-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- Custom commands
-- Line number toggle
vim.wo.relativenumber = true
vim.keymap.set('n', '<leader>t', function()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
  else
    vim.wo.relativenumber = true
  end
end, { desc = 'Toggle relative line numbering' })

vim.keymap.set('n', '<leader>n', ':Neotree toggle<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>x', ':vsplit | terminal<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.opt.swapfile = false

-- Copy file path into clipboard
vim.keymap.set('n', '<leader>cp', function()
  -- Get the file path relative to the current working directory (project root)
  local relative_path = vim.fn.expand '%:.'
  -- Copy to the system clipboard (using the '+' register)
  vim.fn.setreg('+', relative_path)
  print('Copied relative path: ' .. relative_path)
end, { desc = 'Copy file path relative to project root' })

-- NOTE: All LSP configuration has been moved to lua/custom/plugins/lsp.lua

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
-- require('custom.plugins.ezmarks').setup()
return {}
