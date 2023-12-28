-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
function Map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
Map("n", "<leader>fs", ":w<CR>", { desc = "Save the current file", silent = true })
Map("i", "ii", "<esc>", { desc = "Exit insert mode", silent = true })
Map("n", "<leader>bn", ":bn<CR>", { desc = "Save the current file", silent = true })

-- local cmp = require("cmp")
-- cmp.setup({
--   mapping = {
--     ["<Tab>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
--   },
-- })
