return {

  ------------
  -- themes --
  { 
    "catppuccin/nvim", 
    lazy = true
  },
  { 
    "Mofiqul/dracula.nvim", 
    lazy = true 
  },
  { 
    "marko-cerovac/material.nvim", 
    lazy = true 
  },
  { 
    "navarasu/onedark.nvim", 
    lazy = true 
  },
  { 
    "shaunsingh/nord.nvim", 
    lazy = true 
  },
  { 
    "rmehri01/onenord.nvim", 
    lazy = true 
  },
  -- {
  --   "mountain-theme/Mountain",
  --   dir = "~/dotfiles/.config/nvim/plugins/mountain.nvim",
  --   name = "mountain",
  --   dev = true,
  --   lazy = true,
  --   pin = true,
  -- },
  -- Default options:
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
  },
  {
    "mcchrish/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = {"rktjmp/lush.nvim"},
    lazy = true,
   }
}
