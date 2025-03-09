local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node

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
  return not tex_utils.in_mathzone()
end

-- Return snippet tables
return
{
  s({trig=";a", snippetType="autosnippet"}, { t("\\alpha") }, {condition = tex.in_mathzone}),
  s({trig=";b", snippetType="autosnippet"}, { t("\\beta") }, {condition = tex.in_mathzone}),
  s({trig=";g", snippetType="autosnippet"}, { t("\\gamma") }, { condition = tex.in_mathzone}),
  s({trig=";G", snippetType="autosnippet"}, { t("\\Gamma") }, { condition = tex.in_mathzone}),
  s({trig=";d", snippetType="autosnippet"}, { t("\\delta") }, { condition = tex.in_mathzone}),
  s({trig=";D", snippetType="autosnippet"}, { t("\\Delta") }, { condition = tex.in_mathzone}),
  s({trig=";e", snippetType="autosnippet"}, { t("\\epsilon") }, { condition = tex.in_mathzone}),
  s({trig=";ve", snippetType="autosnippet"}, { t("\\varepsilon") }, { condition = tex.in_mathzone}),
  s({trig=";z", snippetType="autosnippet"}, { t("\\zeta") }, { condition = tex.in_mathzone}),
  s({trig=";h", snippetType="autosnippet"}, { t("\\eta") }, { condition = tex.in_mathzone}),
  s({trig=";o", snippetType="autosnippet"}, { t("\\theta") }, { condition = tex.in_mathzone}),
  s({trig=";vo", snippetType="autosnippet"}, { t("\\vartheta") }, { condition = tex.in_mathzone}),
  s({trig=";O", snippetType="autosnippet"}, { t("\\Theta") }, { condition = tex.in_mathzone}),
  s({trig=";k", snippetType="autosnippet"}, { t("\\kappa") }, { condition = tex.in_mathzone}),
  s({trig=";l", snippetType="autosnippet"}, { t("\\lambda") }, { condition = tex.in_mathzone}),
  s({trig=";L", snippetType="autosnippet"}, { t("\\Lambda") }, { condition = tex.in_mathzone}),
  s({trig=";m", snippetType="autosnippet"}, { t("\\mu") }, { condition = tex.in_mathzone}),
  s({trig=";n", snippetType="autosnippet"}, { t("\\nu") }, { condition = tex.in_mathzone}),
  s({trig=";x", snippetType="autosnippet"}, { t("\\xi") }, { condition = tex.in_mathzone}),
  s({trig=";X", snippetType="autosnippet"}, { t("\\Xi") }, { condition = tex.in_mathzone}),
  s({trig=";i", snippetType="autosnippet"}, { t("\\pi") }, { condition = tex.in_mathzone}),
  s({trig=";I", snippetType="autosnippet"}, { t("\\Pi") }, { condition = tex.in_mathzone}),
  s({trig=";r", snippetType="autosnippet"}, { t("\\rho") }, { condition = tex.in_mathzone}),
  s({trig=";s", snippetType="autosnippet"}, { t("\\sigma") }, { condition = tex.in_mathzone}),
  s({trig=";S", snippetType="autosnippet"}, { t("\\Sigma") }, { condition = tex.in_mathzone}),
  s({trig=";t", snippetType="autosnippet"}, { t("\\tau") }, { condition = tex.in_mathzone}),
  s({trig=";f", snippetType="autosnippet"}, { t("\\phi") }, { condition = tex.in_mathzone}),
  s({trig=";vf", snippetType="autosnippet"}, { t("\\varphi") }, { condition = tex.in_mathzone}),
  s({trig=";F", snippetType="autosnippet"}, { t("\\Phi") }, { condition = tex.in_mathzone}),
  s({trig=";c", snippetType="autosnippet"}, { t("\\chi") }, { condition = tex.in_mathzone}),
  s({trig=";p", snippetType="autosnippet"}, { t("\\psi") }, { condition = tex.in_mathzone}),
  s({trig=";P", snippetType="autosnippet"}, { t("\\Psi") }, { condition = tex.in_mathzone}),
  s({trig=";w", snippetType="autosnippet"}, { t("\\omega") }, { condition = tex.in_mathzone}),
  s({trig=";W", snippetType="autosnippet"}, { t("\\Omega") }, { condition = tex.in_mathzone}),
  -- text mode
  -- s({trig=";a", snippetType="autosnippet"}, { t("$\\alpha$"), }, {condition = tex.in_text}),
  -- s({trig=";b", snippetType="autosnippet"}, { t("$\\beta$") }, {condition = tex.in_text}),
  -- s({trig=";g", snippetType="autosnippet"}, { t("$\\gamma$") }, { condition = tex.in_text}),
  -- s({trig=";G", snippetType="autosnippet"}, { t("$\\Gamma$") }, { condition = tex.in_text}),
  -- s({trig=";d", snippetType="autosnippet"}, { t("$\\delta$") }, { condition = tex.in_text}),
  -- s({trig=";D", snippetType="autosnippet"}, { t("$\\Delta$") }, { condition = tex.in_text}),
  -- s({trig=";e", snippetType="autosnippet"}, { t("$\\epsilon$") }, { condition = tex.in_text}),
  -- s({trig=";ve", snippetType="autosnippet"}, { t("$\\varepsilon$") }, { condition = tex.in_text}),
  -- s({trig=";z", snippetType="autosnippet"}, { t("$\\zeta$") }, { condition = tex.in_text}),
  -- s({trig=";h", snippetType="autosnippet"}, { t("$\\eta$") }, { condition = tex.in_text}),
  -- s({trig=";o", snippetType="autosnippet"}, { t("$\\theta$") }, { condition = tex.in_text}),
  -- s({trig=";vo", snippetType="autosnippet"}, { t("$\\vartheta$") }, { condition = tex.in_text}),
  -- s({trig=";O", snippetType="autosnippet"}, { t("$\\Theta$") }, { condition = tex.in_text}),
  -- s({trig=";k", snippetType="autosnippet"}, { t("$\\kappa$") }, { condition = tex.in_text}),
  -- s({trig=";l", snippetType="autosnippet"}, { t("$\\lambda$") }, { condition = tex.in_text}),
  -- s({trig=";L", snippetType="autosnippet"}, { t("$\\Lambda$") }, { condition = tex.in_text}),
  -- s({trig=";m", snippetType="autosnippet"}, { t("$\\mu$") }, { condition = tex.in_text}),
  -- s({trig=";n", snippetType="autosnippet"}, { t("$\\nu$") }, { condition = tex.in_text}),
  -- s({trig=";x", snippetType="autosnippet"}, { t("$\\xi$") }, { condition = tex.in_text}),
  -- s({trig=";X", snippetType="autosnippet"}, { t("$\\Xi$") }, { condition = tex.in_text}),
  -- s({trig=";i", snippetType="autosnippet"}, { t("$\\pi$") }, { condition = tex.in_text}),
  -- s({trig=";I", snippetType="autosnippet"}, { t("$\\Pi$") }, { condition = tex.in_text}),
  -- s({trig=";r", snippetType="autosnippet"}, { t("$\\rho$") }, { condition = tex.in_text}),
  -- s({trig=";s", snippetType="autosnippet"}, { t("$\\sigma$") }, { condition = tex.in_text}),
  -- s({trig=";S", snippetType="autosnippet"}, { t("$\\Sigma$") }, { condition = tex.in_text}),
  -- s({trig=";t", snippetType="autosnippet"}, { t("$\\tau$") }, { condition = tex.in_text}),
  -- s({trig=";f", snippetType="autosnippet"}, { t("$\\phi$") }, { condition = tex.in_text}),
  -- s({trig=";vf", snippetType="autosnippet"}, { t("$\\varphi$") }, { condition = tex.in_text}),
  -- s({trig=";F", snippetType="autosnippet"}, { t("$\\Phi$") }, { condition = tex.in_text}),
  -- s({trig=";c", snippetType="autosnippet"}, { t("$\\chi$") }, { condition = tex.in_text}),
  -- s({trig=";p", snippetType="autosnippet"}, { t("$\\psi$") }, { condition = tex.in_text}),
  -- s({trig=";P", snippetType="autosnippet"}, { t("$\\Psi$") }, { condition = tex.in_text}),
  -- s({trig=";w", snippetType="autosnippet"}, { t("$\\omega$") }, { condition = tex.in_text}),
  -- s({trig=";W", snippetType="autosnippet"}, { t("$\\Omega$") }, { condition = tex.in_text}),
}
