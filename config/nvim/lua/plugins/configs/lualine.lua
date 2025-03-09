local icons = require("core.ui.icons")

local hide_in_width = function()
    return vim.o.columns > 100
end

-- custom components
local filetype = {
  'filetype',
  colored = true,
  icon_only = true,
  icon = { align = 'right' },
}

local fn = { 
  'filename', 
  colored = true,
  path = 1, 
  symbols = { modified = "  ", readonly = "", unnamed = "" },
}

local mode = {
  'mode',
  icon = {icons.devicons.vim.icon, align = 'left'},
  -- padding = {left = 0, right = 0},
}

local diagnostics = {
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

local diff = {
	"diff",
	colored = false,
	-- symbols = { added = " ", modified = " ", removed = " " },
	symbols = { added = icons.git.LineAdded,
              modified = icons.git.LineModified,
              removed = icons.git.LineRemoved },
  cond = hide_in_width
}

local branch = {
	"branch",
	icons_enabled = true,
  icon = icons.git.Github,
}

local cwd = {
  function()
    local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    if vim.o.columns > 85 then
      return "%#St_cwd_sep#" .. dir_name
    end
  end,
  color = {},
  icon = {
    icons.kind.Folder,
    color = {},
    align = 'left'
  },
  cond = hide_in_width,
  separator = {left = icons.statusline_separators.default.left},
}

local progress = {
  'progress',
  icon = { icons.devicons.out.icon, align = 'left' },
  separator = {left = icons.statusline_separators.default.left},
}

-- cool function for progress
local progress_bar = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local lsp = {
  function()
    local out = " "
    if rawget(vim, "lsp") then
      for _, client in ipairs(vim.lsp.get_active_clients()) do
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
    section_separators = { left = icons.statusline_separators.default.right, right = ''},
    component_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {mode},
    lualine_b = { 
      -- filetype, 
      -- { 
      --   'filename', 
      --   path = 1, 
      --   symbols = { modified = "  ", readonly = "", unnamed = "" },
      -- },
    },
    lualine_c = {
      filetype,
      fn,
      branch, 
      diff
    },
    -- lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_x = {diagnostics, lsp},
    lualine_y = {},
    -- lualine_y = {cwd},
    lualine_z = {
      { 
        "location", 
        padding = { left = 0, right = 0 }, 
      },
      {
        'progress',
        separator = {left = icons.statusline_separators.default.left},
        icon = { icons.devicons.out.icon, align = 'left' },
      },
    }
  },
  -- inactive_sections = {
  --   lualine_a = {mode},
  --   lualine_b = {filetype, 'filename'},
  --   lualine_c = {branch, diff},
  --   lualine_x = {diagnostics},
  --   lualine_y = {lsp, cwd},
  --   lualine_z = {progress}
  -- --  lualine_a = {},
  -- --  lualine_b = {},
  -- --  lualine_c = {},
  -- --  lualine_x = {'encoding'},
  -- --  lualine_y = {},
  -- --  lualine_z = {},
  -- },
  tabline = {},
  extensions = { "lazy" },
}

return options
