return {

  -- file managing , picker etc
   {"nvim-tree/nvim-tree.lua",
    ft = "alpha",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      vim.g.nvimtree_side = opts.view.side
    end,
    keys = function()
      require("core.mappings").nvimtree()
    end,
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    ft = "gitcommit",
    lazy = true,
    -- events = { "BufReadPre", "BufNewFile" }
    -- from NvChad
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
            vim.schedule(function()
              require("lazy").load { plugins = { "gitsigns.nvim" } }
            end)
          end
        end,
      })
    end,
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = {  text = "" },
        topdelete = {  text = "‾" },
        changedelete = { text = "~" },
      },
      signcolumn = true,
      current_line_blame = true,
      numhl = true,
      on_attach = function(bufnr)
        require("core.mappings").gitsigns({ buffer = bufnr })
      end,
    },
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
    },
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      ts = require("telescope")
      ts.setup(opts)
      -- load extensions
      pcall(function()
        for _, ext in ipairs(opts.extensions_list) do
          ts.load_extension(ext)
        end
      end)
    end,
    keys = function()
      require("core.mappings").telescope()
    end,
  },

  -- whichkey
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { "<leader>", '"', "'", "`" },
    opts = {
      layout = {
        spacing = 6, -- spacing between columns
      },
      -- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
      -- triggers_blacklist = {
      --   -- list of mode / prefixes that should never be hooked by WhichKey
      --   i = { "j", "k" },
      --   v = { "j", "k" },
      -- },
    },

    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      local keymaps = {
        { mode = { "n", "v" },
          {"g", group = "+goto" },
          {"gz", desc = "+surround" },
          {"]", group = "+next" },
          {"[", group = "+prev" },
          {"<leader><tab>", group = "+tabs" },
          {"<leader>b", group = "+buffer" },
          {"<leader>c", group = "+code" },
          {"<leader>e", group = "+editor" },
          -- ["<leader>d", desc = "+diagnostics (lsp)" },
          {"<leader>f", group = "+file/find" },
          {"<leader>g", group = "+git" },
          {"<leader>gh", group = "+hunks" },
          {"<leader>l", group = "+latex (vimtex)" },
          {"<leader>s", group = "+session/spellcheck"},
          {"<leader>sc", group = "+spellcheck" },
          {"<leader>u", group = "+ui" },
          {"<leader>un", group = "+noice" },
          {"<leader>w", group = "+windows" },
          {"<leader>x", group = "+diagnostics/quickfix" },
          {"<leader>o", group = "+obsidian" },
        }
      }
      wk.add(keymaps)
    end,
  },

  -- folding
  {
    'kevinhwang91/nvim-ufo',
    -- enabled = false,
    lazy = true,
    dependencies = 'kevinhwang91/promise-async',
    name = "ufo",
    ops = {
      preview = {
      win_config = {
        border = { "", "─", "", "", "", "─", "", "" },
        -- winhighlight = "Normal:Folded",
        winblend = 0,
        },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
        },
      },
    },
    config = function(_, opts)
      ufo = require("ufo")
      vim.o.foldcolumn = '2' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

      -- nvim lsp as LSP client
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
      }
      local language_servers = require("lspconfig").util.available_servers()
      for _, ls in ipairs(language_servers) do
          require('lspconfig')[ls].setup({
              capabilities = capabilities
          })
      end

      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
                table.insert(newVirtText, chunk)
            else
                chunkText = truncate(chunkText, targetWidth - curWidth)
                local hlGroup = chunk[2]
                table.insert(newVirtText, {chunkText, hlGroup})
                chunkWidth = vim.fn.strdisplaywidth(chunkText)
                -- str width returned from truncate() may less than 2nd argument, need padding
                if curWidth + chunkWidth < targetWidth then
                    suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                end
                break
            end
            curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, {suffix, 'MoreMsg'})
        return newVirtText
      end
      opts["fold_virt_text_handler"] = handler

      ufo.setup(opts)

    end,
    -- keys = function()
    --   require("core.mappings").ufo()
    -- end
  },

  -- easily jump to any location and enhanced f/t motions for Leap
  {
    "ggandor/flit.nvim",
    keys = function()
      ---@type LazyKeys[]
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },

  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },

  -- better diagnostics list
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { 
        "<leader>xx", 
        "<cmd>Trouble diagnostics toggle<cr>", 
        desc = "Diagnostics (Trouble)" 
      },
      { 
        "<leader>xX", 
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", 
        desc = "Buffer diagnostics (Trouble)" 
      },
      { 
        "<leader>xL", 
        "<cmd>Trouble loclist toggle<cr>", 
        desc = "Location list (Trouble)" 
      },
      { 
        "<leader>xQ", 
        "<cmd>Trouble qflist toggle<cr>", 
        desc = "Quickfix list (Trouble)" 
      },
      {
        "<leader>xS",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)"
      },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Defs / refs / ... (Trouble)"
      },
      -- {
      --   "[q",
      --   function()
      --     if require("trouble").is_open() then
      --       require("trouble").previous({ skip_groups = true, jump = true })
      --     else
      --       cprev()
      --     end
      --   end,
      --   desc = "Previous trouble/quickfix item",
      -- },
      -- {
      --   "]q",
      --   function()
      --     if require("trouble").is_open() then
      --       require("trouble").next({ skip_groups = true, jump = true })
      --     else
      --       cnext()
      --     end
      --   end,
      --   desc = "Next trouble/quickfix item",
      -- },
    },
  },

  -- comments
  {
    "folke/todo-comments.nvim",
    lazy = true,
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment"},
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },

  -- zenmode and twilight (focused coding)
  {
    "folke/zen-mode.nvim",
    lazy = true,
    opts = {
      window = {
      backdrop = 1.00, -- shade the backdrop (1 for Normal)
      width = 100, -- width of the Zen window
      height = 1, -- height of the Zen window
      options = {
        -- signcolumn = "no", -- disable signcolumn
        -- number = false, -- disable number column
        -- relativenumber = false, -- disable relative numbers
        -- cursorline = false, -- disable cursorline
        -- cursorcolumn = false, -- disable cursor column
        foldcolumn = "0", -- disable fold column
        -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
        },
        twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = false }, -- disables the tmux statusline
        -- this will change the font size on kitty when in zen mode
        -- to make this work, you need to set the following kitty options:
        -- - allow_remote_control socket-only
        -- - listen_on unix:/tmp/kitty
        kitty = {
          enabled = false,
          font = "+2", -- font size increment
        },
      },
    },
    config = function(_, opts)
      require("zen-mode").setup(opts)
      -- require("core.mappings").zenmode()
    end
  },

  {
    "folke/twilight.nvim",
    lazy = true,
    opts = {
      dimming = {
        alpha = 0.25, -- amount of dimming
        -- try to get the foreground from the highlight groups or fallback color
        color = { "Normal", "#ffffff" },
        term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
        inactive = false, -- dimm other windows
      },
      context = 10,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
      },
      exclude = {}, -- exclude these filetypes
    },
    config = function(_, opts)
      require("twilight").setup(opts)
      -- require("core.mappings").twilight()
    end,
  },

  -- alignment (e.g., for .md tables)
  { 
    'echasnovski/mini.nvim', 
    version = false,
    config = function()
      require('mini.align').setup()
    end,
  },

  -- signal and remove trailing whitespaces
  { 
    'echasnovski/mini.trailspace', 
    version = false,
    config = function()
      require("mini.trailspace").setup()
      require("core.mappings").mini_trailspace()
    end
  },



}
