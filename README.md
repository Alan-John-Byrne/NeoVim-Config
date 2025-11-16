# <p align="center">Inspired by the _💤[LazyVim](https://github.com/LazyVim/LazyVim)_ distro.</p>

| The Stack                                                                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------- |
| <p align="center"><img src=".images/apple_logo.png" alt="WezTerm Logo" width="100" height="120"></p>                            |
| <p align="center"><img src=".images/wezterm.png" alt="WezTerm Logo" width="120" height="130"></p>                               |
| <p align="center"><img src=".images/bash_logo.png" alt="WezTerm Logo" width="250" height="120"></p>                             |
| <p align="center"><img src=".images/neovim_logo.png" alt="WezTerm Logo" width="100" height="130"></p>                           |
| <p align="center"><img src=".images/lazy_logo.png" alt="WezTerm Logo" width="130" height="130"></p>                             |
| <p align="center">**Preview**</p><p align="center"><img src=".images/dashboard.png" alt="Preview" width="800" height="400"></p> |

> **Note:** This is a custom configuration project meant to mimick typical IDEs, using Bash/WezTerm. It's a work
> in progress. _I'm hoping to cover Unix system settings at some point._

**GOAL:** To put multiple complex tools together to form a powerful and extensive development environment.

> **PAIN POINTS**: \_ A list of mistakes I've made, and how to avoid them.
>
> - _'File is too large to open' (mini.files)_ : If the file is currently stored
>   on your OneDrive, please ensure your OneDrive is running and synced so you
>   actually have the file locally on your machine, to open it.
> - _'Snacks terminal not opening in the same directory as the current buffer' (snacks.nvim)_ : The terminal
>   provided by the snacks.nvim package ( _triggered via the keybind 'CTRL + /'_ ) will open in the same directory
>   where you initially entered neovim. I've added a which-key keybind to allow you
>   set the current directory to the parent directory of the current buffer, use '\<leader> + \\'. Then when you enter
>   the snacks terminal, it'll open in the same directory as the current buffer, without having to first exit and re-enter
>   neovim in that desired directory.

| Use Cases                                                                                           |
| --------------------------------------------------------------------------------------------------- |
| **Work on Projects (eg: _React + Ts /w Vite_)**: ( _More frameworks & libraries can be supported_ ) |
| <img src=".images/vite_reactts_project.jpg" alt="WezTerm Logo" width="780" height="420">            |
| **Debug Software w/ Nvim-Dap:**                                                                     |
| <img src=".images/debugging.jpg" alt="WezTerm Logo" width="780" height="420">                       |
| **Use Polyglot Development w/ WezTerm Multiplexing:**                                               |
| <img src=".images/multiplex.jpg" alt="WezTerm Logo" width="780" height="420">                       |
| **Unit Testing**: ( _Multiple Frameworks supported_ )                                               |
| **Study Algorithms w/ WezTerm Multiplexing**: (_Image Previewer included_)                          |
| <img src=".images/study_algos.jpg" alt="WezTerm Logo" width="780" height="420">                     |

> **Note:** Image previewing ONLY WORKS in terminals that support the necessary image protocols, such as WezTerm, Kitty, or other compatible terminal emulators. This will **NOT** work in BASh or basic terminal emulators that lack support for those protocols.

## Language Feature Support:

| Language   | Debugging    | LSP Support | TreeSitter Highlights | Linting  | Format On Save | Auto-Complete |
| ---------- | ------------ | ----------- | --------------------- | -------- | -------------- | ------------- |
| MarkDown   | &#x274C;     | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| Python     | &#x2611;     | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| Robot      | (_Untested_) | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| Lua        | Limited      | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| Java       | &#x2611;     | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| Golang     | &#x2611;     | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| JavaScript | &#x2611;     | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| TypeScript | &#x2611;     | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| C#         | &#x2611;     | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |
| C++        | &#x2611;     | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      |

> **Note**: 'Robot' is considered a proprietary language, explicitly used for automation testing. It still requires an LSP for proper support. There is **_no_** '_neotest_' adapter available.

## Testing Framework Support: (_via neotest_)

| Framework  | Adapter Support |
| ---------- | --------------- |
| Playwright | &#x2611;        |
| Jest       | Coming Soon     |

I plan on adding as many useful frameworks as possible.

_<u>Passing environment variables to *Node.js* based neotest-adapters_:</u><br>
When developing a Node.js application within VS code, it's highly likely you would use the 'dotenv'
package to load in custom environment variables from '.env' files, which would contain sensitive data
you wouldn't want to track on github. **_THIS WILL NOT WORK IN NEOVIM, USING NEOTEST._**

Instead, you must dynamically populate the 'env' table / option within the adapters configuration.
Similarly as you would any '.env' file when coding elsewhere. **_See the below examples for the 'neotest-playwright' adapter:_**

| Description                                                                                                                                                                                                                                                                               | Example                                                                                                                                                                                                                                                                                                      |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| <u>'**env.lua**' file </u>: <br><br> This is what will replace your typical '.env' file when using any adapter within neovim.                                                                                                                                                             | <img src=".images/neotest_env_variables_file.png" alt="WezTerm Logo" width="25000" height="500">                                                                                                                                                                                                             |
| <u>The **adapter**</u>: <br><br> This is the actual test runner that integrates with the '_nvim-neotest_' plugin. This is where your 'env.lua' variables should be either statically placed (_a regular lua table_), or dyamically loaded using a lua function.                           | <img src=".images/neotest_env_variables_adapter_config.png" alt="WezTerm Logo" width="25000" height="475"> <br><br> > _Note_: The goal is to have these dynamically loaded from your Node.js project root directory. Just like a regular '_.env_' file would be, when using vscode and the 'dotenv' package. |
| <u>**Node.js** project root search lua function</u>: <br><br> This is how you should dynamically load your '_env.lua_' table of environment variables into your adapter. Because, at runtime (i.e.: _during a test run_) they can be used by the test runner process via '_process.env_'. | <img src=".images/neotest_env_variables_population_method.png" alt="WezTerm Logo" width="25000" height="250"> <br><br> > _Note_: It's vital to understand that it's not your actual web application / Node.js project's runtime variables (_process.env_), it's the neotest test runners.                    |

**Why is this?**<br>
These '_adapters_' are external Node.js processes themselves, and they have their own respective '_process.env_'
runtime environment variables that they have access to.

They populate their own internal '_process.env_' via the '_env_' option within the adapter
configuration written in lua (<u>_as shown in the last snippet above_</u>). So, when using and adapter
to run tests you're actually starting up a seperate Node.js process (_<u>*the adapter standalone script*</u>_)
to do so.

Therefore, changing your own projects 'process.env' file when trying to add environment
variables, will **NOT** work. The adapter won't be able to see them, during it's own runtime (_i.e.: when it's running tests_),
because your project Node.js process, and the adapter script's Node.js process, are running within two seperate runtime contexts.
The adapter almost functions like a "child" Node.js process. It being ran below your own full Node.js application process.

### Setup:

All can be setup in the following steps:

1. Use brew to install NeoVim onto your system.
2. Clone or fork this repository to make it your own, into your '_~/Users/*yourusername*/.config/_' directory. (<u>\*Overwrite the 'nvim' directory if it exists already after following step **1\***</u>)
3. Install the following software and configure the following environment variables _exactly_ as shown in order to complete the setup.

> **Note**: This setup does require some knowledge of bash profiles for correctly setting environment variables.

### Environment variables (<u>Profile Specific</u>):

Many programming languages are supported within Neovim. However, in order for these languages to work, there are a few pre-requisites
that need to be in place prior to utilisation. Following is a table of environment variables that must be set to the correct values
(_paths to particular pieces of software_) in accordance to the intended plugins specifications. The plugins themselves dictate
what versions of these software components are depended on in order to work correctly. So, in case of any updates to these plugin specs,
please read them again in case of any changes being made to these dependencies.

| Variable                        | Description                                               | Why?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `JAVA_HOME`                     | Path to Java installation directory.                      | Java 21 required as '_JAVA_HOME_' for **nvim-jdtls** (_the native eclipse LSP for Java_) to function. This variable points to the Java 21 JDK itself, providing your <u>**_compatible_**</u> Java projects with hover documentation and linting.<br><br> > **_Note_**: Whilst the actual '_nvim-jdtls_' LSP requires '_Java JDK 21_' to be set in the _JAVA_HOME_ environment variable, at either the global system or shell session specific level. The build version and build type (<u>_i.e.: the type of build system used to compile your projects code_</u>) of your Java projects (_may that be <u>Maven</u> or <u>Gradle</u>_) will dictate the maximum version of the java runtime, supported by the LSP. Otherwise, this LSP will <u>**NOT**</u> work correctly. <br> <br><u>_See below compatibility list for details_</u>: <br> -> **Maven 3.9.X**: Java 8 to Java 17 LTS. <br> -> **Maven 4.X**: Java 17+.<br> -> **Gradle**: Java 17 to Java 25 |
| `DOTNET_ROOT`                   | .NET SDK root directory.                                  | The '_.NET6.0 SDK / Runtime_' is required for the OmniSharp LSP to be supported in NeoVim. <br><br> You must set '_DOTNET_ROOT_' within your '*~/.bash*profile/_' so the Omnisharp LSP ( within NeoVim - \_you install via the Mason Package manager_) can access and use the appropriate runtime (_.Net6.0_), so it can work properly. <br><br> Mason-installed binaries only need to be available in Neovim's PATH environment variable (**_not runtimepath_**) so that Neovim can locate and execute them (i.e.: the Omnisharp LSP). Once launched, these binaries may rely on external dependencies — such as the .NET 6.0 runtime in OmniSharp’s case — which must be discoverable via environment variables (_i.e.:DOTNET_ROOT_).<br><br> This LSP supports projects written in more up-to-date SDK versions, which can be installed via this tap using homebrew: <br><br> https:\/\/github.com\/isen-ng\/homebrew-dotnet-sdk-versions                  |
| `CMAKE_EXPORT_COMPILE_COMMANDS` | Specifies default CMake generator.                        | We need to tell the 'Ninja' generator to create instructions for the 'clangd' LSP. It details how C++ projects are structured.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `CMAKE_BUILD_TYPE`              | Specifies build type for CMake (e.g., Debug/Release).     | Change this between '_Debug_' or '_Release_' depending on whether or not you want to include debug symbols for debugging using nvim-dap in C++ projects.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `CMAKE_BUILD_GENERATOR`         | Specifies the generator to be used for the build process. | Ninja is one build generator that is compatible with neovim.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |

> **Note:** '_CMAKE_BUILD_GENERATOR_' should only be specified within any '_CMakeLists.txt_' files you have within your C++ projects. In case you're using other IDEs like Visual Studio too.

### Global environment variables:

Some environment Variables are required to be exposed to the OS at all times. For example, if you're
using the WezTerm Multiplexer (MUX), it will NOT be able to see the variables you've set within your terminal profile. **It can only view those that are set within the global table, via your system settings.**

| Variable              | Description                                                                        | Why?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| --------------------- | ---------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `WEZTERM_CONFIG_FILE` | Path to '.wezterm.lua' config file. (<u>_Seperate to the **$PATH** variable._</u>) | The 'wezterm' process must be able to access its configuration file before it initializes. <br><br> Since WezTerm is responsible for launching bash specified in 'config.default_prog' and 'config.launch_menu', the configuration needs to be available globally. Not just within a shell profile like '.bashrc' or '.bash_profile'. <br><br> If the '$WEZTERM_CONFIG_FILE' variable is only set in a shell profile, it won't be recognised when WezTerm starts, as the shell itself hasn't been launched yet. <br><br> **See details about how to do this below.** |

#### _Correctly setting WEZTERM_CONFIG_FILE on macOS:_

We must use a '**_LaunchAgent_**' via the '_launchd_' / _Launch Daemon_ binary.

Within the '_~/Library/LaunchAgent_' directory, create a '_plist_' / property list file.
Name it something meaningful, using reverse DNS notation (e.g.: '_com.user.wezterm.env.plist_'), with the extension '.plist'
and populate it with the following:

| Example                                                                                         |
| ----------------------------------------------------------------------------------------------- |
| <img src=".images/Setting WEZTERM_CONFIG_FILE.png" alt="WezTerm Logo" width="780" height="320"> |

> **Note:** It's important that these variables are set correctly and in the right way so WezTerm
> can see it's configuration and use any custom preferences you've set within your '.wezterm.lua' config file.

This is a property list (_plist_) containing instructions for _launchd_ (**macOS's service manager**). It defines a '_LaunchAgent_' that sets a persistent
environment variable for the user's session using the '_launchctl setenv_' command.

> **Note**: An agent like this runs when the user logs in, allowing the variable to be globally available to any GUI application launched during the session. So, after setting and saving this '.plist' agent file, you <u>**MUST APPLY**</u> it by:
>
> - 1st: Logging out of your system.
> - 2nd: Logging back into your system.
>
> Only then will you see the configuration file be picked up by the Wezterm Terminal Emulator.

### **Binaries to add to "_PATH_":**

Considering the scope of this '_configurationu_' project, there is a lot of programs that need to be
exposed to the OS. Either via a bash profile, or the global environment variables table (<u>_accessible via your system settings_</u>).
Plugins will then be able to access and utilise these programs within neovim, allowing them to function as intended. Why do I suggest exposing them via
a profile instead of global table? To keep your global environment variables table tidy, as it should only be used for programs that are required system wide.

| Binary                     | Description                                                                                                                 | Why?                                                                                                                                                                                                                                                                                                            |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `nvim`                     | Neovim                                                                                                                      | _This project is based around this lightweight text editor._                                                                                                                                                                                                                                                    |
| eg: `clangd`, `codelldb  ` | Neovim's Mason Plugin Manager, plugins.                                                                                     | Required to be 'findable' by other plugins mentioned within this config.                                                                                                                                                                                                                                        |
| `py`                       | Python Launcher.                                                                                                            | Program that uses the latest version of python installed on your system.                                                                                                                                                                                                                                        |
| eg: `pip`                  | 'Scripts' directory of every python version you have installed on your system.                                              | These directories contain the corresponding modules required by that specific version of python. _And that version of python could be a dependency of another part of the system._                                                                                                                              |
| `lua5.1 & luarocks`        | Lua V5.1 interpreter, and it's package manager.                                                                             | Most compatible version of the lua interpreter for neovim plugin build processes, along with it's package manager, luarocks.                                                                                                                                                                                    |
| `java`                     | Java JDK installation ($JAVA_HOME).                                                                                         | Java Develpment Kit (**JDK**) containing the The Java compiler for compiling java code to byte code, and then the Java Virtual Machine (**JVM**) for running that byte code (<u>_your java program_</u>).                                                                                                       |
| `gradle`                   | Gradle build tool.                                                                                                          | Gradle Build System for automating the creation, compilation, and packaging of Java projects using a **_compatible_** version of the JDK.                                                                                                                                                                       |
| `node`                     | Node.js runtime                                                                                                             | The Node.js Runtime allows for thecution of JavaScript code outside of a browser. It utilises Google Chrome's V8 engine for this. It's required for JavaScript & TypeScript-based Neovim plugin support.                                                                                                        |
| `npm`                      | Node.js' package manager                                                                                                    | Handles package management for JavaScript/TypeScript dependencies. Required for building and installing _some_ Neovim plugins.                                                                                                                                                                                  |
| eg: `tsc`, `npx`           | Global 'node_modules' directory.                                                                                            | Required for accessing global node modules, such as 'tsc', a transpiler for converting TypeScript to JavaScript code. Or, 'npx' the node package runner which can execute Node.js packages without globally installing them (<u>_used by certain Neovim plugins that rely on temporary package execution_</u>). |
| `dotnet`                   | .NET SDK CLI tool.                                                                                                          | Allows for creating, building, testing and publishing .NET applications. Required for C# language support.                                                                                                                                                                                                      |
| `g++`                      | GNU C++ compiler.                                                                                                           | Required for compiling C++ code.                                                                                                                                                                                                                                                                                |
| `cargo & rustc`            | Rust's Build System / Package Manager & the Rust Compiler.                                                                  | Required for rust language support and for building rust based plugins and compiling treesitter language grammars.                                                                                                                                                                                              |
| `lldb`                     | C++ Debugger.                                                                                                               | Required by 'nvim-dap' plugin within neovim for debugging C++ code.                                                                                                                                                                                                                                             |
| `cmake`                    | CMake cross platform 'Meta' build system generator. It makes build ('instruction') files for other build systems to follow. | Required for managing the build process in a compiler-independent manner, when building complex C & C++ projects.                                                                                                                                                                                               |
| `ninja`                    | Ninja build system for C++ projects.                                                                                        | Required by CMake for building C++ projects, and for supporting the when using the 'clangd' LSP by providing 'compile_commands.json' files.                                                                                                                                                                     |
| `go & delve`               | Golang & Go 'Delve' Debug Adapter.                                                                                          | Required for go support and debugging golang code using 'nvim-dap'.                                                                                                                                                                                                                                             |

### **Luarocks modules / rocks ( _packages/libraries_ ) support:**

Luarocks is a native lua package manager. You can download and use modules to make life a little easier both within a Neovim and/or a Wezterm context.

**_What do I mean by this?_**

I mean that it's possible to use luarock modules within Neovim, and also Wezterm. The way this project is configured means that the surrounding WezTerm Application / process 'looks into' the Neovim configuration files, in order to find how it itself is configured, and to also find dependency utility modules. This was purely by choice to keep everything as tightly bundled together as possible.

So, you can easily navigate to and from the same general directory hierarchy to make changes to both WezTerm and Neovim settings.

However, there are steps to properly configure the 'tree' so that the luarock manager installs modules to the correct location so they can actually be used by these applications.

_**Steps to configure:**_

1. Download the luarocks package via homebrew.
2. Create a directory called 'luarocks' within the '~/.config/' directory.
3. Create a file called 'config.lua' file within that 'luarocks' directory.
4. Type the following snippet into that 'config.lua' file:

| Example                                                                             |
| ----------------------------------------------------------------------------------- |
| <img src=".images/luarocks_config.png" alt="WezTerm Logo" width="850" height="300"> |

> **Note**: This path should be later added to the runtimepath (rtp) for both your Neovim and Wezterm application instances, so both can look into this directory to be able to ' _require_ ' modules installed via luarocks.

5. Point the luarocks package manager to it's intended configuration file, by setting the LUAROCKS_CONFIG environment variable within either your '.bash_profile' or '.bashrc':

| Example                                                                             |
| ----------------------------------------------------------------------------------- |
| <img src=".images/luarocks_env_var.png" alt="WezTerm Logo" width="850" height="75"> |

That's it, you should now be able to require modules both within a Neovim or Wezterm application runtime context.

> **Note**: When using the 'luarocks install' command, you **MUST** use the '--tree' parameter to specify the name of the root you wish to access, in order to install the plugin there. 'system' is the default and is considered '_system-wide_', and is handled by homebrew.
