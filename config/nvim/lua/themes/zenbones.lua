local present, theme = pcall(require, "zenbones")

if not present then
  return
end

vim.opt.background = "dark" -- set this to dark or light
-- vim.cmd.colorscheme "zenbones"
vim.cmd.colorscheme "zenwritten"
-- vim.cmd.colorscheme "rosebones"
-- vim.cmd.colorscheme "tokyobones"
-- vim.cmd.colorscheme "kanagawabones"
-- vim.cmd.colorscheme "randombones"
