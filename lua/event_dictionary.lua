--  XXX: Below is a list of 'auto-command' events that can be used within neovim:
--  1. VimEnter: Occurs after Vim finishes initializing; right after the startup process.
--  2. VimLeave: Occurs before exiting Vim; just before quitting.
--  3. VimLeavePre: Occurs just before `VimLeave`; allows final cleanup.
--  4. BufNewFile: Occurs when creating a new file; when a new buffer is created.
--  5. BufReadPre: Occurs before reading a buffer; before opening a file.
--  6. BufReadPost: Occurs after a buffer is read; after opening a file.
--  7. BufWritePre: Occurs before writing a buffer; before saving a file.
--  8. BufWritePost: Occurs after a buffer is written to and saved.
--  9. BufEnter: Occurs when a buffer is entered; when opening up a file.
--  10. BufLeave: Occurs when leaving a buffer; when switching away from the current file/buffer.
--  11. BufWinEnter: Occurs when a buffer is displayed in a window; when a buffer becomes visible in a window.
--  12. BufWinLeave: Occurs when a buffer is removed from a window; when a buffer is no longer visible in any window.
--  13. BufUnload: Occurs before unloading a buffer; when a buffer is about to be unloaded from memory.
--  14. BufDelete: Occurs before deleting a buffer; when a buffer is about to be wiped out.
--  15. BufHidden: Occurs when a buffer is no longer displayed in any window; when switching to another buffer.
--  16. BufWipeout: Occurs before completely wiping out a buffer; when a buffer is being fully removed.
--  17. FileType: Occurs after setting the file type; when the file type is detected or set.
--  18. InsertEnter: Occurs when entering insert mode; when switching from normal to insert mode.
--  19. InsertLeave: Occurs when leaving insert mode; when switching from insert to normal mode.
--  20. InsertChange: Occurs when switching between insert and replace mode.
--  21. InsertCharPre: Occurs before inserting a character in insert mode; before a character is actually inserted.
--  22. CursorHold: Occurs when the cursor is idle; after the cursor has been idle for a while.
--  23. CursorHoldI: Occurs when the cursor is idle in insert mode.
--  24. CursorMoved: Occurs when the cursor is moved; whenever the cursor moves.
--  25. CursorMovedI: Occurs when the cursor moves in insert mode.
--  26. WinEnter: Occurs when entering a window; when switching to another window.
--  27. WinLeave: Occurs when leaving a window; when switching from the current window to another.
--  28. WinNew: Occurs when creating a new window; when opening a new split.
--  29. WinScrolled: Occurs when a window is scrolled; when using `Ctrl-d`, `Ctrl-u`, etc.
--  30. WinResized: Occurs when a window is resized; after adjusting window size.
--  31. TabEnter: Occurs when entering a tab; when switching to another tab.
--  32. TabLeave: Occurs when leaving a tab; when switching away from the current tab.
--  33. ColorSchemePre: Occurs before setting the colorscheme.
--  34. ColorScheme: Occurs after the colorscheme is set; when changing to a different colorscheme.
--  35. CmdlineEnter: Occurs when entering command-line mode; when typing `:` or `/`.
--  36. CmdlineLeave: Occurs when leaving command-line mode; after executing a command or canceling it.
--  37. CmdWinEnter: Occurs when entering the command-line window; when opening the command history window.
--  38. CmdWinLeave: Occurs when leaving the command-line window; after closing the command history window.
--  39. CompleteDone: Occurs after completion is finished; when autocomplete finishes and is accepted or canceled.
--  40. QuickFixCmdPre: Occurs before executing a quickfix command; when running `:grep`, `:make`, etc.
--  41. QuickFixCmdPost: Occurs after executing a quickfix command; after `:grep`, `:make`, etc., finishes.
--  42. SessionLoadPost: Occurs after loading a session; when a session file is restored.
--  43. ShellCmdPost: Occurs after executing a shell command; when running `:!cmd`.
--  44. ShellFilterPost: Occurs after a shell filter command finishes; when using `:w !cmd`.
--  45. SourcePre: Occurs before sourcing a Vim script; before executing `:source file`.
--  46. SourcePost: Occurs after sourcing a Vim script; after executing `:source file`.
--  47. SpellFileMissing: Occurs when a spell file is missing; when trying to use a spell file that doesn’t exist.
--  48. StdinReadPre: Occurs before reading from stdin; before reading input from a pipe.
--  49. StdinReadPost: Occurs after reading from stdin; after reading input from a pipe.
--  50. SwapExists: Occurs when a swap file already exists; when opening a file that has an existing swap file.
--  51. TermOpen: Occurs when opening a terminal buffer; when starting a terminal in Neovim.
--  52. TermClose: Occurs when a terminal job ends; when a process in a terminal buffer exits.
--  53. TermLeave: Occurs when leaving a terminal buffer; when switching away from a terminal window.
--  54. TextChanged: Occurs when the text in the buffer changes; after modifying text in insert or normal mode.
--  55. TextChangedI: Occurs when text changes in insert mode; after every change in insert mode.
--  56. TextChangedP: Occurs when text changes in insert mode after a keypress; more granular than `TextChangedI`.
--  57. TextYankPost: Occurs after yanking text; when using `y`, `yy`, or any yank command.
--  58. User: Occurs when explicitly triggered by the `doautocmd User` command; used for custom / plugin events.
--  59. FileChangedShell: Occurs when a file changes outside of Vim; when detected by `:checktime`.
--  60. FileChangedShellPost: Occurs after handling an external file change; after confirming reloading or ignoring changes.
--  61. FileChangedShellPre: Occurs before handling an external file change.
--  62. ModeChanged: Occurs when the mode changes; when switching between Normal, Insert, Visual, etc.
--  63. DirChangedPre: Occurs before changing the working directory.
--  64. DirChanged: Occurs after changing the working directory; when `:cd`, `:tcd`, or `:lcd` is used.
--  65. EncodingChanged: Occurs after changing the encoding; when `:set encoding=` is modified.
--  66. FocusGained: Occurs when the editor gains focus; when switching back to the terminal or GUI window.
--  67. FocusLost: Occurs when the editor loses focus; when switching away from the terminal or GUI window.
