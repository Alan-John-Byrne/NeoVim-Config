--  PLUGIN: The 'todo-comments.nvim' plugin provides text highlights (eg: TODO, NOTE, etc...),
--  to alter keywords.
return {
  "folke/todo-comments.nvim",
  enabled = true, --TESTING
  event = "VimEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = true,
    keywords = {
      FIX = {
        icon = "🛠", -- Icon used for the sign, and in search results.
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "IMPORTANT" }, -- a set of other keywords that all map to this FIX keywords
      }, -- 'test' and 'info' are the same colour.
      TEST = { icon = "🧪", color = "info", alt = { "TESTING", "PASSED", "FAILED" } },
      PERF = { icon = "📈", color = "info", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      TODO = { icon = "🔲", color = "info", alt = { "REMEMBER" } },
      QUESTION = { icon = "✨", color = "heading", alt = { "SECTION", "HEADING" } },
      ANSWER = { icon = "💫", color = "plugin", alt = { "PLUGIN" } },
      WARN = { icon = "⚠", color = "warning", alt = { "DEFINITION", "DEF", "WARNING" } },
      EXAMPLE = { icon = "✍", color = "example", alt = { "EXAMPLES" } },
      NOTE = { icon = "✏", color = "hint", alt = { "INFO" } },
      GOAL = { icon = "🥅", color = "goal" },
      XXX = { icon = "❗", color = "banner", alt = { "FIN", "END", "HACK" } },
    },
    colors = {
      error = { "#FF6060" },
      goal = { "#B5B1F1" },
      warning = { "#e1aa02" },
      example = { "#01b3bd" },
      info = { "#7eaeb8" },
      hint = { "DiagnosticHint" },
      default = { "Identifier" },
      test = { "#FF00FF" },
      heading = { "#bcc435" },
      banner = { "#AFAFAF" },
      plugin = { "#d78bda" },
    },
    highlight = {
      max_line_len = 1000, -- NOTE: ignore lines longer than this
    },
  }
}

--  TODO: Use 'event' to defer plugin loading until a specific event occurs, improving startup time. Use 'dependencies' to ensure that required plugins or libraries are loaded before the plugin itself, ensuring it functions correctly.

--  IMPORTANT: The dependencies themselves must be installed on their own seperately first.

--  NOTE: Below is a list of types of events that can be used:
--  1. VimEnter: Occurs after vim finishes initializing; right after the startup process.
--  2. BufReadPost: Occurs after a buffer is read; after opening a file.
--  3. BufWritePost: Occurs after a buffer is written to and saved.
--  4. BufEnter: Occurs when a buffer is entered; when opening up a file.
--  5. BufLeave: Occurs when leaving a buffer; when switchin away from the current file / buffer.
--  6. BufNewFile: Occurs when creating a new file; when a new buffer is created.
--  7. BufWinEnter: Occurs when a buffer is displayed in a  window; when a buffer becomes visibule in a window.
--  8. FileType: Occurs after setting the file type; when the file type is detected or set.
--  9. InsertEnter: Occurs when entering insert mode; when switching from normal to insert mode.
--  10. InsertLeave: Occurs when leaving insert mode; when switching from insert to normal mode.
--  11. CursorHold: Occurs when the cursor is idle; after the cursor has been idle for a while.
--  12. CursorMoved: Occurs when the cursor is moved; whenever the cursor moves.
--  13. WinEnter: Occurs when entering a window; when switching to another window.
--  14. WinLeave: Occurs when leaving a window; when switching from the current window to another.
--  15. TabEnter: Occurs when entering a tab; when switching to another tab.
--  16. TabLeave: Occurs when leaving a tab; when switching away from the current tab.
--  17. ColorScheme: Occurs after the colorscheme is set; when changing to a different colorscheme.
--  18. User: Occurs when explicitly triggered by the 'doautocmd User' command.

--  WARN: See `:help gitsigns` to understand what the configuration keys do.
