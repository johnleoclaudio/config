return {
  { require("plugins.telescope") },
  { require("plugins.completions") },
  { require("plugins.treesitter") },
  { require("plugins.snacks") },
  { require("mason-lspconfig").get_mappings().lspconfig_to_package },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
      },
    },
  },
}
