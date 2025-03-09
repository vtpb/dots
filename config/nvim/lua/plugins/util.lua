return {

  -- sessions (unused)
  {
    "folke/persistence.nvim",
    enabled = false,
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
    keys = {
      { "<leader>ss", function() require("persistence").load() end, desc = "restore session" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "restore last session" },
      { "<leader>sx", function() require("persistence").stop() end, desc = "do not save session" },
    },
  },

  -- library required by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- make plugins dot-repeatable (useful for leap)
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- tmux navigation
  {
    "numToStr/Navigator.nvim",
    config = function()
      require("Navigator").setup()
      require("core.mappings").navigator()
    end
  },

}
