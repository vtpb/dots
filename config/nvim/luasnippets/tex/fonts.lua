local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
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

local line_begin = require("luasnip.extras.expand_conditions").line_begin
local tex = {}
tex.in_mathzone = function()  -- math context detection
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end

return {
    s({trig = "\\texttt", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
      fmta(
        "<>\\texttt{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_text}
    ),
    -- s({trig = "\\ttt", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
    s({trig = "([^%a])\\ttt", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
      fmta(
        "<>\\texttt{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_text}
    ),
    -- ITALIC i.e. \textit
    -- s({trig = "\\tit", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    s({trig = "([^%a])\\tit", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\textit{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_text}
    ),
    s({trig = "\\textit", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\textit{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_text}
    ),
    -- BOLD i.e. \textbf
    s({trig = "\\tbf", snippetType="autosnippet"},
      fmta(
        "\\textbf{<>}",
        {
          d(1, get_visual),
        }
      ),
      {condition = tex.in_text}
    ),
    s({trig = "\\textbf", snippetType="autosnippet"},
      fmta(
        "\\textbf{<>}",
        {
          d(1, get_visual),
        }
      ),
      {condition = tex.in_text}
    ),
    -- MATH ROMAN i.e. \mathrm
    -- s({trig = "([^%a])\\mr", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    s({trig = "\\mrm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathrm{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_mathzone}
    ),
    s({trig = "\\mathrm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathrm{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_mathzone}
    ),
    -- MATH CALIGRAPHY i.e. \mathcal
    -- s({trig = "\\mcl", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    s({trig = "([^%a])\\mc", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathcal{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_mathzone}
    ),
    s({trig = "\\mathcal", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathcal{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_mathzone}
    ),
    -- MATH BOLDFACE i.e. \mathbf
    -- s({trig = "\\mbf", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    s({trig = "([^%a])\\mbf", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathbf{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_mathzone}
    ),
    s({trig = "\\mathbf", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathbf{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_mathzone}
    ),
    -- MATH BLACKBOARD i.e. \mathbb
    -- s({trig = "\\mbb", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    s({trig = "([^%a])\\mbb", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathbb{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_mathzone}
    ),
    s({trig = "\\mathbb", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathbb{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_mathzone}
    ),
    -- REGULAR TEXT i.e. \text (in math environments)
    -- s({trig = "([^%a])\\txt", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    s({trig = "\\txt", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\text{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_mathzone}
    ),
    s({trig = "\\text", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\text{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_mathzone}
    ),
}
