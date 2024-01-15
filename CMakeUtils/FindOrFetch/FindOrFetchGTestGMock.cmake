#[==================================================[
Either find preinstaled GTest package, or if it's absent, fetch it from github.
But Do NOT use cmake find on Windows because of compilation/linking incompatibility; 
instead on Windows fetch gtest from github (this builds nicely with source code)
#]==================================================]
set(packageName GTest)
set(packageVersion 1.13.0)

#[==================================================[
Point the path to ${packageName}Config.cmake or ${packageName}-config.cmake
if the package is not on the standard search path nor in CMAKE_INSTALL_PREFIX
#]==================================================]
if(CMAKE_CXX_COMPILER_ID STREQUAL Clang)
    # Point to local gtest that was compiled with Clang;
    # It matters on Mac OS X (but not on Linux) what gtest was compiled with
    set(compilerSubDir Clang)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL GNU)
    # Point to local gtest that was compiled with Gnu;
    # It matters on Mac OS X (but not on Linux) what gtest was compiled with
    set(compilerSubDir Gnu)
endif()

if(NOT DEFINED ${packageName}_DIR)
    message(STATUS "not yet defined: ${packageName}_DIR = " ${${packageName}_DIR})
else()
    message(STATUS "already defined: ${packageName}_DIR = " ${${packageName}_DIR})
endif()

# if(linkGTestAsSharedLibrary)
#     if(LINUX)
#         set(${packageName}_DIR /opt/googletest/shared/lib64/cmake/GTest)
#     elseif(APPLE)
#         set(${packageName}_DIR /opt/googletest/${compilerSubDir}/shared/lib/cmake/GTest)
#     elseif(UNIX AND NOT APPLE)
#         set(${packageName}_DIR )
#     endif()
# else()
#     if(LINUX)
#         set(${packageName}_DIR /opt/googletest/static/lib64/cmake/GTest)
#     elseif(APPLE)
#         set(${packageName}_DIR /opt/googletest/${compilerSubDir}/static/lib/cmake/GTest)
#     elseif(UNIX AND NOT APPLE)
#         set(${packageName}_DIR )
#     endif()
# endif()

if(NOT WIN32)
    # Omit the REQUIRED keyword so as to be able to fetch the package (as below) if it is not installed
    find_package(${packageName} ${packageVersion})

    if(${packageName}_FOUND)
        message(STATUS "${packageName}_FOUND: ${${packageName}_FOUND}")
        message(STATUS "${packageName}_VERSION: ${${packageName}_VERSION}")
        message(STATUS "${packageName}_INCLUDE_DIRS: ${${packageName}_INCLUDE_DIRS}")
        message(STATUS "${packageName}_LIBRARIES: ${${packageName}_LIBRARIES}")

        # set(gtest_force_shared_crt ON CACHE BOOL "On Windows don't override this project's linker settings; always use msvcrt.dll" FORCE)
    endif()
endif()

if(WIN32 OR NOT ${packageName}_FOUND)
    include(FetchContent)
    set(FETCHCONTENT_QUIET FALSE)
    
    FetchContent_Declare(googletest
        GIT_REPOSITORY  https://github.com/google/googletest.git
        GIT_TAG         main # v1.14.0
        SOURCE_DIR      ${CMAKE_SOURCE_DIR}/External/googletest
        GIT_PROGRESS    TRUE
        GIT_SHALLOW     TRUE
        USES_TERMINAL_DOWNLOAD TRUE   # <---- only used by Ninja generator
    )

    FetchContent_MakeAvailable(googletest)
endif()

include(GoogleTest)
