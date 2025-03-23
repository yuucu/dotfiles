return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  keys = {
    { "<leader>oo", "<cmd>ObsidianOpen<cr>",        desc = "[o]bsidian open" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>",       desc = "[o]bsidian today" },
    { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "[o]bsidian new file" },
    { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "[o]bsidian [f]ile search" },
    { "<leader>or", "<cmd>ObsidianSearch<cr>",      desc = "[o]bsidian [r]igrep" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/workspace/obsidian/me",
      },
    },
    ui = {
    },
    notes_subdir = "Notes/FleetingNote",
    new_notes_location = "notes_subdir",

    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      local date = os.date("%Y%m%d")
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return date .. "_" .. suffix
    end,
    daily_notes = {
      folder = "Journal/2025/Daily",
      date_format = "%Y%m%d",
      template = nil,
    },
    templates = {
      folder = "Templates",
      date_format = "%Y%m%d",
      time_format = "%H:%M",
      substitutions = {},
    },
  },
  init = function()
    vim.opt.conceallevel = 2
  end,
}
