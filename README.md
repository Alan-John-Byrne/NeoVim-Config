# <p align="center">Inspired by the _💤[LazyVim](https://github.com/LazyVim/LazyVim)_ distro.</p>

## **<p align="center">Preview:</p>**

![Vite + React + TS](.images/dashboard.png)

## **<p align="center">The Stack:</p>**

<p align="center">
    <img src=".images/apple_logo.png" alt="WezTerm Logo" width="100" height="120">
    <br>
    <img src=".images/wezterm.png" alt="WezTerm Logo" width="130" height="130">
    <br>
    <img src=".images/bash_logo.png" alt="WezTerm Logo" width="300" height="130">
    <br>
    <img src=".images/neovim_logo.png" alt="NeoVim Logo" width="100" height="130">
    <br>
    <img src=".images/lazy_logo.png" alt="LazyVim Logo" width="100" height="70">
</p>

> **NOTE:** This is a custom configuration project meant to mimick typical IDEs, using Bash/WezTerm. It's a work
> in progress. <u>_I'm hoping to cover Unix system settings at some point._</u>

**GOAL:** To put multiple complex tools together to form a powerful and extensive development environment.

> **PAIN POINTS**: \_<u>A list of mistakes I've made, and how to avoid them.</u>
>
> - <u>_'File is too large to open' (mini.files)_</u>: If the file is currently stored
>   on your OneDrive, please ensure your OneDrive is running and synced so you
>   actually have the file locally on your machine, to open it.
> - <u>_'Snacks terminal not opening in the same directory as the current buffer' (snacks.nvim)_</u>: The terminal
>   provided by the snacks.nvim package (<u>_triggered via the keybind 'CTRL + /'_</u>) will open in the same directory
>   where you initially entered neovim. I've added a which-key keybind to allow you
>   set the current directory to the parent directory of the current buffer, use '\<leader> + \\'. Then when you enter
>   the snacks terminal, it'll open in the same directory as the current buffer, without having to first exit and re-enter
>   neovim in that desired directory.

## Use Cases:

- **Work on Projects (eg: _React + Ts /w Vite_)**: (<u>_More frameworks & libraries can be supported_</u>)
  ![Vite + React + TS](.images/vite_reactts_project.jpg)

- **Study Algorithms w/ WezTerm Multiplexing**: (_<u>Image Previewer included</u>_)
  ![Studying Kandane's Algorithm](.images/study_algos.jpg)

  > **NOTE:** Image previewing ONLY WORKS in terminals that support the necessary image protocols, such as WezTerm, Kitty, or other compatible terminal emulators. This will **NOT** work in BASh or basic terminal emulators that lack support for those protocols.

- **Debug Software w/ Nvim-Dap:**
  ![Debugging Code](.images/debugging.jpg)
- **Use Polyglot Development w/ WezTerm Multiplexing:**
  ![WezTerm Multiplexing](.images/multiplex.jpg)
- **Unit Testing**: (<u>_Multiple Frameworks supported_</u>)

## Language Feature Support:

| Language   | Debugging | LSP Support | TreeSitter Highlights | Linting  | Format On Save | Auto-Complete |
| ---------- | --------- | ----------- | --------------------- | -------- | -------------- | ------------- |
| MarkDown   | &#x274C;  | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| Python     | &#x2611;  | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| Lua        | Limited   | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| Java       | &#x2611;  | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| Golang     | &#x2611;  | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| JavaScript | &#x2611;  | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| TypeScript | &#x2611;  | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| C#         | &#x2611;  | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| C++        | &#x2611;  | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |

## Testing Framework Support: (_<u>via neotest</u>_)

| Framework  | Adapter Support |
| ---------- | --------------- |
| Playwright | &#x2611;        |
| Jest       | &#x274C;        |

I plan on adding as many useful frameworks as possible.

## Setup:

All can be setup in the following steps:

1. Use brew to install NeoVim onto your system.
2. Clone or fork this repository to make it your own, into your '_~/Users/alanbyrne/.config/_' directory. (Overwrite the 'nvim' directory if it exists already after following step **1**)
3. Install the following software, and configure the following environment variables <u>_exactly_</u>, to complete the setup.

> **NOTE**: This setup does require some knowledge of bash profiles for correctly setting environment variables
> (_used during open BASh sessions_), _**OR**_ _you could just set them within the global environment table
> on windows_ ~<u>_NOT AS CLEAN_</u>.

### Environment variables (_Profile Specific_):

You can have multiple programming languages supported within Neovim. However, in order for these languages to work, there are a few pre-requisites
that need to be in place prior to utilisation. Following is a table of environment variables that must be set to the correct values
(_<u>paths to particular pieces of software</u>_) in accordance to the intended plugins specifications. The plugins themselves dictate
what versions of these software components are depended on in order to work correctly. So, in case of any updates to these plugin specs,
please read them again in case of any changes being made to these dependencies.

| Variable                        | Description                                               | Why?                                                                                                                                                        |
| ------------------------------- | --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `JAVA_HOME`                     | Path to Java installation directory.                      | Java 21 required as 'JAVA_HOME' for nvim-jdtls to function. This variable points to the JDK itself, providing programs the java tools required to function. |
| `DOTNET_ROOT`                   | .NET SDK root directory.                                  | .NET6.0 SDK / Runtime required for the OmniSharp LSP support within NeoVim. The latest that can be used is version 8.\*.\*                                  |
| `CMAKE_EXPORT_COMPILE_COMMANDS` | Specifies default CMake generator.                        | We need to tell the 'Ninja' generator to create instructions for the 'clangd' LSP. It details how C++ projects are structured.                              |
| `CMAKE_BUILD_TYPE`              | Specifies build type for CMake (e.g., Debug/Release).     | Change this between 'Debug' or 'Release' depending on whether or not you want to include debug symbols for debugging using nvim-dap in C++ projects.        |
| `CMAKE_BUILD_GENERATOR`         | Specifies the generator to be used for the build process. | Ninja is one build generator that is compatible with neovim.                                                                                                |

> **NOTE:** **'CMAKE_BUILD_GENERATOR'** should only be specified within any 'CMakeLists.txt' files you have within your C++ projects. In case your using other IDEs like Visual Studio too.

### Global environment variables:

Some environment Variables are required to be exposed to the OS at all times. For example, if you're
using the WezTerm Multiplexer (MUX), it will NOT be able to see the variables you've set within your terminal profile. <u>**It can only view those that are set within the global table, via your system settings.**</u>

| Variable              | Description                                            | Why?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| --------------------- | ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `WEZTERM_CONFIG_FILE` | Path to '.wezterm.lua' config file. (Seperate to PATH) | The 'wezterm' process must be able to access its configuration file before it initializes. Since WezTerm is responsible for launching bash specified in 'config.default_prog' and 'config.launch_menu', the configuration needs to be available globally. Not just within a shell profile like '.bashrc' or '.bash_profile'. If the '$WEZTERM_CONFIG_FILE' variable is only set in a shell profile, it won't be recognised when WezTerm starts, as the shell itself hasn't been launched yet. |

> **NOTE:** It's important that these variables are set correctly and in the right way so WezTerm
> can see it's configuration and use any custom preferences you've set within your '.wezterm.lua' config file.

#### _Correctly setting WEZTERM_CONFIG_FILE on macOS:_

We must use a '**_LaunchAgent_**' via the '_launchd_' / _<u>Launch Daemon</u>_ binary.

Within the '_~/Library/LaunchAgent_' directory, create a '_plist_' / property list file.
Name it something meaningful, using reverse DNS notation (e.g.: '_com.user.wezterm.env.plist_'), with the extension '.plist'
and populate it with the following:

<p align="center">
<img src=".images/Setting WEZTERM_CONFIG_FILE.png" alt="WezTerm Logo" width="850" height="340">
</p>

This is a property list (_plist_) containing instructions for _launchd_ (**macOS's service manager**). It defines a <u>_LaunchAgent_</u> that sets a persistent
environment variable for the user's session using the '_launchctl setenv_' command.

> **NOTE**: An agent like this runs when the user logs in, allowing the variable to be globally available to any GUI application launched during the session. So, after setting and saving this '.plist' agent file, you **_MUST APPLY_** it by:
>
> - 1st: Logging out of your system.
> - 2nd: Logging back into your system.
>
> Only then will you see the configuration file be picked up by the Wezterm Terminal Emulator.

### **Binaries to add to "_PATH_":**

Considering the scope of this '_configuration_' project, there is a lot of programs that need to be
exposed to the OS. Either via a bash profile, or the global environment variables table (_accessible via your system settings_).
Plugins will then be able to access and utilise these programs within neovim, allowing them to function as intended. Why do I suggest exposing them via
a profile instead of global table? To keep your global environment variables table tidy, as it should only be used for programs that are required system wide.

| Binary                     | Description                                                                                                                 | Why?                                                                                                                                                                                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `nvim`                     | Neovim                                                                                                                      | <u>_This project is based around this lightweight text editor._</u>                                                                                                                                                                                                                            |
| eg: `clangd`, `codelldb  ` | Neovim's Mason Plugin Manager, plugins.                                                                                     | Required to be 'findable' by other plugins mentioned within this config.                                                                                                                                                                                                                       |
| `py`                       | Python Launcher.                                                                                                            | Program that uses the latest version of python installed on your system.                                                                                                                                                                                                                       |
| eg: `pip`                  | 'Scripts' directory of every python version you have installed on your system.                                              | These directories contain the corresponding modules required by that specific version of python. <u>_And that version of python could be a dependency of another part of the system._</u>                                                                                                      |
| `lua5.1 & luarocks`        | Lua V5.1 interpreter, and it's package manager.                                                                             | Most compatible version of the lua interpreter for neovim plugin build processes, along with it's package manager, luarocks.                                                                                                                                                                   |
| `java`                     | Java JDK installation ($JAVA_HOME).                                                                                         | Java Develpment Kit (JDK) containing the The Java compiler for compiling java code to an intermediaery language (IL) / byte code, and then the Java Virtual Machine (JVM) for running that byte code (your java program).                                                                      |
| `gradle`                   | Gradle build tool.                                                                                                          | Gradle Build System for automating the creation, compilation, and packaging of Java projects using a **_compatible_** version of the JDK.                                                                                                                                                      |
| `node`                     | Node.js runtime                                                                                                             | The Node.js Runtime allows for thecution of JavaScript code outside of a browser. It utilises Google Chrome's V8 engine for this. It's required for JavaScript & TypeScript-based Neovim plugin support.                                                                                       |
| `npm`                      | Node.js' package manager                                                                                                    | Handles package management for JavaScript/TypeScript dependencies. Required for building and installing _some_ Neovim plugins.                                                                                                                                                                 |
| eg: `tsc`, `npx`           | Global 'node_modules' directory.                                                                                            | Required for accessing global node modules, such as 'tsc', a transpiler for converting TypeScript to JavaScript code. Or, 'npx' the node package runner which cancute Node.js packages without globally installing them (used by certain Neovim plugins that rely on temporary packagecution). |
| `dotnet`                   | .NET SDK CLI tool.                                                                                                          | Allows for creating, building, testing and publishing .NET applications. Required for C# language support.                                                                                                                                                                                     |
| `OmniSharp`                | .NET LSP.                                                                                                                   | Required for C# support.                                                                                                                                                                                                                                                                       |
| `g++`                      | GNU C++ compiler.                                                                                                           | Required for compiling C++ code.                                                                                                                                                                                                                                                               |
| `cargo & rustc`            | Rust's Build System / Package Manager & the Rust Compiler.                                                                  | Required for rust language support and for building rust based plugins and compiling treesitter language grammars.                                                                                                                                                                             |
| `lldb`                     | C++ Debugger.                                                                                                               | Required by 'nvim-dap' plugin within neovim for debugging C++ code.                                                                                                                                                                                                                            |
| `cmake`                    | CMake cross platform 'Meta' build system generator. It makes build ('instruction') files for other build systems to follow. | Required for managing the build process in a compiler-independent manner, when building complex C & C++ projects.                                                                                                                                                                              |
| `ninja`                    | Ninja build system for C++ projects.                                                                                        | Required by CMake for building C++ projects, and for supporting the when using the 'clangd' LSP by providing 'compile_commands.json' files.                                                                                                                                                    |
| `go & delve`               | Golang & Go 'Delve' Debug Adapter.                                                                                          | Required for go support and debugging golang code using 'nvim-dap'.                                                                                                                                                                                                                            |

### **Luarocks modules / rocks (<u>_packages/libraries_</u>) support:**

Luarocks is a native lua package manager. You can download and use modules to make life a little easier both within a Neovim and/or a Wezterm context.

What do I mean by this?

I mean that it's possible to use luarock modules within Neovim, and also Wezterm. The way this project is configured means that the surrounding WezTerm Application / process 'looks into' the Neovim configuration files, in order to find how it itself is configured, and to also find dependency utility modules. This was purely by choice to keep everything as tightly bundled together as possible.

So, you can easily navigate to and from the same general directory hierarchy to make changes to both WezTerm and Neovim settings.

However, there are steps to properly configure the 'tree' so that the luarock manager installs modules to the correct location so they can actually be used by these applications.

_**<u>Steps to configure:</u>**_

1. Download the luarocks package via homebrew.
2. Create a directory called 'luarocks' within the '~/.config/' directory.
3. Create a file called 'config.lua' file within that 'luarocks' directory.
4. Type the following snippet into that 'config.lua' file:

<p align="center">
<img src=".images/luarocks_config.png" alt="WezTerm Logo" width="850" height="300">
</p>

> _Note_: This path should be later added to the runtimepath (rtp) for both your Neovim and Wezterm application instances, so both can look into this directory to be able to '<u>_require_</u>' modules installed via luarocks.

5. Point the luarocks package manager to it's intended configuration file, by setting the LUAROCKS_CONFIG environment variable within either your '.bash_profile' or '.bashrc':

<p align="center">
<img src=".images/luarocks_env_var.png" alt="WezTerm Logo" width="850" height="75">
</p>

That's it, you should now be able to require modules both within a Neovim or Wezterm application runtime context.

> _Note_: When using the 'luarocks install' command, you **MUST** use the '--tree' parameter to specify the name of the root you wish to access, in order to install the plugin there. 'system' is the default and is considered '_system-wide_', and is handled by homebrew.
