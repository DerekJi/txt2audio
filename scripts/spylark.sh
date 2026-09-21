#!/bin/bash

# =========================================================================
# Default Configurations
# =========================================================================
APPNAME=$0
DEFAULT_START="01"
DEFAULT_END="41"
DEFAULT_SPEED="1.0"
BASE_DIR="/d/Obsidian/English/Spylark Chapters"

# =========================================================================
# Parameter Parsing and Help Information
# =========================================================================
show_help() {
    echo "========================================================================="
    echo "Usage:"
    echo "  $APPNAME [end_no]          -> Start from 01, run up to [end_no]"
    echo "  $APPNAME [start_no] [end_no]  -> Run from [start_no] to [end_no]"
    echo "========================================================================="
    echo "Examples:"
    echo "  1. Default run ($DEFAULT_START to $DEFAULT_END):"
    echo "     $APPNAME"
    echo ""
    echo "  2. Specify end number (automatically starts from $DEFAULT_START, e.g., run $DEFAULT_START to 27):"
    echo "     $APPNAME 27"
    echo ""
    echo "  3. Specify both start and end numbers (e.g., run 05 to 27):"
    echo "     $APPNAME 05 27"
    echo "========================================================================="
    exit 0
}

# Check if help argument is provided
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

# Dynamically assign start and end numbers based on the number of arguments provided
if [ $# -eq 0 ]; then
    # No arguments: use default values 01 to 30
    START=$DEFAULT_START
    END=$DEFAULT_END
    SPEED=$DEFAULT_SPEED
elif [ $# -eq 1 ]; then
    # One argument: treated as the end number, start number defaults to 01
    START=$DEFAULT_START
    SPEED=$DEFAULT_SPEED
    END=$1
elif [ $# -eq 2 ]; then
    # Two arguments: first is start number, second is end number
    SPEED=$DEFAULT_SPEED
    START=$1
    END=$2
elif [ $# -eq 3 ]; then
    # Three arguments: first is start number, second is end number, third is speed
    START=$1
    END=$2
    SPEED=$3
else
    echo "❌ Error: Too many arguments."
    show_help
fi

# =========================================================================
# Core Execution Logic
# =========================================================================
echo "========================================================================="
echo "🚀 Starting batch audio conversion..."
echo "📂 Target Directory: $BASE_DIR"
echo "🔢 Conversion Range: Chapter $START  ==>  Chapter $END"
echo "========================================================================="

# Force inputs to decimal to prevent Bash from treating 08, 09 as invalid octal numbers
START_INT=$((10#$START))
END_INT=$((10#$END))

# Loop through the numbers
for ((i=START_INT; i<=END_INT; i++)); do
    # Use printf to automatically pad leading zeros (e.g., 1 -> 01, 12 -> 12)
    CHAPTER=$(printf "%02d" $i)
    
    # Construct the full file path
    FILE_PATH="$BASE_DIR/(book) Spylark Chapter $CHAPTER.md"
    
    # Check if the file actually exists to prevent script abortion due to missing chapters
    if [ -f "$FILE_PATH" ]; then
        echo "─────────────────────────────────────────────────────────────────────────"
        echo "⏳ [Processing] Chapter $CHAPTER..."
        
        # Call your Makefile command with safely quoted path variables
        make run input="$FILE_PATH" speed="$SPEED"
        
    else
        echo "⚠️  [Skipped] File does not exist: (book) Spylark Chapter $CHAPTER.md"
    fi
done

echo "========================================================================="
echo "🎉 Batch conversion completed successfully!"
echo "========================================================================="