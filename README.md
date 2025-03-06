##### <u>Inspired by the 💤 [LazyVim](https://github.com/LazyVim/LazyVim) distro by folke. (Some starter template code was used here)</u>

- **NOTE**: <u>PowerShell Work in progress.</u> _Linux Version Coming too._

#### Environment Variables

| Variable                        | Description                                           | Why? |
| ------------------------------- | ----------------------------------------------------- | ---- |
| `JAVA_HOME`                     | Path to Java installation directory.                  |      |
| `DOTNET_ROOT`                   | .NET SDK root directory.                              |      |
| `CMAKE_EXPORT_COMPILE_COMMANDS` | Specifies default CMake generator.                    |      |
| `CMAKE_BUILD_TYPE`              | Specifies build type for CMake (e.g., Debug/Release). |      |

### Programming Language Feature Support Matrix

| Language   | Debugging       | LSP Support | TreeSitter Highlights | Linting  | Format On Save | Auto Complete | Unit Testing |
| ---------- | --------------- | ----------- | --------------------- | -------- | -------------- | ------------- | ------------ |
| MarkDown   | &#x274C;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | &#x274C;     |
| Python     | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| Lua        | Kind of &#8709; | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| Java       | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| JavaScript | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| TypeScript | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| C#         | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| C++        | &#x2611;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | ?            |
| PowerShell | &#x274C;        | &#x2611;    | &#x2611;              | &#x2611; | &#x2611;       | &#x2611;      | &#x274C;     |

#### **Executables to Add to $PATH**

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
