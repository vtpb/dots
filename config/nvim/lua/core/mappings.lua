local keymap = vim.keymap
local merge_tb = vim.tbl_deep_extend

local M = {}

M.general = function()

  keymap.set("i", "<C-b>", "<ESC>^i", { desc = "go to [b]eginning of line" })
  keymap.set("i", "<C-e>", "<End>", { desc = "go to [e]nd of line" })
  keymap.set("i", "jj", "<Esc>", { desc = "alt escape" })
  -- keymap.set("i", "kj", "<Esc>", { desc = "alt escape" })
  keymap.set("i", "kk", "<Esc>", { desc = "alt escape" })

  keymap.set("n", "<ESC>", "<cmd> noh <CR>", 
    { desc = "escape with no highlight" })
  keymap.set("n", "gf", "<cmd>edit <cfile><CR>",
    { desc = "go to file (create if non-existent)" })

  -- switch between windows (see navigator.nvim)
  -- keymap.set("n", "<C-h>", "<C-w>h", { desc = "window left" }) -- left
  -- keymap.set("n", "<C-j>", "<C-w>j", { desc = "window down" }) -- down
  -- keymap.set("n", "<C-k>", "<C-w>k", { desc = "window up" }) -- up
  -- keymap.set("n", "<C-l>", "<C-w>l", { desc = "window right" }) -- right
  -- resize windows
  keymap.set("n", "<Up>", "<cmd> resize +2 <CR>", { desc = "resize vert +2" })
  keymap.set("n", "<Down>", "<cmd> resize -2 <CR>",
    { desc = "resize vert -2" })
  keymap.set("n", "<Left>", "<cmd> vertical resize +2 <CR>",
    { desc = "resize hor. +2" })
  keymap.set("n", "<Right>", "<cmd> vertical resize -2 <CR>",
    { desc = "resize hor. -2" })

  -- buffers (handled by bufferline plugin)
  keymap.set("n", "<leader>bq", "<cmd> bp <BAR> bd #<CR>",
    { desc = "close buffer" })
  
  -- splits
  -- keymap.set("n", "sh", "<cmd> split<Return><C-w>w",
  --   { silent = true, desc = "split horizontally" })
  -- keymap.set("n", "sv", "<cmd> vsplit<Return><C-w>w",
  --   { silent = true, desc = "split vertically" })

  keymap.set("n", "<C-q>", "gqip",
    { desc = "hard-wrap paragraph" }) -- hard-wrap paragraph text
  keymap.set("n", "<leader>ew", "<cmd>  set nowrap <CR>",
    { desc = "set nowrap" }) -- set no-wrap

  -- spell language
  keymap.set("n", "<leader>scp", "<cmd> setlocal spell spelllang=pt <CR>",
    { desc = "set spell PT" })
  keymap.set("n", "<leader>sce", "<cmd> setlocal spell spelllang=en_gb <CR>",
    { desc = "set spell EN_GB" })
  keymap.set("n", "<leader>sca", "<cmd> setlocal spell spelllang=en_gb,pt <CR>",
    { desc = "set spell EN_GB + PT" })

  -- line numbers
  keymap.set("n", "<leader>en", "<cmd> set nu! <CR>",
    { desc = "toggle number" }) -- toggle
  keymap.set("n", "<leader>er", "<cmd> set rnu! <CR>",
    { desc = "toggle relative number" }) -- toggle relative

  -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
  -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
  -- empty mode is same as using <cmd> :map
  -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
  keymap.set("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 
    { expr = true })
  keymap.set("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
    { expr = true })
  keymap.set("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
    { expr = true })
  keymap.set("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
    { expr = true })
  -- visual
  keymap.set("v", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
    { expr = true })
  keymap.set("v", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
    { expr = true })

  keymap.set("x", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"' , 
    { expr = true })
  keymap.set("x", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"' ,
    { expr = true })
  -- Don't copy the replaced text after pasting in visual mode
  keymap.set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })
  keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste without updating register" })

  -- indents
  vim.keymap.set("v", "<", "<gv", { desc = "Stay in visual mode during outdent" })
  vim.keymap.set("v", ">", ">gv", { desc = "Stay in visual mode during indent" })

  -- command aliases
  keymap.set("c", "W<CR>", vim.cmd.w) -- save file
  keymap.set("c", "Wq<CR>", vim.cmd.wq) -- save file and quit
  keymap.set("c", "WQ<CR>", vim.cmd.wq) -- save file and quit
  keymap.set("c", "Q<CR>", vim.cmd.wq) -- quit file
end

M.plugins = function()
  -- Plugins (for lazy load) --
  -- obsidian.nvim plugin - open daily note
  keymap.set({'n'}, '<leader>ot', 
    function() 
      require("obsidian")
      return "<cmd>ObsidianToday<CR>"
      -- print("Opening daily note...")
    end, 
    {desc = 'open daily note'})

  -- zenmode
  keymap.set({'n'}, '<leader>ez', 
    function() 
      local present, zenmode = pcall(require, "zen-mode")
      if not present then
        return print("Warning: zenmode not enabled/installed.")
      end
      zenmode.toggle()
      -- require("zenmode")
      --return vim.cmd.ZenMode 
    end, 
    { desc = 'toggle zenmode' })
  -- twilight
  keymap.set({'n'}, '<leader>et', 
    function() 
      local present, twilight = pcall(require, "twilight")
      if not present then
        return print("Warning: Twilight not enabled/installed.")
      end
      -- require("twilight")
      return vim.cmd.Twilight
    end, 
    {desc = 'toggle twilight'})
  -- ufo
  keymap.set("n", "zR", 
  function()
    local present, ufo = pcall(require, "ufo")
    if not present then
      return print("Warning: ufo not enabled/installed.")
    end
    return ufo.openAllFolds
  end,
  { desc = "folds - open all"})
  keymap.set("n", "zM", 
    function()
      local present, ufo = pcall(require, "ufo")
      if not present then
        return print("Warning: ufo not enabled/installed.")
      end
      return ufo.closeAllFolds
    end,
  { desc = "folds - close all"})
end

-- bufferline/buffers (<leader>b)
M.bufferline = function()
  keymap.set("n", "<leader>bn", "<cmd> enew <CR>", { desc = "new buffer" })
  keymap.set("n", "<S-l>", vim.cmd.BufferLineCycleNext, 
    { desc = "next buffer" })
  keymap.set("n", "<S-h>", vim.cmd.BufferLineCyclePrev,
    { desc = "previous buffer" })
  keymap.set("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", {desc = "pin buffer"})
  keymap.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", {desc = "delete non-pinned buffers"})
end

-- M.comment = {
--   -- toggle comment in both modes
--   keymap.set("n", "<leader>/", function() require("Comment.api").toggle.linewise.current() end)
-- 
--   -- toggle comment
--   keymap.set("v", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")
-- }

-- TODO: description of mappings, revise mappings
M.lspconfig = function( bufopts )
  keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- buffer format - requires null-ls
  keymap.set('n', 
    '<leader>fm', 
    function() vim.lsp.buf.format { async = true } end, 
    bufopts, 
    { desc = "format file on save" })
  -- diagnostics - replaced by Trouble.nvim
  -- keymap.set("n", "<leader>df", function() vim.diagnostic.open_float() end, { desc = "open float" })
  -- keymap.set("n", "<leader>dq", function() vim.diagnostic.setloclist() end, { desc = "list" })
  keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, { desc = "prev diagnostic" })
  keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "next diagnostic" })
end

M.nvimtree = function()
  keymap.set("n", "<leader>-t>", vim.cmd.NvimTreeToggle, 
    { desc = "toggle nvimtree" })
  -- keymap.set("n", "<leader>e", vim.cmd.NvimTreeFocus, 
  --   { desc = "focus on nvimtree" })
end

-- telescope = find (f)
M.telescope = function()
  keymap.set("n", "<leader>ff", "<cmd> Telescope find_files <CR>", 
    { desc = "files in cwd" })
  keymap.set("n", "<leader>fa", 
    "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", 
    { desc = "all files in cwd" })
  keymap.set("n", "<leader>fw", "<cmd> Telescope live_grep <CR>", 
    { desc = "words (grep)" })
  keymap.set("n", "<leader>fb", "<cmd> Telescope buffers <CR>", 
    { desc = "buffers" })
  keymap.set("n", "<leader>fh", "<cmd> Telescope help_tags <CR>", 
    { desc = "help" })
  keymap.set("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>", 
    { desc = "oldfiles" })
  keymap.set("n", "<leader>fk", "<cmd> Telescope keymaps <CR>", 
    { desc = "keymaps" })
  -- git
  keymap.set("n", "<leader>gc", "<cmd> Telescope git_commits <CR>", 
    { desc = "telescope git commits"})
  keymap.set("n", "<leader>ga", "<cmd> Telescope git_status <CR>",
    { desc = "telescope git status" })
  -- pick a hidden term
  -- keymap.set("n", "<leader>pt", "<cmd> Telescope terms <CR>") -- pick a hidden term
  -- theme switcher
  -- keymap.set("n", "<leader>th", "<cmd> Telescope themes <CR>") -- themes
  keymap.set("n", "<leader>fu", "<cmd> Telescope undo <CR>",
    { desc = "undo" })
end

M.blankline = function()
  -- TODO: not working, fix
  keymap.set("n", "<leader>cc",
    function()
      local ok, start = require("ibl.utils").get_current_context(
        vim.g.indent_blankline_patterns,
        vim.g.indent_blankline_use_treesitter_scope
      )
      if ok then
        vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win(), { start, 0 })
        vim.cmd [[normal! _]]
      end
    end,
    { desc = "indent blankline contents" }
  )
end

M.gitsigns = function( opts )
  local gs = require("gitsigns")
  keymap.set("n", "]g",
      function()
        if vim.wo.diff then
          return "]g"
        end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end,
      merge_tb("force", { expr = true, desc = "next git hunk" }, opts or {} )
      )
  keymap.set("n", "[g",
      function()
        if vim.wo.diff then
          return "[g"
        end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end,
      merge_tb("force", { expr = true, desc = "prev git hunk" }, opts or {} )
      )
  keymap.set("n", "<leader>gs",
      function() gs.stage_hunk() end,
      merge_tb("force", {desc = "git stage hunk"}, opts or {})
      ) -- stage hunk
  keymap.set("v", "<leader>gs", 
      function() 
        gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} 
      end,
      merge_tb("force", {desc = "git stage hunk"}, opts or {})
      ) -- stage hunk (visual)
  keymap.set("n", "<leader>gS", 
      function() gs.stage_buffer() end,
      merge_tb("force", {desc = "git stage buffer"}, opts or {})
      ) -- stage hunk (visual), alternative (c - commit)
  keymap.set("n", "<leader>gr",
      function() gs.reset_hunk() end,
      merge_tb("force", {desc = "git reset hunk"}, opts or {})
      ) -- reset hunk
  keymap.set("n", "<leader>gR",
      function() gs.reset_buffer() end,
      merge_tb("force", {desc = "git reset buffer"}, opts or {})
      ) -- reset buffer
  keymap.set("v", "<leader>gr",
      function()
        gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')}
      end,
      merge_tb("force", {desc = "git reset hunk"}, opts or {})
      ) -- reset hunk (visual)
  keymap.set("n", "<leader>gu",
      function() gs.undo_stage_hunk() end,
      merge_tb("force", {desc = "git undo stage hunk"}, opts or {})
      ) -- undo stage hunk
  keymap.set({"n", "v"}, "<leader>gp",
      function() gs.preview_hunk() end,
      merge_tb("force", {desc = "git preview hunk"}, opts or {})
      )
  keymap.set("n", "<leader>gb",
      function() gs.blame_line({full = true}) end,
      merge_tb("force", {desc = "git blame line"}, opts or {})
      ) -- blame line
  keymap.set("n", "<leader>gt",
      function() gs.toggle_current_blame_line() end,
      merge_tb("force", {desc = "git blame line"}, opts or {})
      ) -- blame line
  keymap.set("n", "<leader>gd",
      function() gs.toggle_deleted() end,
      merge_tb("force", {desc = "git toggle deleted"}, opts or {})
      ) -- toggle deleted
end

M.vimtex = function()
  keymap.set("n", "<leader>lc", vim.cmd.VimtexCompile, { desc = "latex start compile" })
  keymap.set("n", "<leader>lv", vim.cmd.VimtexView, { desc = "latex view" })
  keymap.set("n", "<leader>lt", vim.cmd.VimtexTocToggle, { desc = "latex toggle ToC" })
end

M.luasnip = function()
  -- see plugins/coding.lua
  keymap.set("n", "<leader>cs", 
    function() 
      require("luasnip.loaders.from_lua").load({
        paths = "~/.config/nvim/luasnippets/" or ""
      }) 
      print("Reloading snippets...")
    end, 
    { desc = "snippets reload"}
  )
  -- See plugins.configs.cmp
  -- keymap.set({"i", "s"}, "<Tab>", 
  --   function()
  --     if require("luasnip").expand_or_jumpable() then
  --       require("luasnip").expand_or_jump()
  --     end
  --   end,
  --   {
  --     silent = true, 
  --     desc = "Jump to next (LuaSnip)",
  --   }
  -- )
  -- keymap.set({"i", "s"}, "<S-Tab>", 
  --   function()
  --     if require("luasnip").jumpable(-1) then
  --       require("luasnip").jump(-1)
  --     end
  --   end,
  --   {
  --     silent = true, 
  --     desc = "Jump to previous (LuaSnip)"
  --   }
  -- )
  -- NOTE: Experimental: arrow keys for snippets
  keymap.set({"i", "s"}, "<Right>", 
    function()
      if require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      end
    end,
    {
      silent = true, 
      desc = "Jump to next (LuaSnip)",
    }
  )
  keymap.set({"i", "s"}, "<Left>", 
    function()
      if require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      end
    end,
    {
      silent = true, 
      desc = "Jump to previous (LuaSnip)"
    }
  )
end

-- M.ufo = function()
--   keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "folds - open all"})
--   keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "folds - close all"})
-- end

M.persistence = function()
  -- see plugins/util.lua
end

M.navigator = function()
  keymap.set({'n', 't'}, '<C-h>', require("Navigator").left)
  keymap.set({'n', 't'}, '<C-l>', require("Navigator").right)
  keymap.set({'n', 't'}, '<C-k>', require("Navigator").up)
  keymap.set({'n', 't'}, '<C-j>', require("Navigator").down)
  -- keymap.set({'n', 't'}, '<A-p>', require("Navigator").Previous)
end

-- M.zenmode = function()
--   keymap.set({'n'}, '<leader>ez', 
--   vim.cmd.ZenMode,
--   { desc = 'toggle zenmode' })
-- end
--
-- M.twilight = function()
--   keymap.set({'n'}, '<leader>et', vim.cmd.Twilight, {desc = 'toggle twilight'})
-- end

M.obsidian = function()
  keymap.set("n", "gf", 
    function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
      else
        return "gf" 
      end
    end,
    { noremap = false, expr = true, desc = "go to file or Obsidian note" })
  keymap.set({'n'}, '<leader>oo', "<cmd>ObsidianOpen<CR>", 
             {desc = 'open Obsidian.md'})
end

M.mini_trailspace = function()
  keymap.set(
    {'n'}, 
    '<leader>cw', 
    "<cmd> lua MiniTrailspace.trim() <CR>", 
    {desc = "trim trailing spaces"}
  )
  keymap.set(
    {'n'}, 
    '<leader>cl', 
    "<cmd> lua MiniTrailspace.trim_last_lines() <CR>", 
    {desc = "trim trailing lines"}
  )
end

return M
