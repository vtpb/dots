local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

-- lua local configuration (redundant - variables are global)
local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

local tex = {}
-- Math context detection  for Markdown (treesitter)
tex.in_mathzone = require("plugins.configs.luasnip_treesitter_functions").in_mathzone
tex.in_text = function() return not tex.in_mathzone() end

return
{
  -- LEFT/RIGHT PARENTHESES
  s({trig = "([^%a])l%(", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\left(<>\\right",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- LEFT/RIGHT SQUARE BRACES
  s({trig = "([^%a])l%[", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\left[<>\\right",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- LEFT/RIGHT CURLY BRACES
  s({trig = "([^%a])l%{", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\left\\{<>\\right\\",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- BIG PARENTHESES
  s({trig = "([^%a])b%(", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\big(<>\\big",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- BIG SQUARE BRACES
  s({trig = "([^%a])b%[", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\big[<>\\big",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- BIG CURLY BRACES
  s({trig = "([^%a])b%{", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\big\\{<>\\big\\",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- ESCAPED CURLY BRACES
  s({trig = "([^%a])\\%{", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
    fmta(
      "<>\\{<>\\",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),

  -- LANGLE RANGLE
  s({trig = "([^%a])langle", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
    fmta(
      "<>\\langle <> \\rangle",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),


  -- SUPERSCRIPT
  s({trig = "([%w%)%]%}])^", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT
  s({trig = "([%w%)%]%}])__", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT AND SUPERSCRIPT
  s({trig = "([%w%)%]%}])_'", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>^{<>}_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- fraction
  s({ name = "Fraction", trig = "frac", snippetType="autosnippet" },
    fmta(
         "\\frac{<>}{<>}",
         {
           d(1, get_visual),
           i(2),
         }
     ),
     { condition = tex.in_mathzone }
  ),
  s({ name = "Fraction", trig = "ff", snippetType="autosnippet" },
    fmta(
         "\\frac{<>}{<>}",
         {
           d(1, get_visual),
           i(2),
         }
     ),
     { condition = tex.in_mathzone }
  ),
  -- vector, i.e. \vec
  s({trig = "([^%a])vec", wordtrig = false, regtrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\vec{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- -- SUM with lower limit
  -- s({trig = "([^%a])suml", wordTrig = false, regTrig = true},
  --   fmta(
  --     "<>\\sum_{<>}",
  --     {
  --       f( function(_, snip) return snip.captures[1] end ),
  --       i(1),
  --     }
  --   )
  -- ),
  -- SUM with upper and lower limit
  s({trig = "([^%a])sum", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\sum_{<>}^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- INTEGRAL with upper and lower limit
  -- s({trig = "([^%a])int", wordTrig = false, regTrig = true},
  --   fmta(
  --     "<>\\int_{<>}^{<>}",
  --     {
  --       f( function(_, snip) return snip.captures[1] end ),
  --       i(1),
  --       i(2),
  --     }
  --   )
  -- ),
  -- BOXED command
  -- s({trig = "([^%a])bb", wordTrig = false, regTrig = true, snippetType="autosnippet"},
  --   fmta(
  --     "<>\\boxed{<>}",
  --     {
  --       f( function(_, snip) return snip.captures[1] end ),
  --       d(1, get_visual)
  --     }
  --   ),
  --   {condition = tex.in_mathzone}
  -- ),
  -- BEGIN STATIC SNIPPETS
  --
  -- DIFFERENTIAL, i.e. \diff
  s({trig = "df",  snippetType="autosnippet"},
    {
      t("\\diff"),
    },
    {condition = tex.in_mathzone}
  ),
  -- GRADIENT OPERATOR, i.e. \grad
  s({trig = "gdd", snippetType="autosnippet"},
    {
      t("\\grad "),
    },
    {condition = tex.in_mathzone}
  ),
  -- CURL OPERATOR, i.e. \curl
  s({trig = "cll", snippetType="autosnippet"},
    {
      t("\\curl "),
    },
    {condition = tex.in_mathzone}
  ),
  -- DIVERGENCE OPERATOR, i.e. \divergence
  s({trig = "DI", snippetType="autosnippet"},
    {
      t("\\div "),
    },
    {condition = tex.in_mathzone}
  ),
  -- LAPLACIAN OPERATOR, i.e. \laplacian
  s({trig = "laa", snippetType="autosnippet"},
    {
      t("\\laplacian "),
    },
    {condition = tex.in_mathzone}
  ),
  -- partial
  s({trig = "par", snippetType="autosnippet"},
    {
      t("\\partial "),
    },
    {condition = tex.in_mathzone}
  ),

  -- PARALLEL SYMBOL, i.e. \parallel
  -- s({trig = "||", snippetType="autosnippet"},
  --   {
  --     t("\\parallel"),
  --   }
  -- ),
  --
  -- CROSS PRODUCT, i.e. \times
  s({trig = "xx", snippetType="autosnippet"},
    {
      t("\\times "),
    },
    {condition = tex.in_mathzone}
  ),
  s({trig="\\inf", snippetType="autosnippet"},
    {
      t("\\infty"),
    },
  {condition = tex.in_mathzone}
  ),
}
