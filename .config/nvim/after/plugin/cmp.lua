local cmp = require "cmp"

local formatting_style = {
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

        return item
    end,
}

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

local options = {
    completion = {
        completeopt = "menu,menuone",
    },

    window = {
        completion = {
            side_padding = 1,
            scrollbar = false,
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

    formatting = formatting_style,

    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
    },
}

options.window.completion.border = border "CmpBorder"

cmp.setup(options)
