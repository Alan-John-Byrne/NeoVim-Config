--  PLUGIN: The 'todo-comments.nvim' plugin provides text highlights (eg: TODO, NOTE, etc...),
--  to alter keywords.
return {
  "folke/todo-comments.nvim",
  enabled = true, --TESTING
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = true,
    keywords = {
      FIX = {
        icon = "🛠", -- Icon used for the sign, and in search results.
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "IMPORTANT" }, -- a set of other keywords that all map to this FIX keywords
      }, -- 'test' and 'info' are the same colour.
      NOTE = { icon = "✏", color = "note", alt = {} }, -- Empty 'alt' table because of error.
      TODO = { icon = "🧠", color = "todo", alt = { "REMEMBER" } },
      INFO = { icon = "ℹ️", color = "info" },
      TEST = { icon = "🧪", color = "test", alt = { "TESTING", "PASSED" } },
      ERROR = { icon = "📈", color = "error", alt = { "PERFORMANCE", "FAILED", "OPTIMIZE" } },
      GOAL = { icon = "🥅", color = "goal" },
      SECTION = { icon = "✨", color = "question", alt = { "QUESTION", "HEADING", "PART" } },
      PLUGIN = { icon = "💫", color = "plugin", alt = { "ANSWER" } },
      WARNING = { icon = "⚠", color = "warning", alt = { "DEFINITION", "DEF", "WARN" } },
      EXAMPLE = { icon = "✍", color = "example", alt = { "EXAMPLES" } },
      OOO = { icon = "❗", color = "check", alt = { "CHECK", "ADAPTER" } },
    },
    colors = {
      note = { "diagnosticHint" },
      todo = { "#75a7d7" },
      info = { "#8692e3" },
      check = { "#afafaf" },
      test = { "#dcdf7e" },
      error = { "#fa7070" },
      goal = { "#b5b1f1" },
      question = { "#bcc435" },
      plugin = { "#d78bda" },
      warning = { "#e1aa02" },
      example = { "#01b3bd" },
      -- Examples are below:
      -- NOTE:
      -- TODO:
      -- INFO:
      -- TEST:
      -- ERROR:
      -- GOAL:
      -- QUESTION:
      -- PLUGIN:
      -- WARN:
      -- EXAMPLE:
      -- OOO:
    },
    highlight = {
      max_line_len = 1000, -- NOTE: ignore lines longer than this
    },
  }
}

--  TODO: Use 'event' to defer plugin loading until a specific event occurs, improving startup time. Use 'dependencies' to ensure that required plugins or libraries are loaded before the plugin itself, ensuring it functions correctly.

--  IMPORTANT: The dependencies themselves must be installed on their own seperately first.

--  WARN: See `:help gitsigns` to understand what the configuration keys do.
