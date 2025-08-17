local function lsp_setup()
    ---
    -- Configure LSP servers
    ---

    local lsp_configs = require('config.lsp')
    for _, config in pairs(lsp_configs) do
        config()
    end

    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if not client then
                return
            end

            local opts = { buffer = ev.buf, remap = false }

            -- LSP formatting support
            if client:supports_method("textDocument/formatting") then
                vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
                -- Auto formatting on save
                -- vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
                -- vim.api.nvim_create_autocmd("BufWritePre", {
                --     group = augroup,
                --     buffer = bufnr,
                --     callback = function()
                --         vim.lsp.buf.format { async = false }
                --     end
                -- })
            end

            -- Enable inlay hints if supported by neovim and LSP
            --if client.supports_method("textDocument/inlayHint") and vim.lsp.inlay_hint then
            --    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) -- Enable inlay hints by default
            --    vim.keymap.set("n", "<leader>h", function()
            --        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            --        vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
            --    end, opts)
            --end
        end
    })

    -- Hover support
    vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover({ border = 'rounded' })
    end)

    -- LSP function keybindings
    local telescope = require('telescope.builtin')
    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
    vim.keymap.set("n", "gc", telescope.lsp_incoming_calls)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)
    vim.keymap.set("n", "<leader>sr", vim.lsp.buf.references)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
    vim.keymap.set("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols)
    vim.keymap.set("n", "<leader>ss", telescope.lsp_document_symbols)
    vim.keymap.set("n", "<leader>wr", telescope.lsp_references)

    -- Misc language keybinds
    vim.keymap.set("n", "<leader>ts", telescope.treesitter)
    vim.keymap.set("n", "<leader>dd", telescope.diagnostics)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float)
    vim.keymap.set('n', '<leader>qd', vim.diagnostic.setloclist)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1, float = true }) end)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1, float = true }) end)

    -- Code action keybindings
    vim.keymap.set("n", "<leader>co", function()
        vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "source.organizeImports" }, diagnostics = {} },
        })
    end)

    ---
    -- Configure Mason
    ---

    require('mason').setup()
    require('mason-lspconfig').setup {
        automatic_enable = {
            -- ts_ls and jdstls are handled by typescript-tools and nvim-jdtls respectively
            exclude = { "ts_ls", "jdtls" }
        }
    }

    vim.api.nvim_create_user_command("MasonInstallAll", function()
        ---@diagnostic disable-next-line: different-requires
        vim.cmd("MasonInstall " .. table.concat(require("config.mason").ensure_installed, " "))
    end, {})

    ---
    -- Diagnostic config
    ---

    vim.diagnostic.config({
        signs = {
            text = { 'E', 'W', 'H', 'I' }
        },
        float = { source = true, severity_sort = true },
        underline = false,
        virtual_text = false,
        -- -- Enable underline, use default values
        -- underline = true,
        -- -- Enable virtual text, override spacing to 4
        -- virtual_text = {
        --     spacing = 4,
        --     severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
        --     source = "if_many",
        -- },
        update_in_insert = false,
        severity_sort = true,
    })

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

    local cmp_config = {
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
    }

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
        'williamboman/mason.nvim',
        config = lsp_setup,
        dependencies = {
            { 'neovim/nvim-lspconfig' },
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
    {
        'linrongbin16/lsp-progress.nvim',
        opts = {
            client_format = function(client_name, spinner, series_messages)
                if #series_messages == 0 then
                    return nil
                end
                return {
                    name = client_name,
                    body = spinner .. " " .. table.concat(series_messages, ", "),
                }
            end,
            format = function(client_messages)
                --- @param name string
                --- @param msg string?
                --- @return string
                local function stringify(name, msg)
                    return msg and string.format("%s %s", name, msg) or name
                end

                local sign = "" -- nf-fa-gear \uf013
                local lsp_clients = vim.lsp.get_clients()
                local messages_map = {}
                for _, climsg in ipairs(client_messages) do
                    messages_map[climsg.name] = climsg.body
                end

                if #lsp_clients > 0 then
                    table.sort(lsp_clients, function(a, b)
                        return a.name < b.name
                    end)
                    local builder = {}
                    for _, cli in ipairs(lsp_clients) do
                        if
                            type(cli) == "table"
                            and type(cli.name) == "string"
                            and string.len(cli.name) > 0
                        then
                            if messages_map[cli.name] then
                                table.insert(builder, stringify(cli.name, messages_map[cli.name]))
                            else
                                table.insert(builder, stringify(cli.name))
                            end
                        end
                    end
                    if #builder > 0 then
                        return sign .. " " .. table.concat(builder, ", ")
                    end
                end
                return ""
            end,
        }
    }
}
