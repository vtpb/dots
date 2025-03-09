local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Math context detection 
local tex = {}
tex.in_mathzone = function()  -- math context detection
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex.in_text = function() return not tex.in_mathzone() end

-- TODO: todonotes usepackage and snippets.
-- TODO: Latex base templates
-- TODO: Beamer templates
-- TODO: beamer only functions

-- Return snippet tables
return
  {
    -- ANNOTATE (custom command for annotating equation derivations)
    s({trig = "ann", snippetType="autosnippet"},
      fmta(
        [[
      \annotate{<>}{<>}
      ]],
        {
          i(1),
          d(2, get_visual),
        }
      )
    ),
    -- REFERENCE
    s({trig = " RR", snippetType="autosnippet", wordTrig=false},
      fmta(
        [[
      ~\ref{<>}
      ]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- LABEL
    s({trig = "lbl", snippetType="autosnippet"},
      fmta(
        [[
      \label{<>}
      ]],
        {
          d(1, get_visual),
        }
      )
    ),
    s({trig="sii", snippetType="autosnippet"},
      fmta(
        [[\si{<>}]],
        {
          i(1),
        }
      )
    ),
    s({trig="SI", snippetType="autosnippet"},
      fmta(
        [[\SI{<>}{<>}]],
        {
          i(1),
          i(2)
        }
      )
    ),
    s({trig="url"},
      fmta(
        [[\url{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- VSPACE
    s({trig="vspace"},
      fmta(
        [[\vspace{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- SECTION
    s({trig="h1", snippetType="autosnippet"},
      fmta(
        [[\section{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- SUBSECTION
    s({trig="h2", snippetType="autosnippet"},
      fmta(
        [[\subsection{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- SUBSUBSECTION
    s({trig="h3", snippetType="autosnippet"},
      fmta(
        [[\subsubsection{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- USE A LATEX PACKAGE
    -- s({trig = "pack", snippetType="autosnippet"},
    --   fmta(
    --     [[
    --     \usepackage{<>}
    --     ]],
    --     {
    --       d(1, get_visual),
    --     }
    --   ),
    --   { condition = line_begin }
    -- ),
    -- INPUT a LaTeX file
    -- s({trig = "inn", snippetType="autosnippet"},
    --   fmta(
    --     [[
    --   \input{<><>}
    --   ]],
    --     {
    --       i(1, "~/dotfiles/config/latex/templates/"),
    --       i(2)
    --     }
    --   ),
    --   { condition = line_begin }
    -- ),
    -- HPHANTOM
    -- s({trig = "hpp", snippetType="autosnippet"},
    --   fmta(
    --     [[
    --   \hphantom{<>}
    --   ]],
    --     {
    --       d(1, get_visual),
    --     }
    --   )
    -- ),
    -- s({trig = "TODOO", snippetType="autosnippet"},
    --   fmta(
    --     [[\TODO{<>}]],
    --     {
    --       d(1, get_visual),
    --     }
    --   )
    -- ),
    -- s({trig="nc"},
    --   fmta(
    --     [[\newcommand{<>}{<>}]],
    --     {
    --       i(1),
    --       i(2)
    --     }
    --   ),
    --   {condition = line_begin}
    -- ),
  }
