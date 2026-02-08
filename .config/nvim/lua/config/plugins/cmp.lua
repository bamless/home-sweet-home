return {
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')

            local function border(hl_name)
                return {
                    { "╭", hl_name },
                    { "─", hl_name },
                    { "╮", hl_name },
                    { "│", hl_name },
                    { "╯", hl_name },
                    { "─", hl_name },
                    { "╰", hl_name },
                    { "│", hl_name },
                }
            end

            local config = {
                completion = {
                    completeopt = "menu,menuone",
                },

                window = {
                    completion = {
                        side_padding = 1,
                        scrollbar = false,
                        border = border "CmpBorder",
                    },
                    documentation = {
                        border = border "CmpDocBorder",
                        winhighlight = "Normal:CmpDoc",
                    },
                },

                mapping = cmp.mapping.preset.insert({
                    -- `Enter` key to confirm completion
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),

                    -- Navigate between completions
                    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

                    -- Scroll up and down in the completion documentation
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                }),

                sources = {
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "nvim_lua", priority = 1000 },
                    { name = "buffer",   priority = 500 },
                    { name = "path",     priority = 250 },
                },
            }

            -- Custom autocompletion formatting
            config.formatting = {
                -- default fields order i.e completion word + item.kind + item.kind icons
                fields = { "abbr", "kind", "menu" },

                format = function(entry, item)
                    local icons = require("config.lsp-icons")

                    -- Kind icons
                    item.kind = string.format('%s %s', icons[item.kind], item.kind) -- This concatenates the icons with the name of the item kind

                    -- Source
                    item.menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        nvim_lua = "[Lua]",
                        latex_symbols = "[LaTeX]",
                    })[entry.source.name]

                    item.abbr = string.sub(item.abbr, 1, 140)
                    return item
                end
            }

            cmp.setup(config)
        end,
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
        }
    },
}
