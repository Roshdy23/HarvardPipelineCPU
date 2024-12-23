# Variables
VHDL_COMPILER = vcom
SRC_DIR = ./src
TB_DIR = ./testbenches
WORK_DIR = work
TEMP_LOG = compile_errors.log

# Detect the shell
SHELL := $(shell echo $$SHELL)
OS := $(shell uname -s 2>/dev/null || echo Windows)

NULL = /dev/null
REMOVE = rm -f
ifeq ($(OS), Windows)
	# Windows
	NULL = nul
	REMOVE = del /f /q
endif

# Find all .vhdl files in SRC_DIR and its subfolders
SRC_FILES = $(wildcard $(SRC_DIR)/*.vhdl) $(wildcard $(SRC_DIR)/**/*.vhdl)
TB_FILES = $(wildcard $(TB_DIR)/*.vhdl) $(wildcard $(TB_DIR)/**/*.vhdl)

# Targets
all: compile

compile:
	@echo "Creating library..."
	@vlib work > $(TEMP_LOG) 2>&1
	@$(REMOVE) $(TEMP_LOG) 2>$(NULL) || true
	@echo "Compiling source files..."
	@for %%f in ($(SRC_FILES)) do ( \
		echo Compiling %%f & \
		@vcom -work work -2002 -explicit -stats=none %%f >> $(TEMP_LOG) 2>&1 || ( \
			echo Error compiling %%f >> $(TEMP_LOG) 2>&1 ) \
	)
	@echo "Compiling testbenches..."
	@for %%f in ($(TB_FILES)) do ( \
		echo Compiling %%f & \
		@vcom -work work -2002 -explicit -stats=none %%f >> $(TEMP_LOG) 2>&1 || ( \
			echo Error compiling %%f >> $(TEMP_LOG) 2>&1 ) \
	)
ifeq ($(OS),Windows)
	-@findstr /i "error" $(TEMP_LOG) > errors.log
	@if exist errors.log ( \
		type errors.log; \
	    del errors.log; \
	) else ( \
	    echo No errors found. \
	)
else
	-@grep -i "error" $(TEMP_LOG) > errors.log || true
	@if [ -s errors.log ]; then \
	    printf "$(RED)"; \
	    cat errors.log; \
	    printf "$(RESET)"; \
	    rm -f errors.log; \
	else \
	    echo "No errors found."; \
	fi
endif
	
clean:
ifeq ($(OS), Windows)
	@del /f /q $(WORK_DIR) $(TEMP_LOG) 2>nul || true
else
	@rm -rf $(WORK_DIR) $(TEMP_LOG) || true
endif
