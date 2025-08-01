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
--
--
-- START LSP key bindings
-- Jump to the definition of the word under your cursor.
--  This is where a variable was first declared, or where a function is defined, etc.
--  To jump back, press <C-t>.
-- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
--
-- -- Find references for the word under your cursor.
-- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--
-- -- Jump to the implementation of the word under your cursor.
-- --  Useful when your language has ways of declaring types without an actual implementation.
-- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
--
-- -- Jump to the type of the word under your cursor.
-- --  Useful when you're not sure what type a variable is and you want to see
-- --  the definition of its *type*, not where it was *defined*.
-- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
--
-- -- Fuzzy find all the symbols in your current document.
-- --  Symbols are things like variables, functions, types, etc.
-- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--
-- -- Fuzzy find all the symbols in your current workspace.
-- --  Similar to document symbols, except searches over your entire project.
-- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--
-- -- Rename the variable under your cursor.
-- --  Most Language Servers support renaming across files, etc.
-- map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--
-- -- Execute a code action, usually your cursor needs to be on top of an error
-- -- or a suggestion from your LSP for this to activate.
-- map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
--
-- -- WARN: This is not Goto Definition, this is Goto Declaration.
-- --  For example, in C this would take you to the header.
-- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--
-- END LSP custom key bindings

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
-- require('custom.plugins.ezmarks').setup()
return {
  { 'tpope/vim-fugitive' }, -- :Git command for running git
  { 'tpope/vim-rhubarb' }, -- :GBrowse to open remote git url
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
    },
  },
  {
    'folke/snacks.nvim', -- managing scratch buffers
    ---@type snacks.Config
    keys = {
      {
        '<leader>.',
        function()
          Snacks.scratch()
        end,
        desc = 'Toggle Scratch Buffer',
      },
      {
        '<leader>sS',
        function()
          Snacks.scratch.select()
        end,
        desc = 'Select Scratch Buffer',
      },
    },
    opts = {
      scratch = {
        -- your scratch configuration comes here
        -- or leave it empty to use the default settings
      },
    },
  },
}
