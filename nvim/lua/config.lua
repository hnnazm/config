-- Lazy plugin manager setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end
  },
  {
    "ibhagwan/fzf-lua",
    build = "./install --all",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<Leader><Leader>f",        "<Cmd> FzfLua files<CR>",        desc = "Fuzzy find files" },
      { "<Leader><Leader>/",        "<Cmd> FzfLua grep<CR>",         desc = "Fuzzy find words" },
      { "<Leader><Leader>b",        "<Cmd> FzfLua buffers<CR>",      desc = "Fuzzy find buffers" },
      { "<Leader><Leader>r",        "<Cmd> FzfLua registers<CR>",    desc = "Fuzzy find registers" },
      { "<Leader><Leader>m",        "<Cmd> FzfLua marks<CR>",        desc = "Fuzzy find marks" },
      { "<Leader><Leader>j",        "<Cmd> FzfLua jumps<CR>",        desc = "Fuzzy find jumps" },
      { "<Leader><Leader>h",        "<Cmd> FzfLua helptags<CR>",     desc = "Fuzzy find help" },
      { "<Leader><Leader>gc",       "<Cmd> FzfLua git_bcommits<CR>", desc = "Fuzzy find branch commits" },
      { "<Leader><Leader><Leader>", "<Cmd> FzfLua resume<CR>",       desc = "Fuzzy find resume" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})
      ts.install({
        "go",
        "typescript",
        "javascript",
        "tsx",
        "jsx",
        "vue",
        "lua",
        "css",
        "php",
        "bash",
        "vim",
        "vimdoc",
        "dockerfile",
        "html",
        "python",
        "java",
        "yaml",
      })
    end
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = true,
      ensure_installed = {
        "gopls",
        "ts_ls",
        "vue_ls",
        "lua_ls",
        "tailwindcss",
        "copilot",
        "phpactor",
        "bashls",
        "cssls",
        "vimls",
        "docker_language_server",
        "html",
        "pylsp",
        "yamlls",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      {
        "neovim/nvim-lspconfig",
        config = function ()
          vim.diagnostic.config({
            signs = {
              active = true,
              text = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN]  = " ",
                [vim.diagnostic.severity.HINT]  = " ",
                [vim.diagnostic.severity.INFO]  = " ",
              },
            },
            float = {
              border = "single",
              format = function(diagnostic)
                return string.format(
                  "%s (%s) [%s]",
                  diagnostic.message,
                  diagnostic.source,
                  diagnostic.code or diagnostic.user_data.lsp.code
                )
              end,
            },
          })
        end
      }
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      -- "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require("cmp")

      -- require("copilot_cmp").setup()

      local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
        Copilot = "",
      }

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { "kind", "abbr" },
          format = function(_, vim_item)
            vim_item.kind = kind_icons[vim_item.kind] or ""
            return vim_item
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-x><C-o>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          -- { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        })
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.delve = function(callback, config)
        if config.mode == 'remote' and config.request == 'attach' then
          callback({
            type = 'server',
            host = config.host or '127.0.0.1',
            port = config.port or '38697'
          })
        else
          callback({
            type = 'server',
            port = '${port}',
            executable = {
              command = 'dlv',
              args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
              detached = vim.fn.has("win32") == 0,
            }
          })
        end
      end


      -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}"
        },
        {
          type = "delve",
          name = "Debug test", -- configuration for debugging test files
          request = "launch",
          mode = "test",
          program = "${file}"
        },
        -- works with go.mod packages and sub packages
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}"
        }
      }
    end
  },
  {
    "nvim-java/nvim-java",
    config = function()
      require('java').setup()
      vim.lsp.enable('jdtls')
    end,
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --       server_opts_overrides = {
  --         trace = "verbose",
  --         cmd = {
  --           "copilot-language-server",
  --           "--stdio",
  --         },
  --         settings = {
  --           advanced = {
  --             listCount = 10,
  --             inlineSuggestCount = 3,
  --           },
  --         },
  --       },
  --       filetypes = {
  --         yaml = true,
  --         markdown = true,
  --         help = false,
  --         gitcommit = true,
  --         gitrebase = true,
  --         hgcommit = false,
  --         svn = false,
  --         cvs = false,
  --         ["."] = false,
  --         ["*"] = true,
  --       },
  --     })
  --   end,
  -- },
})
