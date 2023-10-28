return {
  "ray-x/navigator.lua",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require 'navigator'.setup({
      lsp = {
        format_on_save = false,
      }
    })
  end
}
