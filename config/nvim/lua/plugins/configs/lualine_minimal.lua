local icons = require("core.ui.icons")

local hide_in_width = function()
    return vim.o.columns > 100
end

local custom = {
  filetype = nil,
  filename = nil,
  mode = nil,
  diagnostics = nil,
  diff = nil,
  branch = nil,
  progress = nil,
  lsp = nil,
}

-- custom components
custom.filetype = {
  'filetype',
  colored = false,
  icon_only = true,
  icon = { align = 'right' },
}

custom.filename = { 
  'filename', 
  colored = true,
  path = 1, 
  symbols = { modified = "  ", readonly = "", unnamed = "" },
}

-- truncate to first letter
custom.mode = {
  'mode',
  fmt = function(str) return str:sub(1, 0) .. icons.devicons.neovim.icon end,
  -- icon = {icons.devicons.vim.icon, align = 'left'},
  padding = {left = 1, right = 1},
  draw_empty = true,
}

custom.diagnostics = {
	"diagnostics",
	sources = { "nvim_lsp" },
	-- sections = { "error", "warn" },
	symbols = { 
    error = icons.diagnostics.Error, 
    warn =  icons.diagnostics.Warn, 
    info = icons.diagnostics.Info, 
    hint = icons.diagnostics.Hint
  },
	colored = true,
	update_in_insert = false,
	always_visible = false,
}

custom.diff = {
	"diff",
	colored = false,
	-- symbols = { added = " ", modified = " ", removed = " " },
	symbols = { added = icons.git.LineAdded,
              modified = icons.git.LineModified,
              removed = icons.git.LineRemoved },
  cond = hide_in_width
}

custom.branch = {
	"branch",
	icons_enabled = true,
  icon = icons.git.Branch,
}

custom.progress = {
  'progress',
  icon = { icons.devicons.out.icon, align = 'left' },
  -- separator = {left = icons.statusline_separators.default.left},
}

custom.location = {
  'location',
  padding = {left = 1, right = 0}
}

custom.lsp = {
  function()
    local out = " "
    if rawget(vim, "lsp") then
      for _, client in ipairs(vim.lsp.get_clients()) do
        if client.attached_buffers[vim.api.nvim_get_current_buf()] then
          -- out = "%#St_LspStatus#" .. "   LSP - " .. client.name
          if vim.o.columns < 100 then
            out = "  LSP"
          else
            -- out = "%#St_LspStatus#" .. "   LSP - " .. client.name
            out = "  " .. client.name
          end
        end
      end
    end
    return out
  end,
  color = {},
  cond = nil,
}

local options = {
  options = {
    theme = 'auto',
    globalstatus = true,
    icons_enabled = true,
    disabled_filetypes = {"alpha", "dashboard", "Outline"},
    always_divide_middle = true,
    section_separators = { left = '', right = ''},
    component_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {custom.mode},
    lualine_b = {},
    lualine_c = {custom.filetype, custom.filename, custom.branch, custom.diff},
    lualine_z = {},
    lualine_y = {},
    lualine_x = {custom.diagnostics, custom.lsp, custom.location, custom.progress}
  },
  inactive_sections = {
    lualine_a = {custom.mode},
    lualine_b = {},
    lualine_c = {custom.branch, custom.diff},
    lualine_x = {custom.diagnostics, custom.lsp, custom.progress, custom.location},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = { "lazy" },
}

return options

