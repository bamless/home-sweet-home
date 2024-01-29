---@diagnostic disable: different-requires

local function lsp_setup()
    ---
    -- Configure LSP servers
    ---

    local lsp_zero = require('lsp-zero')
    local lsp_configs = require('config.lsp')

    lsp_zero.on_attach(lsp_configs.on_attach)

    ---
    -- Configure Mason
    ---

    require('mason').setup()

    local handlers = {
        lsp_zero.default_setup,
        -- function(server_name)
        --     require('lspconfig')[server_name].setup {}
        -- end
    }

    local lsps = lsp_configs.lsps
    for lsp_name, config in pairs(lsps) do
        handlers[lsp_name] = config
    end

    require('mason-lspconfig').setup({
        handlers = handlers
    })

    vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(require("config.mason").ensure_installed, " "))
    end, {})

    ---
    -- Diagnostic config
    ---

    lsp_zero.set_sign_icons {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }

    vim.diagnostic.config {
        virtual_text = {
            virtual_text = true,
        },
        float = { source = true, severity_sort = true },
        severity_sort = true,
    }

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            -- Enable underline, use default values
            underline = true,
            -- Enable virtual text, override spacing to 4
            virtual_text = {
                spacing = 4,
                severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
                source = "if_many",
            },
            update_in_insert = false,
            severity_sort = true,
        }
    )

    ---
    -- Snippet config
    ---

    require('luasnip').config.set_config({
        region_check_events = 'InsertEnter',
        delete_check_events = 'InsertLeave'
    })

    require('luasnip.loaders.from_vscode').lazy_load()

    ---
    -- Autocompletion (cmp)
    ---

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

    local cmp_config = lsp_zero.defaults.cmp_config({
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

        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },

        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "nvim_lua" },
            { name = "path" },
        },
    })

    -- Custom autocompletion formatting
    cmp_config.formatting = {
        -- default fields order i.e completion word + item.kind + item.kind icons
        fields = { "abbr", "kind", "menu" },

        format = function(entry, item)
            local icons = require("config.lsp-icons")

            -- Kind icons
            item.kind = string.format('%s %s', icons[item.kind], item.kind) -- This concatonates the icons with the name of the item kind

            -- Source
            item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[LaTeX]",
            })[entry.source.name]

            item.abbr = string.sub(item.abbr, 1, 140)
            return item
        end
    }
    -- table.insert(cmp_config.sources, { name = 'nvim_lsp_signature_help' })

    cmp.setup(cmp_config)
end

return {
    -- LSP Support
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        config = lsp_setup,
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
        }

    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            bind = true, -- This is mandatory, otherwise border config won't get registered.
            handler_opts = {
                border = "single"
            },
            hint_enable = false,
            doc_lines = 0,
        },
    },
    'arkav/lualine-lsp-progress',
}
