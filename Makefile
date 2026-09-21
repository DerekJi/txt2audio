PYTHON ?= python

# 1. Parse input and output (supporting both uppercase and lowercase arguments)
ifneq ($(input),)
    INPUT := $(input)
else ifneq ($(INPUT),)
    INPUT := $(INPUT)
else
    INPUT := txt/sample.txt
endif

# 2. Automatic renaming logic for filenames containing spaces
EMPTY := 
SPACE := $(EMPTY) $(EMPTY)
S_SPACE := ¤
INPUT_ESC := $(subst $(SPACE),$(S_SPACE),$(INPUT))

ifneq ($(strip $(INPUT)),)
    FILENAME_ESC := $(basename $(notdir $(INPUT_ESC)))
    FILENAME := $(subst $(S_SPACE),$(SPACE),$(FILENAME_ESC))
    OUTPUT_VAL := output/$(FILENAME).mp3
else
    OUTPUT_VAL := output/english_audio.mp3
endif

# Use explicitly specified output/OUTPUT if available, otherwise use the auto-calculated name
ifneq ($(output),)
    OUTPUT := $(output)
else ifneq ($(OUTPUT),)
    OUTPUT := $(OUTPUT)
else
    OUTPUT := $(OUTPUT_VAL)
endif

# 3. Extract aliases for other high-frequency parameters (for convenient command-line input)
EXTRA_ARGS :=
ifneq ($(voice),)
    EXTRA_ARGS += --voice $(voice)
endif
ifneq ($(speed),)
    EXTRA_ARGS += --speed $(speed)
endif
ifneq ($(pitch),)
    EXTRA_ARGS += --pitch $(pitch)
endif

# 4. ARGS variable as a universal fallback, allowing any native Python parameters to be passed
ARGS ?=

.PHONY: help install run voices clean

help:
	@echo "========================================================================="
	@echo "Available commands:"
	@echo "  make install  Install Python dependencies"
	@echo "  make run      Generate audio with flexible arguments"
	@echo "  make voices   List available voice presets"
	@echo "  make clean    Remove generated audio files"
	@echo "========================================================================="
	@echo "Usage & Examples (Supports spaces and all script flags):"
	@echo "  1. Default run (uses txt/sample.txt):"
	@echo "     make run"
	@echo ""
	@echo "  2. Quick parameters (change speed, switch voice):"
	@echo "     make run speed=1.2 voice=us-male"
	@echo "     make run input=\"txt/my book.txt\" speed=1.5"
	@echo ""
	@echo "  3. Use universal ARGS parameter to pass any native options:"
	@echo "     make run ARGS=\"--speed 1.5 --pitch +5Hz\""
	@echo "========================================================================="

install:
	"$(PYTHON)" -m pip install -r requirements.txt

run:
	@mkdir -p output
	"$(PYTHON)" src/main.py "$(INPUT)" --output "$(OUTPUT)" $(EXTRA_ARGS) $(ARGS)

voices:
	"$(PYTHON)" src/main.py --list-voices

clean:
	"$(PYTHON)" -c "from pathlib import Path; import shutil; shutil.rmtree(Path('output'), ignore_errors=True)"