CC = emcc
CXX = em++

BUILD_DIR = build
SRC_DIR = src
OBJ_DIR = $(BUILD_DIR)/obj
EXE = $(BUILD_DIR)/index.html
IMGUI_DIR = ./external/imgui

# Automatically find all source files in SRC_DIR
SRC_FILES := $(wildcard $(SRC_DIR)/*.cpp)

# ImGui source files
IMGUI_SOURCES = \
	$(IMGUI_DIR)/imgui.cpp \
	$(IMGUI_DIR)/imgui_demo.cpp \
	$(IMGUI_DIR)/imgui_draw.cpp \
	$(IMGUI_DIR)/imgui_tables.cpp \
	$(IMGUI_DIR)/imgui_widgets.cpp \
	$(IMGUI_DIR)/backends/imgui_impl_sdl2.cpp \
	$(IMGUI_DIR)/backends/imgui_impl_opengl3.cpp \
	$(IMGUI_DIR)/misc/cpp/imgui_stdlib.cpp \
	$(IMGUI_DIR)/misc/freetype/imgui_freetype.cpp

SOURCES = $(SRC_FILES) $(IMGUI_SOURCES)
OBJS = $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(basename $(notdir $(SOURCES)))))

CPPFLAGS = -g -I$(IMGUI_DIR) -I$(IMGUI_DIR)/backends -I$(IMGUI_DIR)/misc/cpp -I$(SRC_DIR) -I/usr/include/freetype2 -Wall -Wformat -Os
LDFLAGS = -g -gsource-map -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -s NO_EXIT_RUNTIME=0 -s ASSERTIONS=1
EMS = -s USE_SDL=2 -s DISABLE_EXCEPTION_CATCHING=1 -s FETCH=1

USE_FILE_SYSTEM ?= 1
ifeq ($(USE_FILE_SYSTEM), 0)
	LDFLAGS += -s NO_FILESYSTEM=1
	CPPFLAGS += -DIMGUI_DISABLE_FILE_FUNCTIONS
endif
ifeq ($(USE_FILE_SYSTEM), 1)
	LDFLAGS += --no-heap-copy --preload-file $(IMGUI_DIR)/misc/fonts@/fonts
endif

CPPFLAGS += $(EMS)
LDFLAGS += --shell-file $(SRC_DIR)/emscripten/shell_minimal.html $(EMS)

##---------------------------------------------------------------------
## BUILD RULES
##---------------------------------------------------------------------

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(IMGUI_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(IMGUI_DIR)/backends/%.cpp | $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(IMGUI_DIR)/misc/cpp/%.cpp | $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(IMGUI_DIR)/misc/freetype/%.cpp | $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

all: $(EXE)
	@echo "Build complete: $(EXE)"

$(BUILD_DIR) $(OBJ_DIR):
	mkdir -p $@

serve: all
	python3 -m http.server -d $(BUILD_DIR)

$(EXE): $(OBJS) | $(BUILD_DIR)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS)

clean:
	rm -rf $(OBJ_DIR) $(BUILD_DIR)
