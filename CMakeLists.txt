cmake_minimum_required(VERSION 3.29)

include(FetchContent)
FetchContent_Declare(
  lcc_cmake
  GIT_REPOSITORY https://github.com/LensPlaysGames/lcc_cmake.git
  GIT_TAG main
  EXCLUDE_FROM_ALL # CMake >= 3.28
)
FetchContent_MakeAvailable(lcc_cmake)
list(APPEND CMAKE_MODULE_PATH "${lcc_cmake_SOURCE_DIR}")
include(lcc_setup)

# Export compilation database in JSON format (for language servers).
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Use `ccache` if it is installed in system's PATH.
find_program(CCACHE_PROGRAM ccache)
if (CCACHE_PROGRAM)
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
endif()

# Turn on diagnostics colours.
if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
  add_compile_options(-fdiagnostics-color=always)
elseif (CMAKE_C_COMPILER_ID STREQUAL "Clang")
  add_compile_options(-fcolor-diagnostics)
endif()

# Use mold as the default linker, if it exists.
if (CMAKE_C_COMPILER_ID STREQUAL "GNU" OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
  find_program(MOLD_LINKER "mold")
  if (MOLD_LINKER)
    add_link_options(-fuse-ld=mold)
  endif()
endif()


project(project_glintraylib LANGUAGES CXX Glint)

FetchContent_Declare(
    raylib
    GIT_REPOSITORY https://github.com/raysan5/raylib.git
    GIT_TAG master
    EXCLUDE_FROM_ALL
)

# Disable building raylib examples/tests
set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(BUILD_TESTS OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(raylib)

add_executable(glintui main.g)
target_link_libraries(glintui PRIVATE raylib)

