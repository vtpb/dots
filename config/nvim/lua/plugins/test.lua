return {
  -- editor.lua
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  -- beautiful screenshots using Silicon
  -- {
  --   'krivahtoo/silicon.nvim',
  --   -- build = './install.sh',
  --   opts = {
  --     -- Output configuration for the saved image
  --     output = {
  --       -- (string) The full path of the file to save to.
  --       file = "",
  --       -- (boolean) Whether to copy the image to clipboard instead of saving to file.
  --       clipboard = true,
  --       -- (string) Where to save images, defaults to the current directory.
  --       --  e.g. /home/user/Pictures
  --       path = ".",
  --       -- (string) The filename format to use. Can include placeholders for date and time.
  --       -- https://time-rs.github.io/book/api/format-description.html#components
  --       format = "silicon_[year][month][day]_[hour][minute][second].png",
  --     },
  --
  --     -- Font and theme configuration for the screenshot.
  --     font = 'Hack=20', -- (string) The font and font size to use for the screenshot.
  --     -- (string) The color theme to use for syntax highlighting.
  --     -- It can be a theme name or path to a .tmTheme file.
  --     theme = 'Dracula',
  --
  --     -- Background and shadow configuration for the screenshot
  --     background = '#eff', -- (string) The background color for the screenshot.
  --     shadow = {
  --       blur_radius = 0.0, -- (number) The blur radius for the shadow, set to 0.0 for no shadow.
  --       offset_x = 0, -- (number) The horizontal offset for the shadow.
  --       offset_y = 0, -- (number) The vertical offset for the shadow.
  --       color = '#555' -- (string) The color for the shadow.
  --     },
  --
  --     pad_horiz = 100, -- (number) The horizontal padding.
  --     pad_vert = 80, -- (number) The vertical padding.
  --     line_number = true, -- (boolean) Whether to show line numbers in the screenshot.
  --     line_pad = 2, -- (number) The padding between lines.
  --     line_offset = 1, -- (number) The starting line number for the screenshot.
  --     tab_width = 4, -- (number) The tab width for the screenshot.
  --     gobble = false, -- (boolean) Whether to trim extra indentation.
  --     highlight_selection = false, -- (boolean) Whether to capture the whole file and highlight selected lines.
  --     round_corner = true,
  --     window_controls = false, -- (boolean) Whether to show window controls (minimize, maximize, close) in the screenshot.
  --     window_title = nil, -- (function) A function that returns the window title as a string.
  --
  --     -- Watermark configuration for the screenshot
  --     watermark = {
  --       text = nil, -- (string) The text to use as the watermark, set to nil to disable.
  --       color = '#222', -- (string) The color for the watermark text.
  --       -- (string) The style for the watermark text, possible values are:
  --       -- 'bold', 'italic', 'bolditalic', or anything else defaults to 'regular'.
  --       style = 'bold',
  --     },
  --   },
  --   config = function(_, opts)
  --     require("silicon").setup(opts)
  --   end,
  -- }

  {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = true,
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim
    -- for markdown files in your vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to
      -- call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre " .. vim.fn.expand "~" .. "/obsidian/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/obsidian/**.md",
      -- "BufReadPre path/to/my-vault/**.md",
      -- "BufNewFile path/to/my-vault/**.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      -- see below for full list of optional dependencies 👇
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
      require("core.mappings").obsidian()
    end,
    opts = {
      workspaces = {
        -- {
        --   name = "personal",
        --   path = "~/vaults/personal",
        -- },
        -- {
        --   name = "work",
        --   path = "~/vaults/work",
        -- },
        {
          name = "my_vault",
          path = "~/obsidian/vault",
          -- following settings override the defaults for specific vaults
          -- can be used outside of "workspaces" to specify defaults
          overrides = {
            -- keep notes in specific subdirectory of vault
            notes_subdir = "000_inbox",
            daily_notes = {
              folder = "100_personal/101_journal",
              -- date format specified by Python strftime format
              -- https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior
              -- instead of form used in Obsidian
              date_format = "%Y-%m-%d_%a",
              template = "templates/daily_note",
            },
          },
        },
      },

      -- completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        nvim_cmp = true, -- false to disable completion.
        min_chars = 2, -- Trigger completion at 2 chars.
    
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "notes_subdir",
    
        -- Control how wiki links are completed with these (mutually exclusive) options:
        --
        -- 1. Whether to add the note ID during completion.
        -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        -- Mutually exclusive with 'prepend_note_path' and 'use_path_only'.
        prepend_note_id = true,
        -- 2. Whether to add the note path during completion.
        -- E.g. "[[Foo" completes to "[[notes/foo|Foo]]" assuming "notes/foo.md" is the path of the note.
        -- Mutually exclusive with 'prepend_note_id' and 'use_path_only'.
        prepend_note_path = false,
        -- 3. Whether to only use paths during completion.
        -- E.g. "[[Foo" completes to "[[notes/foo]]" assuming "notes/foo.md" is the path of the note.
        -- Mutually exclusive with 'prepend_note_id' and 'prepend_note_path'.
        use_path_only = false,
      },
    
      -- key mappings. set 'mappings = {}' for no mappings
      mappings = {
        -- override the 'gf' mapping for markdown/wiki links within vault
        -- Note: overriden in mappings.lua to maintain gf functionality
        -- ["gf"] = {
        --   action = function()
        --     return require("obsidian").util.gf_passthrough()
        --   end,
        --   opts = { noremap = false, expr = true, buffer = true },
        -- },
        -- Toggle check-boxes.
        ["<leader>oc"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },
    
      -- customize how names/IDs for new notes are created.
      -- note_id_func = function(title)
      --   -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      --   -- In this case a note with the title 'My new note' will be given an ID that looks
      --   -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      --   local suffix = ""
      --   if title ~= nil then
      --     -- If title is given, transform it into valid file name.
      --     suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      --   else
      --     -- If title is nil, just add 4 random uppercase letters to the suffix.
      --     for _ = 1, 4 do
      --       suffix = suffix .. string.char(math.random(65, 90))
      --     end
      --   end
      --   return tostring(os.time()) .. "-" .. suffix
      -- end,
    
      -- Optional, boolean or a function that takes a filename and returns a boolean.
      -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
      disable_frontmatter = true,
    
      -- TODO: requires configuration to be equal to Obsidian's
      -- Optional, alternatively you can customize the frontmatter data.
      note_frontmatter_func = function(note)
        -- This is equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
    
      -- templates
      templates = {
        subdir = "templates",
        -- date_format = "%Y-%m-%d",
        -- time_format = "%H:%M",
        date_format = "%A, %B %d %Y",
        time_format = "%H:%M:%S",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },
    
      -- customize the backlinks interface.
      backlinks = {
        height = 10, -- default height of the backlinks pane
        wrap = true,
      },
    
      -- by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({"open", url})  -- Mac OS
        vim.fn.jobstart({"xdg-open", url})  -- linux
      end,
    
      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = true,

      finder = "telescope.nvim",
    
      -- sort search results by "path", "modified", "accessed", or "created".
      -- recommend value is "modified" and `true` for `sort_reversed`
      -- `:ObsidianQuickSwitch` will show notes sorted by latest modified time
      sort_by = "modified",
      sort_reversed = true,
    
      -- Optional, determines how certain commands open notes. The valid options are:
      -- 1. "current" (the default) - to always open in the current window
      -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
      -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
      open_notes_in = "current",
    
      -- Optional, configure additional syntax highlighting / extmarks.
      -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
      ui = {
        enable = true,  -- set to false to disable all additional syntax features
        update_debounce = 200,  -- update delay after a text change (in milliseconds)
        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          ["/"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["-"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          -- Replace the above with this if you don't have a patched font:
          -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },
        },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- Replace the above with this if you don't have a patched font:
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        -- hl_groups = {
        --   -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        --   ObsidianTodo = { bold = true, fg = "#f78c6c" },
        --   ObsidianDone = { bold = true, fg = "#89ddff" },
        --   ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        --   ObsidianTilde = { bold = true, fg = "#ff5370" },
        --   ObsidianRefText = { underline = true, fg = "#c792ea" },
        --   ObsidianExtLinkIcon = { fg = "#c792ea" },
        --   ObsidianTag = { italic = true, fg = "#89ddff" },
        --   ObsidianHighlightText = { bg = "#75662e" },
        -- },
      },
    
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "attachments",
        -- A function that determines the text to insert in the note when pasting an image.
        -- It takes two arguments, the `obsidian.Client` and a plenary `Path` to the image file.
        -- This is the default implementation.
        ---@param client obsidian.Client
        ---@param path Path the absolute path to the image file
        ---@return string
        img_text_func = function(client, path)
          local link_path
          local vault_relative_path = client:vault_relative_path(path)
          if vault_relative_path ~= nil then
            -- Use relative path if the image is saved in the vault dir.
            link_path = vault_relative_path
          else
            -- Otherwise use the absolute path.
            link_path = tostring(path)
          end
          local display_name = vim.fs.basename(link_path)
          return string.format("![%s](%s)", display_name, link_path)
        end,
      },
    
      -- Optional, set the YAML parser to use. The valid options are:
      --  * "native" - uses a pure Lua parser that's fast but potentially misses some edge cases.
      --  * "yq" - uses the command-line tool yq (https://github.com/mikefarah/yq), which is more robust
      --    but much slower and needs to be installed separately.
      -- In general you should be using the native parser unless you run into a bug with it, in which
      -- case you can temporarily switch to the "yq" parser until the bug is fixed.
      yaml_parser = "native",
    }
  },
}
