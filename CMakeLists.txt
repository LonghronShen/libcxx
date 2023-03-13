cmake_minimum_required(VERSION 3.21 FATAL_ERROR)

set(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(project_name "libcxx")
project(${project_name} C CXX)

find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    # Support Unix Makefiles and Ninja
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
endif()

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin CACHE STRING "CMAKE_LIBRARY_OUTPUT_DIRECTORY" FORCE)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin CACHE STRING "CMAKE_RUNTIME_OUTPUT_DIRECTORY" FORCE)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin CACHE STRING "CMAKE_ARCHIVE_OUTPUT_DIRECTORY" FORCE)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin CACHE STRING "CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG" FORCE)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin CACHE STRING "CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG" FORCE)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(CMAKE_MACOSX_RPATH 1 CACHE STRING "CMAKE_MACOSX_RPATH" FORCE)
set(CMAKE_CXX_STANDARD 20 CACHE STRING "Set to 11 or 14 to enable C++11 or C++17 builds, respectively." FORCE)
set(CMAKE_C_STANDARD 17 CACHE STRING "Set to 99 or 11 to enable C99 or C11 builds, respectively." FORCE)
set_property(GLOBAL PROPERTY CXX_STANDARD_REQUIRED ON)
set_property(GLOBAL PROPERTY C_STANDARD_REQUIRED ON)

include(DetectClang)

include(external/InitializeExternalComponents.cmake)

# TODO: make all things compile or just do some conditional compilation.
# file(GLOB_RECURSE src
#     ${CMAKE_CURRENT_LIST_DIR}/src/*.c
#     ${CMAKE_CURRENT_LIST_DIR}/src/*.cpp
#     ${CMAKE_CURRENT_LIST_DIR}/src/*.h
# )

set(src
    "${CMAKE_CURRENT_LIST_DIR}/src/algorithm.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/any.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/atomic.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/barrier.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/bind.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/charconv.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/chrono.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/condition_variable.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/condition_variable_destructor.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/debug.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/exception.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/functional.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/future.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/hash.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/ios.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/iostream.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/locale.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/memory.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/mutex.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/mutex_destructor.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/new.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/optional.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/random.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/random_shuffle.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/regex.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/shared_mutex.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/stdexcept.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/string.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/strstream.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/support/win32/locale_win32.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/support/win32/support.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/system_error.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/thread.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/typeinfo.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/utility.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/valarray.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/variant.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/vector.cpp")

add_library(${project_name}
    STATIC ${src}
)

if(WIN32 OR MINGW)
    target_link_libraries(${project_name}
        PUBLIC "winpthreads"
    )
endif()

target_include_directories(${project_name} SYSTEM
    PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include
    PRIVATE ${CMAKE_CURRENT_LIST_DIR}/src/include
)

target_compile_definitions(${project_name}
    PRIVATE "_CRT_SECURE_NO_WARNINGS"
    PRIVATE "_CRT_NONSTDC_NO_DEPRECATE"
    PRIVATE "_LIBCPP_BUILDING_LIBRARY"
    PRIVATE "_WIN32_WINNT=0x0400"
    PRIVATE "_LIB"
    PRIVATE "_UNICODE"
    PRIVATE "UNICODE"
)

if(CMAKE_CXX_IS_CLANG_WIN)
    target_compile_options(${project_name}
        PRIVATE "-march=pentium-mmx"
    )

    if(CMAKE_CXX_IS_CLANG_CL)
        target_link_options(${project_name}
            PUBLIC "/nodefaultlib:libc++"
        )
    elseif(CMAKE_CXX_IS_CLANG_CL_GNU)
        target_link_options(${project_name}
            PUBLIC "-nostdlib++"
        )
    endif()
endif()
