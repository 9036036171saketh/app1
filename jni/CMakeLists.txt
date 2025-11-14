# Sets the minimum version of CMake required to build the native library.
cmake_minimum_required(VERSION 3.22.1)

# Project name
project("flamapp_native")

# The path to the OpenCV SDK is passed from Gradle via the 'flamapp_native_opencv_dir' argument.
# We set OpenCV_DIR, which is a hint used by find_package to locate the library.
set(OpenCV_DIR "${flamapp_native_opencv_dir}/native/jni")
message(STATUS "Looking for OpenCV in: ${OpenCV_DIR}")

# Find the OpenCV package.
# This will find the OpenCV libraries and headers.
find_package(OpenCV REQUIRED)

# Add the native library source file.
add_library(
    flamapp_native
    SHARED
    native-lib.cpp
)

# Find necessary Android libraries and link them.
find_library(
    log-lib
    log
)

# Link the libraries to our native library.
target_link_libraries(
    flamapp_native
    ${log-lib}
    # Add other Android libraries here if needed (e.g., GLESv2)
    android
    EGL
    GLESv2
    ${OpenCV_LIBS}
)
