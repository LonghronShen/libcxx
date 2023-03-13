find_package(Threads REQUIRED)

include(FetchContent)
include(CheckIncludeFileCXX)

cmake_policy(SET CMP0097 NEW)

if(MINGW OR CMAKE_CXX_IS_CLANG_WIN)
    # winpthreads
    FetchContent_Declare(winpthreads
        GIT_REPOSITORY https://github.com/LonghronShen/winpthreads.git
        GIT_TAG master
        GIT_SHALLOW TRUE
        GIT_SUBMODULES "")

    FetchContent_GetProperties(winpthreads)
    if(NOT winpthreads_POPULATED)
        FetchContent_Populate(winpthreads)
        add_subdirectory(${winpthreads_SOURCE_DIR} ${winpthreads_BINARY_DIR} EXCLUDE_FROM_ALL)
    endif()
endif()
