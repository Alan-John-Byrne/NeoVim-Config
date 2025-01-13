-- PLUGIN: Installing the 'rainbow_csv' plugin. It provides better highlighting within neovim for csv files.
return {
  "cameron-wags/rainbow_csv.nvim",
  enabled = true, -- TESTING
  config = true,
  ft = {
    "csv",
    "tsv",
    "csv_semicolon",
    "csv_whitespace",
    "csv_pipe",
    "rfc_csv",
    "rfc_semicolon",
  },
  cmd = {
    "RainbowDelim",
    "RainbowDelimSimple",
    "RainbowDelimQuoted",
    "RainbowMultiDelim",
  },
}
