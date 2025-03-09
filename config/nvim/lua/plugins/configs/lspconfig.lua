local present, lspconfig = pcall(require, "lspconfig")
if not present then return end

local util = require("lspconfig.util")

local function lspSymbol(name, icon)
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

lspSymbol("Error", "")
lspSymbol("Info", "")
lspSymbol("Hint", "")
lspSymbol("Warn", "")

vim.diagnostic.config {
  virtual_text = {
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
  focusable = false,
  relative = "cursor",
})

-- suppress error messages from lang servers
vim.notify = function(msg, log_level)
  if msg:match "exit code" then
    return
  end
  if log_level == vim.log.levels.ERROR then
    vim.api.nvim_err_writeln(msg)
  else
    vim.api.nvim_echo({ { msg } }, true, {})
  end
end

local M = {}

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  -- mappings for lsp
  require("core.mappings").lspconfig({ buffer = bufnr })

  -- if client.server_capabilities.signatureHelpProvider then
  --   require("nvchad_ui.signature").setup(client)
  -- end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

lspconfig.bashls.setup{
  on_attach = M.on_attach,
  cmd = { "bash-language-server", "start" },
  cmd_env = {
    GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)"
  },
  filetypes = { "sh" },
  root_dir = lspconfig.util.find_git_ancestor,
  single_file_support = true,
}

lspconfig.fortls.setup{
  on_attach = M.on_attach,
  cmd = {
    "fortls",
    "--notify_init",
    "--hover_signature",
    "--hover_language=fortran",
    "--use_signature_help"
  },
  filetypes = { "fortran" },
  root_dir = lspconfig.util.root_pattern(".fortls"),
  settings = {},
}

lspconfig.pyright.setup{
  on_attach = M.on_attach,
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  -- root_dir = ,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  },
  single_file_support = true,
}

-- texlab
lspconfig.texlab.setup{
  on_attach = M.on_attach,
  cmd = { "texlab" },
  filetypes = { "tex", "plaintex", "bib"},
  root_dir = function(fname)
    return util.root_pattern '.latexmkrc'(fname) or util.find_git_ancestor(fname) or util.root_pattern 'main.tex'(fname)
  end,
  -- root_dir = function() return '.' end,
  settings = {
    texlab = {
      auxDirectory = ".",
      bibtexFormatter = "texlab",
      build = {
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        executable = "latexmk",
        forwardSearchAfter = false,
        onSave = false
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = false
      },
      diagnosticsDelay = 300,
      diagnostics = {
        ignoredPatterns = {
          'Underfull',
          'Overfull',
        }
      },
      formatterLineLength = 80,
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = false
      },
      forwardSearch = {
        executable = "zathura",
        args = {"--synctex-forward", "%l:1:%f", "%p"},
        -- executable = "okular",
        -- args = { "--unique", "file:%p#src:%l%f" },
      }
    }
  },
  single_file_support = true
}


-- workaround for math context detection in markdown, using vimtex
-- for use of latex math snippets
-- vim.cmd [[ autocmd BufRead,BufNewFile *.md set filetype=tex ]]
-- NOTE: does not work. texlab is eventually loaded.
lspconfig.marksman.setup{
  cmd = {"marksman", "server"},
  filetypes = {"markdown"},
  root_dir = util.root_pattern(".git", ".marksman.toml"),
  settings = {
    code_action = {
      toc = {
        enable = true,
      },
    },
    completion = {
      wiki = {
        style = "file-stem" -- title-slug (def), file-stem, file-path-stem
      },
    },
  },
  single_file_support = true,
}

-- ltex (language tool for LaTeX, Markdown, others)
-- to support org files
-- vim.cmd [[ autocmd BufRead,BufNewFile *.org set filetype=org ]]
-- lspconfig.ltex.setup{
--  cmd = { "ltex-ls" },
--  filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" },
--  get_language_id =  see source file,
--  root_dir =  see source file,
--  single_file_support = true,
-- }


return M
