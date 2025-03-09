local M = {}

M.kind = {
  Array = " ",
  -- Boolean = " ",
  Boolean = " ",
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  -- Constructor = " ",
  -- Copilot = " ",
  Copilot = " ",
  Enum = " ",
  -- Enum = " ",
  EnumMember = " ",
  -- EnumMember = " ",
  Event = " ",
  -- Event = " ",
  -- Field = "ﰠ ",
  Field = " ",
  File = " ",
  Folder = " ",
  -- Function = " ",
  Function = " ",
  Interface = " ",
  -- Interface = " ",
  Key = " ",
  Keyword = " ",
  -- Method = " ",
  Method = " ",
  -- Module = " ",
  Module = " ",
  Namespace = " ",
  Null = "ﳠ",
  -- Null = " ",
  -- Number = " ",
  Number = " ",
  Object = " ",
  -- Operator = " ",
  Operator = " ",
  -- Package = "",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  -- Snippet = " ",
  String = " ",
  Struct = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = " ",
  -- Variable = " ",

  -- others
  Table = "",
  Tag = "",
  Calendar = "",
  Watch = "󰥔",
}

M.git = {
  LineAdded = " ",
  LineModified = " ",
  LineRemoved = " ",
  FileDeleted = " ",
  FileIgnored = "◌ ",
  FileRenamed = "➜ ",
  FileStaged = "S ",
  FileUnmerged = " ",
  FileUnstaged = " ",
  FileUntracked = "U ",
  Diff = " ",
  Repo = " ",
  Octoface = " ",
  Branch = "",
  Github = " ",
}

M.statusline_separators = {
  default = {
    left = "",
    right = " ",
  },
  round = {
    left = "",
    right = "",
  },
  block = {
    left = "█",
    right = "█",
  },
  arrow = {
    left = "",
    right = "",
  },
}

M.diagnostics = {
  Error = " ",
  Warn = " ",
  Info = " ",
  Hint = " ",
}

M.devicons = {
  default_icon = {
    icon = "󰈚",
    name = "Default",
  },

  c = {
    icon = "",
    name = "c",
  },

  css = {
    icon = "",
    name = "css",
  },

  deb = {
    icon = "",
    name = "deb",
  },

  Dockerfile = {
    icon = "",
    name = "Dockerfile",
  },

  html = {
    icon = "",
    name = "html",
  },

  jpeg = {
    icon = "󰉏",
    name = "jpeg",
  },

  jpg = {
    icon = "󰉏",
    name = "jpg",
  },

  js = {
    icon = "󰌞",
    name = "js",
  },

  kt = {
    icon = "󱈙",
    name = "kt",
  },

  lock = {
    icon = "󰌾",
    name = "lock",
  },

  lua = {
    icon = "",
    name = "lua",
  },

  mp3 = {
    icon = "󰎆",
    name = "mp3",
  },

  mp4 = {
    icon = "",
    name = "mp4",
  },

  out = {
    icon = "",
    name = "out",
  },

  png = {
    icon = "󰉏",
    name = "png",
  },

  py = {
    icon = "",
    name = "py",
  },

  ["robots.txt"] = {
    icon = "󰚩",
    name = "robots",
  },

  toml = {
    icon = "",
    name = "toml",
  },

  ts = {
    icon = "󰛦",
    name = "ts",
  },

  ttf = {
    icon = "",
    name = "TrueTypeFont",
  },

  rb = {
    icon = "",
    name = "rb",
  },

  rpm = {
    icon = "",
    name = "rpm",
  },

  vue = {
    icon = "󰡄",
    name = "vue",
  },

  woff = {
    icon = "",
    name = "WebOpenFontFormat",
  },

  woff2 = {
    icon = "",
    name = "WebOpenFontFormat2",
  },

  xz = {
    icon = "",
    name = "xz",
  },

  zip = {
    icon = "",
    name = "zip",
  },
  vim = {
    icon = " ",
    name = "vim",
  },
  neovim = {
    icon = " ",
    -- icon = " ",
    name = "neovim",
  },
}

M.bufferline = {
  close = "",
  modified_icon = "●",
  close_buffer = "󰅖",
}

return M
