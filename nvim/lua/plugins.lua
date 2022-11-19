on_attach = require('keybind.on_attach')
rust_on_attach = require('keybind.rust_on_attach')

return require('packer').startup(function(use)
    -- Packer self management
    use 'wbthomason/packer.nvim'

    -- Optimizer
    use 'lewis6991/impatient.nvim'

    -- Dependency for a lot of things
    use 'nvim-lua/plenary.nvim'
    use 'nvim-tree/nvim-web-devicons'

    -- Syntax highlighting
    use 'p00f/nvim-ts-rainbow'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {  'bash', 'c', 'c_sharp', 'cmake', 'cpp', 'css', 'dart', 'go', 'html', 'javascript', 'json', 'julia', 'lua', 'markdown', 'python', 'qmljs', 'rust', 'scss','toml', 'tsx', },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                },
            }
        end
    }

    -- Keybind helper thing
    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup {}
        end
    }

    -- Commenting tool
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        config = function()
            require('telescope').setup {}
        end
    }
    -- Dressing
    use {
        'stevearc/dressing.nvim',
        config = function()
            require('dressing').setup {
                select = {
                    enabled = true,
                    backend = { 'telescope', 'builtin', },
                }
            }
        end
    }

    -- Search/replace
    use 'windwp/nvim-spectre'
    
    -- Greeter
    use {
        'goolord/alpha-nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function ()
            require('alpha').setup(require('alpha.themes.startify').config)
        end
    }

    -- Icon selector
    use {
        'ziontee113/icon-picker.nvim',
        config = function()
            require('icon-picker').setup {
                disable_legacy_commands = true
            }
        end
    }

    -- Create nonexistent directories on save
    use 'jghauser/mkdir.nvim'

    -- The objectively correct colorscheme
    use {
        'folke/tokyonight.nvim',
        config = function()
            require('tokyonight').setup { style='moon' }
        end
    }

    -- Statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup {
                options = {
            		theme = 'tokyonight',
            		component_separators = { left = '', right = ''},
		            section_separators = { left = '', right = ''},
                    ignore_focus = {
                        Trouble = {},
                        NvimTree = {},
                    },
                }
            }
        end
    }

    -- Indentation guides
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('indent-blankline').setup {
                show_current_context = true,
                show_current_context_start = true,
                show_end_of_line = true,
                space_char_blankline = " ",
            }
        end
    }

    -- Git signs
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {}
        end
    }

    -- Scrollbar
    use {
        'petertriho/nvim-scrollbar',
        config = function()
            require('scrollbar').setup {}
        end
    }

    -- Autopairs
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {
                check_ts = true,
            }
        end
    }

    -- File explorer boyo
    use {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup {
                renderer = {
                    highlight_git = true,
                }
            }
        end
    }

    -- Snippets, autocompletion
    use 'L3MON4D3/LuaSnip'
    use {
        'rafamadriz/friendly-snippets',
        config = function()
            local lsnip = require('luasnip')
            lsnip.filetype_extend('ruby', {'rails'})
            lsnip.filetype_extend('javascript', {'vue'})
        end
    }
    use {
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'saadparwaiz1/cmp_luansip',
        'hrsh7th/cmp-nvim-lsp',
        'ray-x/cmp-treesitter',
        'hrsh7th/cmp-cmdline'
    }
    use 'onsails/lspkind.nvim'
    use {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            cmp.setup {
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                sources = cmp.config.sources {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'treesitter' },
                },
                mapping = cmp.mapping.preset.insert {
                    ['<Tab>'] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                local snip = cmp.get_selected_entry()
                                if not snip then
                                    cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                                cmp.confirm()
                                end
                            else
                                fallback()
                            end
                        end, {'i', 'c'}
                    ),
                    ['<Down>'] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                            else
                                fallback()
                            end
                        end, {'i', 'c'}
                    ),
                    ['<Up>'] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
                            else
                                fallback()
                            end
                        end, {'i', 'c'}
                    ),
                    -- Documentation scrolling
                    ['<S-Down>'] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.scroll_docs(4)
                            else
                                fallback()
                            end
                        end, {'i', 'c'}
                    ),
                    ['<S-Up>'] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.scroll_docs(-4)
                            else
                                fallback()
                            end
                        end, {'i', 'c'}
                    )
                },
                window = {
                    completion = {
                        winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
                        col_offset = -3,
                        side_padding = 0
                    }
                },
                formatting = {
                    fields = { 'kind', 'abbr', 'menu' },
                    format = function(entry, vim_item)
                        local kind = require('lspkind').cmp_format { mode = 'symbol_text', maxwidth = 50 } (entry, vim_item)
                        local strings = vim.split(kind.kind, '%s', { trimempty = true })
                        kind.kind = ' ' .. strings[1] .. ' '
                        kind.menu = '    (' .. strings[2] .. ')'

                        return kind
                    end
                }
            }
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources(
                    {{ name = 'path' }},
                    {{ name = 'buffer' }},
                    {{
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }}
                ),
                view = {
                    entries = 'wildmenu'
                }
            })
        end
    }

    -- LSP + mason as installer (will also be used for DAP and null ls)
    use {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup {}
        end
    }
    use {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('mason-lspconfig').setup {
                -- DO NOT ADD TSSERVER, it is set up by the later typescript plugin. Similar for rust analyzer.
                ensure_installed = { 'als', 'bashls', 'clangd', 'omnisharp_mono', 'cmake', 'cssls', 'gopls', 'html', 'hls', 'jsonls', 'julials', 'kotlin_language_server', 'sumneko_lua', 'marksman', 'pyright', 'taplo', 'tailwindcss' }
            }
        end
    }
    use {
        'neovim/nvim-lspconfig',
        config = function()
            capabilities = require('cmp_nvim_lsp').default_capabilities()

            require('lspconfig').als.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').bashls.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').clangd.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').omnisharp_mono.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').cmake.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').cssls.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').gopls.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').html.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').hls.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').jsonls.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').julials.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').kotlin_language_server.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').sumneko_lua.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').marksman.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').pyright.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').taplo.setup { capabilities = capabilities, on_attach = on_attach }
            require('lspconfig').tailwindcss.setup { capabilities = capabilities, on_attach = on_attach }
        end
    }

    -- Debugging stuff
    use 'mfussenegger/nvim-dap'
    -- We can use this handy mason plugin to install AND automatically set up DAP adapters
    use {
        'jayp0521/mason-nvim-dap.nvim',
        config = function()
            require('mason-nvim-dap').setup {
                ensure_installed = {
                    'python',
                    'delve',
                    'lldb',
                    'bash',
                },
                automatic_setup = true
            }
        end
    }
    -- DAP interface
    use {
        'rcarriga/nvim-dap-ui',
        config = function()
            require('dapui').setup {}
        end
    }

    -- Really pretty diagnostics panel
    use {
        'folke/trouble.nvim',
        config = function()
            require('trouble').setup {}
        end
    }

    -- Inactive window dimmer
    use {
        'sunjon/shade.nvim',
        config = function()
            require('shade').setup {
                overlay_opacity = 10
            }
        end
    }

    -- Buffer tab thingamajig
    use {
        'akinsho/bufferline.nvim',
        config = function()
            require('bufferline').setup {
                separator_style = 'slant',
                numbers = 'ordinal',
                offsets = {
                    filetype = 'NvimTree',
                    text = 'File Explorer'
                }
            }
        end
    }

    -- Toggleable terminal boyo that isnt just term://
    use {
        'akinsho/toggleterm.nvim',
        config = function()
            require('toggleterm').setup {
                direction = 'vertical',
                size = 35,
                shade_terminals = true,
            }
        end
    }

    -- Colorful window separators
    use {
        'nvim-zh/colorful-winsep.nvim',
        config = function()
            require('colorful-winsep').setup {
                highlight = {
                    guifg = '#bb9af7'
                }
            }
        end,
        create_event = function()
            if fn.winnr('$') == 3 then
                local win_id = fn.win_getid(vim.fn.winnr('h'))
                local filetype = api.nvim_buf_get_option(api.nvim_win_get_buf(win_id), 'filetype')
                if filetype == "NvimTree" then
                    colorful_winsep.NvimSeparatorDel()
                end
            end
        end
    }

    -- Null ls + another mason cameo
    use {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            require('null-ls').setup {}
        end
    }
    use {
        'jayp0521/mason-null-ls.nvim',
        config = function()
            require('mason-null-ls').setup {
                automatic_setup = true,
                ensure_installed = {
                    'clang_format',
                    'csharpier',
                    'prettier',
                    'ktlint',
                    'stylua',
                    'autopep8',
                    'shellcheck',
                    'taplo',
                }
            }
        end
    }

    -- LSP signature thing
    use {
        'ray-x/lsp_signature.nvim',
        config = function()
            require('lsp_signature').setup {}
        end
    }

    -- Show colors
    use {
        'NvChad/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup {}
        end
    }

    -- Language support stuff
    use {
        'jose-elias-alvarez/typescript.nvim',
        config = function()
            require('typescript').setup {
                server = {
                    capabilities = capabilities,
                    on_attach = on_attach
                }
            }
        end
    }
    use {
        'windwp/nvim-ts-autotag',
        config = function()
            require('nvim-ts-autotag').setup {}
        end
    }
    use {
        'simrat39/rust-tools.nvim',
        config = function()
            local rt = require('rust-tools')
            rt.setup {
                server = {
                    capabilities = capabilities,
                    hover_actions = {
                       auto_focus = true,
                    },
                    on_attach = function(_, bufnr)
                        vim.keymap.set('n', '<Leader>h', rt.hover_actions.hover_actions, {buffer = bufnr})
                        vim.keymap.set('n', '<Leader>a', rt.code_action_group.code_action_group, {buffer = bufnr})
                        vim.keymap.set('n', '<Leader-r>c', rt.open_cargo_toml.open_cargo_toml, {buffer = bufnr})
                        vim.keymap.set('n', '<Leader-r>m', rt.expand_macro.expand_macro, {buffer = bufnr})
                        vim.keymap.set('n', '<Leader-r>Up', ':RustMoveItemUp<cr>', {buffer = bufnr})
                        vim.keymap.set('n', '<Leader-r>Down', ':RustMoveItemDown<cr>', {buffer = bufnr})
                        vim.keymap.set('n', '<Leader-r>d', rt.debuggables.debuggables, {buffer = bufnr})
                    end
                },
                dap = {
                    adapter = {
                        type = 'executable',
                        command = 'lldb-vscode',
                        name = 'rt_lldb'
                    }
                }
            }
        end
    }

    -- git cli is kinda annoying and I don't feel like going into a term for it
    use 'kdheepak/lazygit.nvim'

    -- If in a gui set gui settings, otherwise use smooth scroll plugin because neovide already has smooth scroll
    if has_key(vim.g, 'neovide') then
        vim.opt.guifont = 'Fira Code Nerd Font:h13'
    else
        use {
            'declancm/cinnamon.nvim',
            config = function() require('cinnamon').setup() end
        }
    end
end)
