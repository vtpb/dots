local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node

local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Return snippet tables
return
  {
    -- EQUATION
    s({trig="\\eq"},
      fmta(
        [[
        \begin{equation*}
            <>
        \end{equation*}
      ]],
        {
          i(1),
        }
      ),
      { condition = line_begin }
    ),
    -- ALIGN
    s({trig="\\all"},
      fmta(
        [[
        \begin{align*}
            <>
        \end{align*}
      ]],
        {
          i(1),
        }
      ),
      {condition = line_begin}
    ),
  }
