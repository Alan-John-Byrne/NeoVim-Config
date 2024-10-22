-- PLUGIN: Installing the 'cmake-tools.nvim' plugin. It provides the functionality for building and running c++ projects.
return {
  "Civitasv/cmake-tools.nvim",
  config = function()
    require("cmake-tools").setup({
      cmake_regenerate_on_save = false, -- IMPORTANT: NINJA is the required build system, we can't use the default MSVC build system.
    })
  end,
}
