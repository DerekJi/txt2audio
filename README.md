# txt2audio

A small personal command-line tool for converting English text into natural-sounding MP3 audio with `edge-tts`.

## Features

- American, British, and Australian English voices
- Male and female voice presets
- Adjustable speed from `0.5x` to `2.0x`
- Optional pitch adjustment
- Text file input and configurable MP3 output
- Support for batch processing chapters via shell scripts
- No AI API key required; an internet connection is required by `edge-tts`

## Project Structure

```text
.
├── .venv/            # Python virtual environment
├── output/           # Generated MP3 audio files
├── scripts/
│   └── spylark.sh    # Batch audio conversion script for chapters
├── src/
│   └── main.py       # Core Python conversion script
├── txt/              # Input text files (e.g., sample.txt)
├── Makefile          # Convenient automation commands
└── requirements.txt  # Project dependencies

```

## Setup

Install the dependency:

```bash
make install
```

If GNU Make is installed, common commands can be executed easily:

```bash
make install
make run
make voices
make clean
```

## Usage

### 1. Python Direct Usage

List the built-in voice presets:

```bash
python src/main.py --list-voices
```

Generate audio with a specific voice, speed, and output path:

```bash
python src/main.py txt/sample.txt --voice au-female --speed 0.85 --output output/practice.mp3
```

Available presets:

| Preset | Voice | Description |
| --- | --- | --- |
| `us-female` | `en-US-AriaNeural` | American English female |
| `us-male` | `en-US-GuyNeural` | American English male |
| `uk-female` | `en-GB-SoniaNeural` | British English female |
| `uk-male` | `en-GB-RyanNeural` | British English male |
| `au-female` | `en-AU-NatashaNeural` | Australian English female |
| `au-male` | `en-AU-WilliamNeural` | Australian English male |

### 2. Makefile Automation

Custom parameters and spaces in filenames are fully supported via the `Makefile`:

* **Default run**:
```bash
make run
```

* **Quick parameters (Voice, Speed, Input)**:
```bash
make run speed=1.2 voice=us-male
make run input="txt/my book.txt" speed=1.5
```

* **Pass native arguments using ARGS**:
```bash
make run ARGS="--speed 1.5 --pitch +5Hz"
```

### 3. Batch Chapter Conversion (`scripts/spylark.sh`)

For batch-converting chapter markdown or text files (e.g., automated book reading), use the provided shell script:

* Default run (Chapters `01` to `30`):
```bash
bash scripts/spylark.sh
```

* Specify end chapter (Runs `01` to `27`):
```bash
bash scripts/spylark.sh 27
```

* Specify custom start and end chapters (Runs `05` to `27`):
```bash
bash scripts/spylark.sh 05 27
```

## Notes

This project uses the public `edge-tts` client and does not require an API key. It needs internet access each time audio is generated. Generated audio files in the `output/` directory are ignored by Git.
