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
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        indent = {
          enable = true
        }
      })
    end
  },
  {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets"
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()

      local ls = require("luasnip")

      vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-E>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {}
      },
      {
        "neovim/nvim-lspconfig",
        config = function ()
            -- vim.lsp.enable({
            -- "gopls"
            -- "ts_ls",
            -- "vue_ls",
            -- "lua_ls",
            -- "tailwindcss",
            -- "copilot_ls",
            -- "go_ls",
            -- "php_ls",
            -- "bash_ls",
            -- "css_ls",
            -- "vim_ls",
            -- "docker_ls",
            -- "html_ls",
            -- "python_ls",
            -- "yaml_ls",
            -- })

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
      "saadparwaiz1/cmp_luasnip",
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
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
            vim.snippet.expand(args.body)
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
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        })
      })
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
