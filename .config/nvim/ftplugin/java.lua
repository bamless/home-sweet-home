local util = require 'lspconfig.util'

local root_files = {
    -- Multi-module projects
    { '.git', 'build.gradle', 'build.gradle.kts' },
    -- Single-module projects
    {
        'build.xml',           -- Ant
        'pom.xml',             -- Maven
        'settings.gradle',     -- Gradle
        'settings.gradle.kts', -- Gradle
    },
}

local env = {
    HOME = vim.uv.os_homedir(),
    XDG_CACHE_HOME = os.getenv('XDG_CACHE_HOME'),
    JDTLS_JVM_ARGS = os.getenv('JDTLS_JVM_ARGS'),
}

local function get_cache_dir()
    return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or util.path.join(env.HOME, '.cache')
end

local function get_jdtls_cache_dir()
    return util.path.join(get_cache_dir(), 'jdtls')
end

local function get_jdtls_config_dir()
    return util.path.join(get_jdtls_cache_dir(), 'config')
end

local function get_jdtls_workspace_dir()
    return util.path.join(get_jdtls_cache_dir(), 'workspace')
end

local function get_jdtls_jvm_args()
    local args = {}
    for a in string.gmatch((env.JDTLS_JVM_ARGS or ''), '%S+') do
        local arg = string.format('--jvm-arg=%s', a)
        table.insert(args, arg)
    end
    return unpack(args)
end

local mason_path = vim.fn.stdpath("data") .. "/mason/bin/"

local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        mason_path .. "jdtls",
        '-configuration',
        get_jdtls_config_dir(),
        '-data',
        get_jdtls_workspace_dir(),
        get_jdtls_jvm_args(),
    },

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            signatureHelp = { enabled = true },
            completion = {
                guessMethodArguments = false
            },
            --inlayHints = {
            --    parameterNames = { enabled = "literals" }
            --},
        }
    },

    root_markers = root_files,

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        workspace = get_jdtls_workspace_dir(),
        bundles = {}
    },

    on_attach = function(client, bufnr)
        require("jdtls").setup_dap { hotcodereplace = "auto" }
        require("jdtls.dap").setup_dap_main_class_configs()

        -- JDTLS client does not report the correct capabilities, such as `textDocument/formatting` or `textDocument/inlayHint`.
        -- Due to this, the check done in `on_attach` for these capabilities will not work, even though JDTLS supports them.
        -- Forcefully enable them here.
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) -- Enable inlay hints by default
        vim.keymap.set("n", "<leader>h", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
        end, opts)
    end
}

local java_debug_bundle = vim.split(
    vim.fn.glob(vim.fn.stdpath('data') ..
        '/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'),
    '\n'
)

if java_debug_bundle[1] ~= '' then
    vim.list_extend(config.init_options.bundles, java_debug_bundle)
end

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

-- Setup dap java configuration
local dap = require "dap"
dap.configurations.java = {
    {
        javaExec = "java",
        request = "launch",
        type = "java",
        name = "Debug (Launch)",
    },
    {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 5005,
    },
}
