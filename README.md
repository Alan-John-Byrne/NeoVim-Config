##### <u>Inspired by the 💤  [LazyVim](https://github.com/LazyVim/LazyVim) distro by folke. (Some starter template code was used here)</u>

* **NOTE**: <u>Work in progress.</u>

### Programming Language Feature Support Matrix

| Language | Debugging | LSP Support | TreeSitter Highlights | Linting | Format On Save | Unit Testing |
|----------|----------|----------|----------|----------|----------|----------|
| MarkDown    | &#x274C;   |  &#x2611;    | &#x2611;  |&#x2611;   |&#x2611;   |&#x274C;|
| Python     | &#x2611;  | &#x2611;   | &#x2611;   |&#x2611;   |&#x2611;   |? |
| Lua     | &#x274C;  | &#x2611;   | &#x2611;   |&#x2611;   |&#x2611;   |?|
| Java   | &#x2611;   | &#x2611;   | &#x2611;   |&#x2611;   |&#x2611;   |?|
| JavaScript    | &#x2611;   | &#x2611;   | &#x2611;   |&#x2611;   |&#x2611;   |?|
| TypeScript    | &#x274C;   | &#x2611;   | &#x274C;   |&#x2611;   |&#x2611;   |?|
| C#     | &#x274C;   | &#x2611;   | &#x2611;   |&#x2611;   |&#x2611;   |?|
| C++    | &#x2611;   |  &#x2611;    | &#x2611;  |&#x2611;   |&#x2611;   |?|

### **Executable & Environment Variable Requirement Matrix**

#### **Executables to Add to $PATH**

| Executable   | Description |
|-------------|------------|
| `python`    | Python interpreter. |
| `pip`       | Python package manager. |
| `lua`       | Lua interpreter. |
| `luarocks`  | Lua package manager. |
| `java`      | Java runtime. |
| `javac`     | Java compiler. |
| `mvn`       | Apache Maven (Java build tool). |
| `gradle`    | Gradle build tool. |
| `node.js`      | Node.js runtime required for JavaScript support. |
| `npm`       | Node.js package manager required for building *some* plugins. |
| `npx`       | Node.js package runner. |
| `tsc`       | TypeScript compiler (from npm). |
| `dotnet`    | .NET SDK CLI tool. |
| `msbuild`   | Microsoft build system for .NET. |
| `g++`       | GNU C++ compiler. |
| `clang++`   | Clang C++ compiler. |
| `cmake`     | CMake build system. |
| `make`      | Make build automation tool. |

#### Environment Variables 

| Variable              | Description |
|----------------------|------------|
| `PYTHONPATH`        | Additional Python module search paths. |
| `LUA_PATH`          | Additional Lua module search paths. |
| `JAVA_HOME`         | Path to Java installation directory. |
| `JDK_HOME`          | Alternative Java installation path. |
| `NODE_PATH`         | Additional Node.js module paths. |
| `TSCONFIG_PATH`     | Custom path to TypeScript configuration. |
| `DOTNET_ROOT`       | .NET SDK root directory. |
| `MSBUILD_EXE_PATH`  | Path to MSBuild executable. |
| `CMAKE_GENERATOR`   | Specifies default CMake generator. |
| `CMAKE_BUILD_TYPE`  | Specifies build type for CMake (e.g., Debug/Release). |
