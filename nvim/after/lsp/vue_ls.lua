return {
  cmd = { "vue-language-server", "--stdio" },
  root_markers = { "package.json" },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  init_options = {
    vue = {
      hybridMode = true,
    },
    typescript = {
      tsdk = "",
    }
  },
}
