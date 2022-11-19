-- My preferred leader key is the spacebar
vim.g.mapleader = ' '

-- Extension opening thingies
local kbs = { noremap=true, silent=true }
vim.keymap.set('n', '<Leader>D', '<cmd>TroubleToggle<cr>', bs)
vim.keymap.set('n', '<Leader>nt', '<cmd>NvimTreeToggle<cr>', bs)

local ts = require('telescope.builtin')
vim.keymap.set('n', '<Leader-t>f', ts.find_files, kbs)
vim.keymap.set('n', '<Leader-t>g', ts.git_files, kbs)
vim.keymap.set('n', '<Leader-t>s', ts.treesitter, kbs)

vim.keymap.set('n', '<Leader>lg', '<cmd>LazyGit<cr>', kbs)

-- LSP attachment binds for anything but rust analyzer
function on_attach(client, bufnr)
    local bs = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', '<Leader-d>c', vim.lsp.buf.declaration, bs)
    vim.keymap.set('n', '<Leader>h', vim.lsp.buf.hover, bs)
    vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, bs)
    vim.keymap.set('n', '<Leader-r>n', vim.lsp.buf.rename, bs)
    vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format { async = true } end, bs)
end

-- LSP attachment binds for rust analyzer
function rust_on_attach(_, bufnr)
    local rt = require('rust-tools')
    local bs = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', '<Leader-d>c', vim.lsp.buf.declaration, bs)
    vim.keymap.set('n', '<Leader-r>n', vim.lsp.buf.rename, bs)
    vim.keymap.set('n', '<Leader>h', rt.hover_actions.hover_actions, bs)
    vim.keymap.set('n', '<Leader>a', rt.code_action_group.code_action_group, bs)
    vim.keymap.set('n', '<Leader-r>c', rt.open_cargo_toml.open_cargo_toml, bs)
    vim.keymap.set('n', '<Leader-r>m', rt.expand_macro.expand_macro, bs)
    vim.keymap.set('n', '<Leader-r>Up', '<cmd>RustMoveItemUp<cr>', bs)
    vim.keymap.set('n', '<Leader-r>Down', '<cmd>RustMoveItemDown<cr>', bs)
    vim.keymap.set('n', '<Leader-r>d', rt.debuggables.debuggables, bs)
end
