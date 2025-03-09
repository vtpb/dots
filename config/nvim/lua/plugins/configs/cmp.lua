local cmp = require "cmp"

-- vim.o.completeopt = "menu,menuone,noselect"

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_window = require "cmp.utils.window"

cmp_window.info_ = cmp_window.info
cmp_window.info = function(self)
  local info = self:info_()
  info.scrollable = false
  return info
end

local options = {
  completion = {
    -- completeopt = "menu,menuone",
    completeopt = "menu,menuone,noinsert",
  },
  window = {
    completion = {
      border = border "CmpBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
      scrollbar = false,
    },
    documentation = {
      border = border "CmpDocBorder",
      winhighlight = "Normal:CmpDoc"
    },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(_, vim_item)
      local icons = require("core.ui.icons").kind
      vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
      return vim_item
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    -- ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),
    -- ["<Tab>"] = cmp.mapping(
    --   cmp.mapping.confirm {
    --     behavior = cmp.ConfirmBehavior.Insert,
    --     select = true,
    --   },
    --   { "i", "c" }
    -- ),
    -- Arrows as navigation
    ["<Down>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      end
    end, { "i", "s", }),
    ["<Up>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end, { "i", "s", }),
    -- -- Tab for snippets and CMP completion
    -- ["<Tab>"] = cmp.mapping(function(fallback)
    --   if require("luasnip").expand_or_locally_jumpable() then
    --     require("luasnip").expand_or_jump()
    --   elseif has_words_before() then
    --     cmp.mapping.confirm {
    --       behavior = cmp.ConfirmBehavior.Insert,
    --       select = true,
    --     }
    --   else
    --     fallback()
    --   end
    -- end, { "i", "c" }),
  },
  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "buffer" },
    -- { name = "nvim_lua" },
    { name = "path" },
  },
}

return options
-- cmp.setup(options)
