local mason = require "mason"
local mason_lspconfig = require "mason-lspconfig"
local on_attach = require("custom.configs.lsp").on_attach
local capabilities = require("custom.configs.lsp").capabilities

mason.setup {
  ui = {
    -- Whether to automatically check for new versions when opening the :Mason window.
    check_outdated_packages_on_open = false,
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ",
    },
  },
}

mason_lspconfig.setup {
  automatic_installation = true,
  ensure_installed = {
    -- Lua
    "lua_ls",
    "vimls",

    -- Web Development
    "astro",
    "cssls",
    "html",
    "tsserver",
    "denols",
    "vuels",
    "tailwindcss",
    "emmet_language_server",

    -- PHP
    -- "intelephense",

    -- C/C++
    "clangd",

    -- Java
    "jdtls",

    -- Yaml
    -- "yamlls",

    -- Python
    "pyright",

    -- Go
    -- "gopls",

    -- C#
    "omnisharp",
    -- "omnisharp-mono",

    -- make
    "autotools_ls",
  },
}

local disabled_servers = {
  "jdtls",
  -- "tsserver",
}

mason_lspconfig.setup_handlers {
  -- Automatically configure the LSP installed
  function(server_name)
    for _, name in pairs(disabled_servers) do
      if name == server_name then
        return
      end
    end
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    local require_ok, server = pcall(require, "custom.configs.lsp.settings." .. server_name)
    if require_ok then
      opts = vim.tbl_deep_extend("force", server, opts)
    end

    require("lspconfig")[server_name].setup(opts)
  end,

  require("lspconfig").astro.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "astro" },
  },
}
