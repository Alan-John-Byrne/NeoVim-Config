# Inspired by the 💤[LazyVim](https://github.com/LazyVim/LazyVim) neovim distro, by folke.

<p align="center">
  <img src=".images/lazy_logo.png" alt="LazyVim Logo" width="100" height="70">
  <br>
  <img src=".images/neovim_logo.png" alt="NeoVim Logo" width="100" height="130">
</p>

> **NOTE:** This is a custom project/IDE based in PowerShell. A work in progress that's even changing.
> There's plans to create a compatible setup for Unix environments.

**GOAL:** Improved project development workflow.

## Use Cases:

### Examples in Python

- **Studying Algorithms**:
  ![Kandan's Algorithm Code](.images/kandanes_algorithm_code.jpg)
- **Image Previewer**: (Studying Algorithms w/ *MS Paint*🎨)
  ![MS Paint Illustration](.images/image_previewer.jpg)

  > **NOTE:** Image previewing ONLY WORKS in terminals that support the necessary image protocols, such as WezTerm, Kitty, or other compatible terminal emulators. This will **NOT** work in PowerShell, Command Prompt, or basic terminal emulators that lack support for those protocols.

- Debugging Software:
  ![Debugging Code](.images/debugging.jpg)
- Unit Testing: ??? (Coming Soon)

## Language Feature Support:

| Language   | Debugging       | LSP Support | TreeSitter Highlights | Linting  | Format On Save | Auto-Complete | Unit Testing |
| ---------- | --------------- | ----------- | --------------------- | -------- | -------------- | ------------- | ------------ |
| MarkDown   | &#x274C;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | &#x274C;     |
| Python     | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| Lua        | Kind of &#8709; | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| Java       | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| Golang     | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| JavaScript | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| TypeScript | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| C#         | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| C++        | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| PowerShell | &#x274C;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | &#x274C;     |

## Setup:

This setup does require some knowledge of powershell profiles for correctly setting environment variables
(_used during open powershell sessions_), or you could just set them within the global table on windows.

## Environment Variables

This config is instended to demonstrate that it's possible to have multiple language support within neovim. In order for these languages
to work as intended, there are a few pre-requisites that need to be in place prior to utilisation.

| Variable                        | Description                                           | Why? |
| ------------------------------- | ----------------------------------------------------- | ---- |
| `JAVA_HOME`                     | Path to Java installation directory.                  |      |
| `DOTNET_ROOT`                   | .NET SDK root directory.                              |      |
| `CMAKE_EXPORT_COMPILE_COMMANDS` | Specifies default CMake generator.                    |      |
| `CMAKE_BUILD_TYPE`              | Specifies build type for CMake (e.g., Debug/Release). |      |

## **Executables to add to the "$PATH" variable:**

Considering the scope and ambitious versatility of this configuration project, there's alot of programs that need to be
exposed to the Windows OS via either a powershell profile, or your global environment variables table accessible via the windows settings.
This allows for these programs to be used by plugins in neovim, allowing them to work as intended.

| Executable | Description                                                   | Why? |
| ---------- | ------------------------------------------------------------- | ---- |
| `python`   | Python interpreter.                                           |      |
| `py`       | Python Launcher.                                              |      |
| `pip`      | Python package manager.                                       |      |
| `lua`      | Lua interpreter.                                              |      |
| `luarocks` | Lua package manager.                                          |      |
| `java`     | Java runtime.                                                 |      |
| `javac`    | Java compiler.                                                |      |
| `mvn`      | Apache Maven (Java build tool).                               |      |
| `gradle`   | Gradle build tool.                                            |      |
| `node.js`  | Node.js runtime required for JavaScript support.              |      |
| `npm`      | Node.js package manager required for building _some_ plugins. |      |
| `npx`      | Node.js package runner.                                       |      |
| `tsc`      | TypeScript compiler (from npm).                               |      |
| `dotnet`   | .NET SDK CLI tool.                                            |      |
| `msbuild`  | Microsoft build system for .NET.                              |      |
| `g++`      | GNU C++ compiler.                                             |      |
| `clang++`  | Clang C++ compiler.                                           |      |
| `cmake`    | CMake build system.                                           |      |
| `make`     | Make build automation tool.                                   |      |
