---
-- Configure LSP servers
---

local lsp_zero = require('lsp-zero')
local lsp_configs = require('config.lsp')

lsp_zero.extend_lspconfig {
    set_lsp_keymaps = false,
    on_attach = lsp_configs.on_attach,
}

---
-- Configure Mason
---

require('mason').setup()
require('mason-lspconfig').setup()

local handlers = {
    function(server_name)
        require('lspconfig')[server_name].setup {}
    end
}

local configs = lsp_configs.lsps
for lsp_name, config in pairs(configs) do
    handlers[lsp_name] = config
end

require('mason-lspconfig').setup_handlers(handlers)

---@diagnostic disable-next-line: different-requires
local opts = require("config.mason")

vim.api.nvim_create_user_command("MasonInstallAll", function()
    vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
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
    virtual_text = true
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Enable underline, use default values
        underline = true,
        -- Enable virtual text, override spacing to 4
        virtual_text = {
            spacing = 4,
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

---
-- Signature hint
---

require('lsp_signature').setup {
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
        border = "single"
    },
    hint_enable = false,
    doc_lines = 0,
}

---
-- Lightbulb
---

-- Show a lightbulb icon when there are available LSP actions.
require("nvim-lightbulb").setup {
    sign = { enabled = false },
    virtual_text = { enabled = true, text = "💡" },
    autocmd = { enabled = true },
}
