local vue_ls_path = vim.fn.expand("$MASON/packages/vue-language-server")
local vue_plugin_path = vue_ls_path .. "/node_modules/@vue/language-server"

return {
  cmd = { "typescript-language-server", "--stdio" },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
  },
  handlers = {
    ["_typescript.rename"] = "<function 1>",
  },
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_plugin_path,
        languages = {"javascript", "typescript", "vue"},
      },
    },
    hostInfo = "neovim",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
}
