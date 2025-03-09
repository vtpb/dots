return {

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    event = { "BufRead", "BufWinEnter", "BufNewFile" },
    cmd = {
      "TSInstall",
      "TSBufEnable",
      "TSBufDisable",
      "TSEnable",
      "TSDisable",
      "TSModuleInfo",
    },
    build = ":TSUpdate",
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects', 
        lazy=true,
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          end
        end,
      },
      {'p00f/nvim-ts-rainbow', lazy=true},

    },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    config = function()
      require "plugins.configs.treesitter"
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonInstallAll",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    opts = {
      ensure_installed = { 
        "lua-language-server",
        "pyright",
        "marksman",
        "bash-language-server",
        "fortls",
        "texlab"
      },
      PATH = "skip", -- PATH update performed externally (see core/init.lua)
      ui = {
        icons = {
          package_pending = " ",
          package_installed = "󰄳 ",
          package_uninstalled = "󰚌",
        },
        keymaps = {
          toggle_server_expand = "<CR>",
          install_server = "i",
          update_server = "u",
          check_server_version = "c",
          update_all_servers = "U",
          check_outdated_servers = "C",
          uninstall_server = "X",
          cancel_installation = "<C-c>",
        },
      },
      max_concurrent_installers = 10,
    },
    config = function(_, opts)
      mason = require("mason")
      mason.setup(opts)

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "fortls",
        "pyright",
        "texlab",
        "marksman"
      }
    },
  },

  -- LSP
  -- see LazyVim config for improvements
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufWinEnter", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    init = function()
      require "plugins.configs.lspconfig"
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        ft = {"python", "markdown", "tex", "latex", "sh", "bash"},
        build = "make install_jsregexp",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { 
          history = true, 
          -- updateevents = "TextChanged,TextChangedI",
          enable_autosnippets = true,
          -- store_selection_keys = "<Tab>",
        },

        config = function(_, opts)
          require("luasnip").config.set_config(opts)

          -- vscode format
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load { 
            paths = vim.g.vscode_snippets_path or "" 
          }

          -- lua format
          require("luasnip.loaders.from_lua").lazy_load { 
            paths = "~/.config/nvim/luasnippets/" or "" 
          }
          require("luasnip.loaders.from_lua").lazy_load { 
            paths = vim.g.luasnippets_path or "" 
          }

          -- TODO: review
          -- vim.api.nvim_create_autocmd("InsertLeave", {
          --   callback = function()
          --     if
          --       require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
          --       and not require("luasnip").session.jump_active
          --     then
          --       require("luasnip").unlink_current()
          --     end
          --   end,
          -- })

          -- load mappings
          require("core.mappings").luasnip()
        end,
      },

      -- linters - null-ls
      {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason.nvim" },
        opts = function()
          local nls = require("null-ls")
          return {
            root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
            sources = {
              -- nls.builtins.formatting.stylua,
              -- nls.builtins.formatting.shfmt,
              -- nls.builtins.diagnostics.chktex,
              -- nls.builtins.formatting.markdownlint,
              -- nls.builtins.diagnostics.markdownlint,
              -- nls.builtins.diagnostics.mypy,
              nls.builtins.diagnostics.pylint,
              nls.builtins.formatting.yapf,
            },
          }
        end,
      },

      -- autopairing of (){}[], $$ etc (using nvim-autopairs)
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        -- name = "autopairs",
        config = function(_, opts)
          local autopairs = require("nvim-autopairs")
          autopairs.setup(opts)

          -- rules
          local Rule = require("nvim-autopairs.rule")
          local cond = require('nvim-autopairs.conds')

          -- $$
          autopairs.add_rules({
            Rule("$$", "$$", {"tex", "latex", "markdown"})
              :with_pair(cond.not_after_regex("$"))
              :with_pair(cond.not_before_regex("$"))
          })
          -- $
          autopairs.add_rules({ Rule("$", "$",{"tex", "latex", "markdown"}) })

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },

    opts = function()
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  -- lsp inlay hints
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end
      
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end,
      })
    end,
  },

  -- another pairing plugin
  -- {
  --   "echasnovski/mini.pairs",
  --   event = "VeryLazy",
  --   config = function(_, opts)
  --     require("mini.pairs").setup(opts)
  --   end,
  -- },
  
  -- surround
  {
    "echasnovski/mini.surround",
    lazy = true,
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
    config = function(_, opts)
      -- use gz mappings instead of s to prevent conflict with leap
      require("mini.surround").setup(opts)
    end,
  },

  -- comments (disabled as it has been implemented in Neovim)
  -- plugins still work a bit better (add spaces after comment string)
  -- { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  -- {
  --   "echasnovski/mini.comment",
  --   event = "VeryLazy",
  --   opts = {
  --     hooks = {
  --       pre = function()
  --         require("ts_context_commentstring.internal").update_commentstring({})
  --       end,
  --     },
  --   },
  --   config = function(_, opts)
  --     require("mini.comment").setup(opts)
  --   end,
  -- },

  -- better text-objects (LazyVim)
  {
    "echasnovski/mini.ai",
    keys = {
      { "[f", desc = "Prev function" },
      { "]f", desc = "Next function" },
    },
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      local function ai_indent(ai_type)
        local spaces = (" "):rep(vim.o.tabstop)
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local indents = {} ---@type {line: number, indent: number, text: string}[]

        for l, line in ipairs(lines) do
          if not line:find("^%s*$") then
            indents[#indents + 1] = { line = l, indent = #line:gsub("\t", spaces):match("^%s*"), text = line }
          end
        end

        local ret = {} ---@type (Mini.ai.region | {indent: number})[]

        for i = 1, #indents do
          if i == 1 or indents[i - 1].indent < indents[i].indent then
            local from, to = i, i
            for j = i + 1, #indents do
              if indents[j].indent < indents[i].indent then
                break
              end
              to = j
            end
            from = ai_type == "a" and from > 1 and from - 1 or from
            to = ai_type == "a" and to < #indents and to + 1 or to
            ret[#ret + 1] = {
              indent = indents[i].indent,
              from = { line = indents[from].line, col = ai_type == "a" and 1 or indents[from].indent + 1 },
              to = { line = indents[to].line, col = #indents[to].text },
            }
          end
        end

        return ret
      end

      local function ai_buffer(ai_type)
        local start_line, end_line = 1, vim.fn.line("$")
        if ai_type == "i" then
          -- Skip first and last blank lines for `i` textobject
          local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
          -- Do nothing for buffer with all blanks
          if first_nonblank == 0 or last_nonblank == 0 then
            return { from = { line = start_line, col = 1 } }
          end
          start_line, end_line = first_nonblank, last_nonblank
        end

        local to_col = math.max(vim.fn.getline(end_line):len(), 1)
        return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
      end

      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          i = ai_indent(),
          g = ai_buffer(),
      },
    }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "e", desc = "CamelCase / snake_case" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
      }

      local ret = { mode = { "o", "x" } }
      ---@type table<string, string>
      local mappings = vim.tbl_extend("force", {}, {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
      }, opts.mappings or {})
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub("^around_", ""):gsub("^inside_", "")
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == "i" then
            desc = desc:gsub(" with ws", "")
          end
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end
      require("which-key").add(ret, { notify = false })
    end,
  },

  -- more bracketed movements
  {
    "echasnovski/mini.bracketed",
    enabled = false,
    event = "BufReadPost",
    config = function()
      local bracketed = require("mini.bracketed")

      local function put(cmd, regtype)
        local body = vim.fn.getreg(vim.v.register)
        local type = vim.fn.getregtype(vim.v.register)
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.fn.setreg(vim.v.register, body, regtype or "l")
        bracketed.register_put_region()
        vim.cmd(('normal! "%s%s'):format(vim.v.register, cmd:lower()))
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.fn.setreg(vim.v.register, body, type)
      end

      for _, cmd in ipairs({ "]p", "[p" }) do
        vim.keymap.set("n", cmd, function()
          put(cmd)
        end)
      end
      for _, cmd in ipairs({ "]P", "[P" }) do
        vim.keymap.set("n", cmd, function()
          put(cmd, "c")
        end)
      end

      local put_keys = { "p", "P" }
      for _, lhs in ipairs(put_keys) do
        vim.keymap.set({ "n", "x" }, lhs, function()
          return bracketed.register_put_region(lhs)
        end, { expr = true })
      end

      bracketed.setup({
        file = { suffix = "" },
        window = { suffix = "" },
        quickfix = { suffix = "" },
        treesitter = { suffix = "n" },
      })
    end,
  },
  
  -- vimtex
  {
    "lervag/vimtex",
    name = "vimtex",
    ft = { "tex", "plaintex", "bib" },
    config = function()
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_view_general_viewer = 'zathura'
      vim.g.tex_comment_nospell = 1
      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_indent_enabled = 0
      vim.g.vimtex_mappings_enabled = 0
      vim.g.vimtex_imaps_enabled = 0
      vim.g.vimtex_complete_enabled = 0
      vim.g.vimtex_include_search_enabled = 0
      vim.g.vimtex_quickfix_ignore_filters = {
          'LaTeX hooks Warning',
          'Underfull \\hbox',
          'Overfull \\hbox',
          -- 'LaTeX Warning: .\+ float specifier changed to',
          'Package siunitx Warning: Detected the "physics" package:',
          'Package hyperref Warning: Token not allowed in a PDF string',
          'Fatal error occurred, no output PDF file produced!',
      }
      vim.g.vimtex_toc_config = {
        split_pos = "vert rightbelow",
        split_width = "30",
        fold_enable = 1,
      }
    end,
    keys = function()
      require("core.mappings").vimtex()
    end,
  },

  -- neodev: automatic configuration for lua development
  { 
    "folke/neodev.nvim", 
    ft = { "lua" },
    opts = {},
  },

}
