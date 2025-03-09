local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local function get_visual(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return
  {
    -- Fenced block of code
    s({trig="cc", snippetType="autosnippet"},
      fmta(
        [[
        ```<>
        <>
        ```
      ]],
        {
          i(1),
          d(2, get_visual),
        }
      ),
      {condition = line_begin}
    ),
    -- LINK
    s({trig="LL", wordTrig=true, snippetType="autosnippet"},
      fmta(
        [[[<>](<>)]],
        {
          d(1, get_visual),
          i(2),
        }
      )
    ),
  }
