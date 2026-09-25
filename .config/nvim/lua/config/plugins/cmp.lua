local function cmp_python_setup(cmp)
    local compare = require("cmp.config.compare")
    local K = require("cmp.types").lsp.CompletionItemKind

    -- 0 = enum member, 1 = public, 2 = _private, 3 = __dunder__
    local function python_rank(entry)
        if entry:get_kind() == K.EnumMember then
            return 0
        end
        local label = entry.completion_item.label or ""
        if label:find("^__.*__$") then
            return 3
        elseif label:find("^_") then
            return 2
        end
        return 1
    end

    local function python_underscore_last(e1, e2)
        local r1, r2 = python_rank(e1), python_rank(e2)
        if r1 ~= r2 then
            return r1 < r2
        end
        return nil
    end

    cmp.setup.filetype("python", {
        sorting = {
            priority_weight = 2,
            comparators = {
                compare.offset,
                compare.exact,
                python_underscore_last,
                compare.score,
                compare.recently_used,
                compare.locality,
                compare.kind,
                compare.length,
                compare.order,
            },
        },
    })
end

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

            --
            -- Language specific extensions
            --

            cmp_python_setup(cmp)
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
