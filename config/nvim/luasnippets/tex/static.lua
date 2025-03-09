local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")

local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

local line_begin = require("luasnip.extras.expand_conditions").line_begin
-- Environment/syntax context detection 
-- local tex = {}
-- tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
-- tex.in_text = function() return not tex.in_mathzone() end
-- tex.in_tikz = function()
--   local is_inside = vim.fn['vimtex#env#is_inside']("tikzpicture")
--   return (is_inside[1] > 0 and is_inside[2] > 0)
-- end

local tex = {}
tex.in_mathzone = function()  -- math context detection
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end
tex.in_comment = function()  -- comment detection
  return vim.fn['vimtex#syntax#in_comment']() == 1
end
tex.in_env = function(name)  -- generic environment detection
  local is_inside = vim.fn['vimtex#env#is_inside'](name)
  return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
tex.in_equation = function()  -- equation environment detection
  return tex.in_env('equation')
end
tex.in_itemize = function()  -- itemize environment detection
  return tex.in_env('itemize')
end
tex.in_tikz = function()  -- TikZ picture environment detection
  return tex.in_env('tikzpicture')
end

-- Return snippet tables
return
  {
    s({trig="LL", snippetType="autosnippet"}, { t("& "), }),
    s({trig="q"}, { t("\\quad "), }),
    s({trig="qq", snippetType="autosnippet"}, { t("\\qquad "), }),
    s({trig="np"}, { t("\\newpage"), }, {condition = line_begin}),
    -- s({trig="which", snippetType="autosnippet"}, {
    --     t("\\text{ for which } "),
    --   },
    --   {condition = tex.in_mathzone}
    -- ),
    -- s({trig="all", snippetType="autosnippet"},
    --   {
    --     t("\\text{ for all } "),
    --   },
    --   {condition = tex.in_mathzone}
    -- ),
    -- s({trig="and", snippetType="autosnippet"},
    --   {
    --     t("\\quad \\text{and} \\quad"),
    --   },
    --   {condition = tex.in_mathzone}
    -- ),
    -- s({trig="forall", snippetType="autosnippet"},
    --   {
    --     t("\\text{ for all } "),
    --   },
    --   {condition = tex.in_mathzone}
    -- ),
    -- s({trig = "toc", snippetType="autosnippet"},
    --   {
    --     t("\\tableofcontents"),
    --   },
    --   { condition = line_begin }
    -- ),
    s({trig="inff", snippetType="autosnippet"},
      {
        t("\\infty"),
      }
    ),
    s({trig="ii", snippetType="autosnippet"},
      {
        t("\\item "),
      },
      { condition = line_begin }
    ),
    s({trig = "--", snippetType="autosnippet"},
      {t('% --------------------------------------------- %')},
      {condition = line_begin}
    ),
    -- HLINE WITH EXTRA VERTICAL SPACE
    s({trig = "hl"},
      {t('\\hline {\\rule{0pt}{2.5ex}} \\hspace{-7pt}')},
      {condition = line_begin}
    ),
  }
