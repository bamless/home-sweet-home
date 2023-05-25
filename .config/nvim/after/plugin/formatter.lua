-- Utilities for creating configurations
--local util = require "formatter.util"

local formatters = {
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
        -- "formatter.filetypes.any" defines default configurations for any
        -- filetype
        require("formatter.filetypes.any").remove_trailing_whitespace
    }
}

local configs = require('config.formatters')
for lang, config in pairs(configs) do
    formatters[lang] = config
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = formatters,
}
