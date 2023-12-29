#[==================================================[
UnitTestStarterProject
#]==================================================]
add_executable(targetUnitTestExe)

target_include_directories(targetUnitTestExe
    PRIVATE
        ../Code/StarterProject/hdr
        UnitTestStarterProject/hdr
        ../Mock/hdr
)

target_sources(targetUnitTestExe
    PRIVATE
        ../Code/StarterProject/hdr/StarterProject.hpp
        ../Code/StarterProject/src/StarterProject.cpp
        UnitTestStarterProject/src/StarterProject_StandAloneTests.cpp
        UnitTestStarterProject/hdr/StarterProject_FixtureTests.hpp
        UnitTestStarterProject/src/StarterProject_FixtureTests.cpp
        UnitTestStarterProject/hdr/StarterProject_ParametrisedTests.hpp
        UnitTestStarterProject/src/StarterProject_ParametrisedTests.cpp
        UnitTestStarterProject/hdr/StarterProject_ParametrisedFixtureTests.hpp
        UnitTestStarterProject/src/StarterProject_ParametrisedFixtureTests.cpp
        ../Mock/hdr/IRealEntity.hpp
        ../Mock/hdr/MockEntity.hpp
        ../Mock/src/TestMockEntity.cpp
)

set_target_properties(targetUnitTestExe
    PROPERTIES
        OUTPUT_NAME                         UnitTestStarterProject
        DEBUG_POSTFIX                       "_d"
        RUNTIME_OUTPUT_DIRECTORY            ${CMAKE_BINARY_DIR}/buildOut/UnitTestStarterProject/bin/$<CONFIG>
        PDB_OUTPUT_DIRECTORY                ${CMAKE_BINARY_DIR}/buildOut/UnitTestStarterProject/pdb/$<CONFIG>
        RUNTIME_OUTPUT_DIRECTORY_<Config>   ${RUNTIME_OUTPUT_DIRECTORY}
        PDB_OUTPUT_DIRECTORY_<Config>       ${PDB_OUTPUT_DIRECTORY}
)

target_compile_features(targetUnitTestExe
    PRIVATE
        c_std_17
        cxx_std_20
)

if(MSVC)

    target_compile_options(targetUnitTestExe 
        PRIVATE
            /EHsc
            /W2
            # /Wall
    )

else()

    target_compile_options(targetUnitTestExe 
        PRIVATE
            -Wall
            # -Wextra
            # -Wpedantic
    )

endif()

#[==================================================[
Find or fetch a library and display its cmake targets
#]==================================================]
option(linkGTestAsSharedLibrary "OFF to link as static library, ON as dynamic - on Windows the latter requires the *.dll to be copied next to the .exe (this is done in add_subdirectory)" OFF)

if(WIN32)
    message(STATUS "googletest will be downloaded, built, and linked as STATIC library")
elseif(linkGTestAsSharedLibrary)
    set(isThereDllToLink ON)
    message(STATUS "linkGTestAsSharedLibrary: " ${linkGTestAsSharedLibrary} " --- googletest will be linked as SHARED library")
else()
    set(isThereDllToLink OFF)
    message(STATUS "linkGTestAsSharedLibrary: " ${linkGTestAsSharedLibrary} " --- googletest will be linked as STATIC library")
endif()

# include(GNUInstallDirs)
include(${CMAKE_SOURCE_DIR}/CMakeUtils/FindOrFetch/FindOrFetchGTestGMock.cmake)

get_property(importTargets1 DIRECTORY ${SOURCE_DIR} PROPERTY IMPORTED_TARGETS)
message(STATUS "importTargets1: ${importTargets1}")

#[==================================================[
Link executable with found/fetched libraries
#]==================================================]
target_link_libraries(targetUnitTestExe 
    PRIVATE 
        GTest::gtest_main
        GTest::gmock_main
)

#[==================================================[
Run tests
#]==================================================]
gtest_discover_tests(targetUnitTestExe)

add_custom_target(runUnitTest
    COMMAND ${CMAKE_COMMAND} -E echo "execute: $<TARGET_FILE:targetUnitTestExe>"
    COMMAND $<TARGET_FILE:targetUnitTestExe>
)
