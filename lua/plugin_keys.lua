-- PLUGIN: Example plugin specs. ( Does NOT actually load anything )
if true then return {} end -- IMPORTANT: ALWAYS RETURNING NOTHING! THESE ARE DOCS!

-- NOTE: every spec file (.lua file) under the "plugins" directory,
-- that returns a plugin table, will be loaded automatically by lazy.nvim

-- XXX: This 'plugin_keys.lua' file is here to showcase what each
-- particular plugin spec / table key is used for, and what it means.
-- This includes:
-- 1. lazy (MOST IMPORTANT): Specifies if the plugin should be lazy-loaded (given a condition key) or loaded at startup.
-- 2. priority: Determines load order for plugins with the same loading condition.
-- 3. keys: Binds plugins starting, to key mappings. (Only applies to lazy loaded plugins)
-- 4. ft: Defines filetypes that trigger plugin loading. (Only applies to lazy loaded plugins)
-- 5. cmd: Defines commands that trigger plugin loading. (Only applies to lazy loaded plugins)
-- 6. event: Specifies events that trigger a plugin to load. (Only applies to lazy loaded plugins)
-- 7. init: Configures the plugin BEFORE it's loaded. (Applies to lazy loaded AND startup plugins)
-- 8. config: Contains the function to configure the plugin AFTER it's loaded.
-- 9. opts: Contains options that are passed to the plugin for configuration.
-- 10. dependencies: Specifies plugins that need to be loaded before the plugin you're configuring.
-- NOTE: Press '/' to search any of the above plugin config table keys
-- (e.g.: _keyName) to view how to properly use them
-- IMPORTANT: The 'keys', 'event', 'ft' and 'cmd' keys are the only plugin config table
-- keys that DO NOT HAVE ANY AFFECT on the plugin if the 'lazy' key is set to 'false'.
-- Because the plugin would start anyway on startup. (None-dependent on condition keys.)

return {

  -- WARN: The '_lazy' key: (MOST IMPORTANT!!!!)

  -- Example 1: Plugin that loads on startup (NOT lazy).
  {
    "pluginA",
    lazy = false, -- Loads immediately when Neovim starts. IMPORTANT: Default Behaviour when not included.
  },
  -- NOTE: pluginA will load during startup, which can slow down initialization.

  -- Example 2: Lazy-loaded plugin.
  {
    "pluginB",
    lazy = true, -- Does NOT load on startup.
    event = "BufReadPost",
  },
  -- NOTE: pluginB will only load when a buffer is opened (BufReadPost event).
  -- This helps speed up startup time.

  -- Example 3: Lazy-loaded plugin with multiple conditions.
  {
    "pluginC",
    lazy = true,
    cmd = "MyCommand",      -- Loads when running ':MyCommand'
    keys = { "<leader>x" }, -- Loads when pressing <leader>x
  },
  -- NOTE: pluginC loads when the user either runs ':MyCommand' or presses <leader>x.

  -- Example 4: Lazy-loading by file type.
  {
    "pluginD",
    lazy = true,
    ft = "python", -- Loads when opening a Python file.
  },
  -- NOTE: pluginD only loads when opening a Python file.

  -- Example 5: Lazy-loading but ensuring an immediate manual load.
  {
    "pluginE",
    lazy = true,
    init = function()
      vim.cmd("doautocmd User PluginE") -- Forces manual load when needed.
    end
  },
  -- NOTE: Even though pluginE is lazy, the init function allows manually triggering it.

  -- REMEMBER: Use 'lazy = true' for better performance, ensuring plugins only load when needed.
  -- If you set 'lazy = false', the plugin always loads at startup, making using any other optional
  -- keys COMPLETELY POINTLESS, which can slow down initialization.

  -- IMPORTANT: If no lazy-loading condition (event, cmd, ft, keys, etc.)
  -- is set, the plugin will never load.

  -- WARN: The '_priority' key:

  -- Example 1: Priority Affects Load Order Within the Same Group
  {
    "pluginA",
    lazy = false,   -- Loads at startup (Startup Group)
    priority = 100, -- Higher priority
  },
  {
    "pluginB",
    lazy = false,  -- Loads at startup (Startup Group)
    priority = 50, -- Lower priority
  },
  -- NOTE: pluginA (priority 100) loads before
  -- pluginB (priority 50) at startup.

  -- Example 2: Priority Does NOT override Lazy Loading
  {
    "pluginA",
    lazy = true,          -- Lazy-loaded (NOT ON STARTUP)
    priority = 100,
    event = "BufReadPost" -- Load after entering a buffer.
  },
  {
    "pluginB",
    lazy = false, -- Loads at startup.
    priority = 50
  },
  -- NOTE: pluginB loads first because it's NOT lazyily loaded.
  -- pluginA will ONLY load when the 'BufReadPost' event fires, even though
  -- it has higher priority.

  -- REMEMBER: Use 'priority' when you have multiple startup (lazy = false) plugins
  -- and need them to load in a particular order. When multiple plugins are set
  -- to load on the SAME event, priority ensures that those events load in a certain
  -- order. If two plugins modify the same thing (e.g.: two statusline plugins), the
  -- one with higher priority will take effect first.

  -- IMPORTANT: The 'priority' key DOES NOT MATTER when plugins load under different
  -- conditions (e.g.: cmd, ft, keys, etc.). Or if the plugin is lazy loaded.

  -- WARN: The '_keys' key:

  -- Example 1: Mapping a key to load a plugin.
  {
    "pluginA",
    lazy = true,
    keys = {
      { "<leader>f", ":Telescope find_files<CR>", desc = "Find Files" },
    }
  },
  -- NOTE: pluginA will NOT load on startup. Instead, it only loads when you press <leader>f.
  -- The 'desc' field is optional and provides a description for the key mapping.

  -- Example 2: Multiple Keybindings
  {
    "pluginB",
    lazy = true,
    keys = {
      { "gcc", ":CommentToggle<CR>", mode = "n",          desc = "Toggle Comment" },
      { "gc",  ":CommentToggle<CR>", mode = { "n", "v" }, desc = "Toggle Comment (Visual)" },
    }
  },
  -- NOTE: pluginB will load when you use "gcc" in normal mode or "gc" in normal/visual mode.

  -- Example 3: Using a Function Instead of a Command
  {
    "pluginC",
    lazy = true,
    keys = {
      {
        "<leader>x",
        function()
          print("Hello, world!")
        end,
        desc = "Print Message"
      }
    }
  },
  -- NOTE: Instead of running a command, this keybinding executes a Lua function.

  -- REMEMBER: Use 'keys' when you intend the plugin to not start on startup (lazy = true).
  -- The plugin will only load when one of the keybindings is used. The 'desc' parameter / key
  -- improves discoverability within the which-key.nvim plugin. If 'mode' is not set, its
  -- defaults to normal mode.

  -- IMPORTANT: If a plugin is NOT lazy (lazy = false), the 'keys' key / table simply add keybindings
  -- but DOES NOT affect when the plugin loads.

  -- WARN: The '_ft' key:

  -- Example 1: Lazy-load a plugin for a specific filetype.
  {
    "pluginA",
    lazy = true,
    ft = "python",
  },
  -- NOTE: pluginA will NOT load at startup. Instead, it only loads when
  -- opening a Python file.

  -- Example 2: Multiple filetypes.
  {
    "pluginB",
    lazy = true,
    ft = { "javascript", "typescript" },
  },
  -- NOTE: pluginB will only load when opening either a JavaScript or TypeScript file.

  -- Example 3: Using ft with dependencies.
  {
    "pluginC",
    lazy = true,
    ft = "markdown",
    dependencies = { "pluginX", "pluginY" },
  },
  -- NOTE: pluginC and its dependencies (pluginX, pluginY) will only load when
  -- opening a Markdown file.

  -- Example 4: Plugin that loads for ALL filetypes.
  {
    "pluginD",
    lazy = false,
  },
  -- NOTE: If 'ft' is NOT specified and lazy = false, the plugin
  -- loads on startup for all filetypes.

  -- REMEMBER: Use 'ft' to optimize performance by only loading plugins when needed.
  -- This is particularly useful for language-specific plugins (LSPs, linters, formatters, etc.).

  -- IMPORTANT: If a plugin has BOTH 'ft' and another lazy-loading condition (event, cmd, etc.),
  -- it will load if ANY of those conditions are met. For example, if a plugin has:
  -- ft = "lua" and cmd = "SomeCommand", it will load EITHER when opening a Lua file OR when running SomeCommand.

  -- WARN: The '_cmd' (command) key:

  -- Example 1: Lazy-load a plugin when a command is used.
  {
    "pluginA",
    lazy = true,
    cmd = "SomeCommand",
  },
  -- NOTE: pluginA will NOT load at startup. It will only load
  -- when running ':SomeCommand' in Neovim.

  -- Example 2: Multiple commands triggering the plugin.
  {
    "pluginB",
    lazy = true,
    cmd = { "LspInfo", "LspStart", "LspStop" },
  },
  -- NOTE: pluginB will load when running ANY of the listed commands.

  -- Example 3: Using cmd along with ft.
  {
    "pluginC",
    lazy = true,
    cmd = "Format",
    ft = "lua",
  },
  -- NOTE: pluginC will load if either of these conditions are met:
  -- - The user opens a Lua file.
  -- - The user runs ':Format' in Neovim.

  -- Example 4: Plugin that defines commands but loads at startup.
  {
    "pluginD",
    lazy = false,
    cmd = "MyCommand",
  },
  -- NOTE: This is unnecessary because lazy = false means the plugin loads at startup anyway.
  -- 'cmd' is useful ONLY when lazy = true.

  -- REMEMBER: Use 'cmd' to delay loading plugins until a specific command is run.
  -- This is useful for plugins that provide utility commands but aren’t needed all the time.

  -- IMPORTANT: If a plugin has multiple lazy-loading conditions (ft, event, keys, etc.),
  -- it will load when ANY of them are met.

  -- WARN: The '_event' key:

  -- Example 1: Lazy-load a plugin when an event occurs.
  {
    "pluginA",
    lazy = true,
    event = "BufReadPost",
  },
  -- NOTE: pluginA will NOT load at startup.
  -- It will load only when a buffer is opened.

  -- Example 2: Using multiple events.
  {
    "pluginB",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
  },
  -- NOTE: pluginB loads when opening an existing file (BufReadPost)
  -- or creating a new file (BufNewFile).

  -- Example 3: Using very early events for performance optimization.
  {
    "pluginC",
    lazy = true,
    event = "VeryLazy",
  },
  -- NOTE: pluginC loads once Neovim has fully started but before user interaction.
  -- This is useful for plugins that should load ASAP but don't need to delay startup.

  -- Example 4: Loading when entering insert mode.
  {
    "pluginD",
    lazy = true,
    event = "InsertEnter",
  },
  -- NOTE: pluginD loads only when the user first enters insert mode.

  -- Example 5: Combining event with other lazy-load conditions.
  {
    "pluginE",
    lazy = true,
    event = "BufWinEnter",
    cmd = "MyCommand",
  },
  -- NOTE: pluginE loads when opening a new window (BufWinEnter)
  -- OR when running ':MyCommand'.

  -- REMEMBER: Use 'event' to delay loading until a specific Neovim event occurs.
  -- This is useful for performance optimization, ensuring plugins load only when needed.

  -- IMPORTANT: If a plugin has multiple lazy-loading conditions (ft, cmd, keys, etc.),
  -- it will load when ANY of them are met.

  -- WARN: The '_init' key:

  -- Example 1: Running setup code before a lazy-loaded plugin initializes.
  {
    "pluginA",
    lazy = true,                   -- Plugin is lazy-loaded
    init = function()
      vim.g.pluginA_setting = true -- Set a global variable before the plugin loads.
    end
  },
  -- NOTE: Even though pluginA is lazy-loaded, the 'init' function runs on startup.
  -- This ensures that 'vim.g.pluginA_setting' is available when the plugin loads later.

  -- Example 2: Defining autocommands or key mappings before plugin loads.
  {
    "pluginB",
    lazy = true,
    init = function()
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = "*.txt",
        callback = function()
          print("Text file opened!")
        end
      })
    end
  },
  -- NOTE: The autocommand is registered at startup, even though pluginB is lazy.
  -- This ensures the behavior is set before the plugin actually loads.

  -- Example 3: Overriding plugin settings BEFORE it loads.
  {
    "pluginC",
    lazy = true,
    init = function()
      vim.g.pluginC_option = "custom_value"
    end,
    config = function()
      require("pluginC").setup()
    end
  },
  -- NOTE: The 'init' function sets a global variable early, while the 'config' function
  -- runs AFTER the plugin loads and calls its setup function.

  -- Example 4: Avoiding conflicts with other plugins by setting conditions.
  {
    "pluginD",
    lazy = true,
    init = function()
      if vim.g.loaded_other_plugin then
        vim.g.pluginD_disable_feature = true
      end
    end
  },
  -- NOTE: The 'init' function checks if another plugin is loaded and modifies behavior accordingly.

  -- REMEMBER: The 'init' function runs **before** a plugin loads, even if the plugin is lazy.
  -- It is mainly used to set global variables, define autocommands, or prepare the environment.

  -- IMPORTANT: If you need to configure the plugin **after** it loads, use the 'config' key instead.

  -- WARN: The '_config' key:

  -- Example 1: Running a setup function after the plugin loads.
  {
    "pluginA",
    lazy = true, -- Plugin is lazy-loaded
    config = function()
      require("pluginA").setup({
        option1 = true,
        option2 = "value"
      })
    end
  },
  -- NOTE: The 'config' function runs **AFTER** the plugin loads, ensuring that `require("pluginA")`
  -- works because the module is available.

  -- Example 2: Running inline Lua configuration.
  {
    "pluginB",
    lazy = true,
    config = function()
      vim.g.pluginB_setting = true
      vim.cmd("highlight PluginBColor ctermfg=Red")
    end
  },
  -- NOTE: This runs after the plugin loads, so settings can be applied dynamically.

  -- Example 3: Using 'config' when the plugin is NOT lazy.
  {
    "pluginC",
    lazy = false, -- Plugin loads on startup.
    config = function()
      require("pluginC").setup({
        enable_feature = true
      })
    end
  },
  -- NOTE: Even for non-lazy plugins, 'config' ensures the setup function runs at the right time.

  -- Example 4: Avoiding errors when the plugin is missing.
  {
    "pluginD",
    lazy = true,
    config = function()
      local ok, pluginD = pcall(require, "pluginD")
      if not ok then return end -- Prevents errors if the plugin is not installed.

      pluginD.setup({
        special_mode = "enabled"
      })
    end
  },
  -- NOTE: 'pcall' prevents crashes if the plugin is missing.

  -- REMEMBER: The 'config' function runs **AFTER** the plugin loads.
  -- It is used to configure the plugin, call `setup()`, or apply settings dynamically.

  -- IMPORTANT: If you need to set global variables or pre-load configurations **before** the plugin loads,
  -- use the 'init' key instead.

  -- WARN: The '_opts' key:

  -- Example 1: Providing options to the plugin’s setup function automatically.
  {
    "pluginA",
    lazy = true,
    opts = {
      option1 = true,
      option2 = "value"
    }
  },
  -- NOTE: When a plugin includes an 'opts' table, the lazy.nvim plugin manager will
  -- automatically pass it to the plugin’s setup() function: `require("pluginA").setup(opts)`.
  -- This avoids needing to manually call `setup()` in the config function.
  -- This is equivalent to:
  -- config = function()
  --   require("pluginA").setup({
  --     option1 = true,
  --     option2 = "value"
  --   })
  -- end

  -- Example 2: Using 'opts' with an explicit 'config' function.
  {
    "pluginB",
    lazy = true,
    opts = {
      settingA = false,
      settingB = "custom"
    },
    config = function(_, opts)
      require("pluginB").setup(opts)
    end
  },
  -- NOTE: The 'opts' table is automatically passed, by the lazy.nvim plugin manager,
  -- as the second argument to 'config'. This allows modifications or extra logic before
  -- calling setup().

  -- Example 3: Modifying 'opts' dynamically.
  {
    "pluginC",
    lazy = true,
    opts = function()
      return {
        dynamicSetting = vim.g.some_global_var or "default_value"
      }
    end
  },
  -- NOTE: 'opts' can be a function returning a table, which allows for dynamic values.

  -- Example 4: Defining 'opts' but overriding them in 'config'.
  {
    "pluginD",
    lazy = true,
    opts = {
      default_setting = "on"
    },
    config = function(_, opts)
      opts.default_setting = "off" -- Override before setup.
      require("pluginC").setup(opts)
    end
  },
  -- NOTE: This lets you tweak 'opts' dynamically before applying them.

  -- Example 5: 'opts' without a setup function.
  {
    "pluginE",
    lazy = true,
    opts = {
      setting1 = true,
      setting2 = false
    }
  },
  -- NOTE: If the plugin does NOT have a 'setup()' function, 'opts' does nothing.

  -- REMEMBER: The 'opts' key is a shortcut for setting up a plugin. It automatically
  -- passes options to `require("pluginName").setup(opts)`, simplifying plugin configuration.
  -- It's a **convenience feature** making configs cleaner.

  -- IMPORTANT: If a plugin does **not** have a `setup()` function, then 'opts' will
  -- have no effect, and you'll need to use 'config' instead. Also, if the plugin requires
  -- **extra logic**, using 'config' instead of (or with) 'opts'.

  -- WARN: The '_dependencies' key:

  -- Example 1: A plugin depends on another plugin.
  {
    "pluginA",
    lazy = true,
    dependencies = {
      "pluginB", -- pluginA depends on pluginB
      "pluginC"  -- pluginA also depends on pluginC
    },
  },
  -- NOTE: lazy.nvim will ensure pluginB and pluginC are loaded before pluginA.

  -- Example 2: Plugin dependencies in a specific order.
  {
    "pluginX",
    lazy = true,
    dependencies = {
      "pluginY", -- pluginX requires pluginY to be loaded first
      "pluginZ"  -- pluginX also requires pluginZ to be loaded before it
    },
  },
  -- NOTE: lazy.nvim ensures that pluginY and pluginZ are loaded in the correct order before pluginX.

  -- Example 3: Using 'dependencies' with lazy loading plugins.
  {
    "pluginD",
    lazy = true,
    dependencies = {
      { "pluginE", lazy = true } -- pluginD will load after pluginE is loaded.
    },
  },
  -- NOTE: pluginD will be lazy-loaded only after pluginE is loaded.

  -- Example 4: Optional dependencies.
  {
    "pluginF",
    lazy = true,
    dependencies = {
      { "pluginG", lazy = false } -- pluginG is required at startup, but pluginF is lazy.
    },
  },
  -- NOTE: In this case, pluginG will load first because it is not lazy-loaded.

  -- REMEMBER: Use 'dependencies' when you need to ensure that one or more plugins are loaded
  -- before the plugin you're defining. This is crucial when plugins have interdependencies.

  -- IMPORTANT: lazy.nvim automatically ensures dependencies are loaded first,
  -- and you do not need to manually manage the load order.
}
