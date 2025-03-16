#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== ImGui Manual Build Script ===${NC}"

# Check if we want to build for emscripten or desktop
if [ "$1" == "web" ]; then
    echo -e "${GREEN}Building for web (Emscripten)...${NC}"
    
    # Source the Emscripten environment 
    source /emsdk/emsdk_env.sh
    
    # Make sure emscripten is in the path
    if ! command -v emcc &> /dev/null; then
        echo -e "${YELLOW}emcc not found in path, activating emsdk...${NC}"
        pushd /emsdk
        ./emsdk activate latest
        source ./emsdk_env.sh
        popd
    fi
    
    mkdir build_emscripten
    cd build_emscripten
    emcmake cmake .. -DCMAKE_BUILD_TYPE=Release # (Release builds lead to smaller files)
    make -j 4
    
    echo -e "${GREEN}Build complete. Starting web server...${NC}"
    echo -e "${GREEN}Browse to http://localhost:8000/src/imgui_manual.html${NC}"
    
    # Start web server
    python3 -m http.server
else
    echo -e "${GREEN}Building for desktop...${NC}"
    
    # Create build directory if it doesn't exist
    mkdir -p build
    cd build
    
    # Configure with CMake
    cmake ..
    
    echo -e "${GREEN}Build complete. Run with:${NC}"
    echo -e "${GREEN}./src/imgui_manual${NC}"
fi