-- autoformat.lua
--
-- Autoformatting utilities - no longer configures LSP directly
-- The formatting logic is now integrated into the main LSP configuration

-- Global formatting state
local M = {}

M.format_is_enabled = true

-- Create an augroup that is used for managing our formatting autocmds.
--  We need one augroup per client to make sure that multiple clients
--  can attach to the same buffer without interfering with each other.
local _augroups = {}
local get_augroup = function(client)
  if not _augroups[client.id] then
    local group_name = 'kickstart-lsp-format-' .. client.name
    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
    _augroups[client.id] = id
  end

  return _augroups[client.id]
end

-- Setup formatting for a client when LSP attaches
M.setup_autoformat = function(client, bufnr)
  -- Only attach to clients that support document formatting
  if not client.server_capabilities.documentFormattingProvider then
    return
  end

  -- Tsserver usually works poorly. Sorry you work with bad languages
  -- You can remove this line if you know what you're doing :)
  if client.name == 'tsserver' then
    return
  end

  -- Create an autocmd that will run *before* we save the buffer.
  --  Run the formatting command for the LSP that has just attached.
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = get_augroup(client),
    buffer = bufnr,
    callback = function()
      if not M.format_is_enabled then
        return
      end

      vim.lsp.buf.format {
        async = false,
        filter = function(c)
          return c.id == client.id
        end,
      }
    end,
  })
end

-- Setup the toggle command
M.setup_commands = function()
  vim.api.nvim_create_user_command('KickstartFormatToggle', function()
    M.format_is_enabled = not M.format_is_enabled
    print('Setting autoformatting to: ' .. tostring(M.format_is_enabled))
  end, {})
end

return M
