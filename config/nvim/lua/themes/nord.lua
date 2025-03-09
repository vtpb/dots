local present, theme = pcall(require, "nord")
if not present then
  return
end

-- Example config in lua
vim.g.nord_contrast = true
vim.g.nord_borders = false
vim.g.nord_disable_background = false
vim.g.nord_italic = true
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = false

-- Load the colorscheme
theme.set()

-- lualine
local present, lualine = pcall(require, "lualine")
if present then
  lualine.setup({ options = {theme = 'nord'} })
end


-- bufferline
local present, bufferline = pcall(require, "bufferline")
if present then
  bufferline.setup({
    highlights = theme.bufferline.highlights({italic = false, bold = false})
  })
end

vim.cmd [[colorscheme nord]]
