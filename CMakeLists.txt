cmake_minimum_required(VERSION 3.15)
project(CloudFileCli LANGUAGES OBJC)

set(CMAKE_C_STANDARD 99)
set(CMAKE_OBJC_STANDARD 11)

# Plugin package
set(LR_PLUGIN_PACKAGE ${PROJECT_BINARY_DIR}/LRCloud.lrplugin)

# create cloudfile executable in the plugin package
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${LR_PLUGIN_PACKAGE})

# clean plugin package
set_directory_properties(PROPERTIES ADDITIONAL_CLEAN_FILES  ${LR_PLUGIN_PACKAGE}  )

# Define the executable
add_executable(cloudfile src/objc/main.m)

# Link required frameworks
find_library(FOUNDATION_FRAMEWORK Foundation REQUIRED)
find_library(FILEPROVIDER_FRAMEWORK FileProvider REQUIRED)

target_link_libraries(cloudfile ${FOUNDATION_FRAMEWORK} ${FILEPROVIDER_FRAMEWORK})

# Create lightroom plugin package every time a build is executed.
set(LUA_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/lua/lrcloud.lrdevplugin)

file(GLOB_RECURSE
        LUA_FILES
        RELATIVE ${LUA_SOURCE_DIR}
        ${LUA_SOURCE_DIR}/*.lua
        ${LUA_SOURCE_DIR}/*.txt
)

FOREACH(LUA_FILE ${LUA_FILES})
    ADD_CUSTOM_TARGET(${LUA_FILE} ALL
            COMMAND ${CMAKE_COMMAND} -E copy
            ${LUA_SOURCE_DIR}/${LUA_FILE}
            ${LR_PLUGIN_PACKAGE}/${LUA_FILE}
    )
ENDFOREACH()


