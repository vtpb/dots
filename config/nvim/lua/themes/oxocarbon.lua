local present, theme = pcall(require, "oxocarbon")

if not present then
  return
end

vim.opt.background = "dark" -- set this to dark or light
vim.cmd.colorscheme "oxocarbon"
