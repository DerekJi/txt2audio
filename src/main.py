"""Convert English text to an MP3 file with Microsoft Edge neural voices."""

from __future__ import annotations

import argparse
import asyncio
from pathlib import Path

import edge_tts


VOICES = {
    "us-female": ("American English female", "en-US-AriaNeural"),
    "us-male": ("American English male", "en-US-GuyNeural"),
    "uk-female": ("British English female", "en-GB-SoniaNeural"),
    "uk-male": ("British English male", "en-GB-RyanNeural"),
    "au-female": ("Australian English female", "en-AU-NatashaNeural"),
    "au-male": ("Australian English male", "en-AU-WilliamNeural"),
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Convert English text to an MP3 file with edge-tts."
    )
    parser.add_argument(
        "input",
        nargs="?",
        type=Path,
        default=Path("txt/sample.txt"),
        help="Input text file (default: txt/sample.txt).",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        default=Path("output/english_audio.mp3"),
        help="Output MP3 path (default: output/english_audio.mp3).",
    )
    parser.add_argument(
        "-v",
        "--voice",
        choices=sorted(VOICES),
        default="au-male",
        help="Voice preset (default: au-male).",
    )
    parser.add_argument(
        "-s",
        "--speed",
        type=float,
        default=1.0,
        help="Playback speed multiplier, from 0.5 to 2.0 (default: 1.0).",
    )
    parser.add_argument(
        "--pitch",
        default="+0Hz",
        help="Voice pitch adjustment, for example +10Hz or -5Hz (default: +0Hz).",
    )
    parser.add_argument(
        "--list-voices",
        action="store_true",
        help="List the available built-in voice presets and exit.",
    )
    return parser.parse_args()


def read_text(path: Path) -> str:
    if not path.is_file():
        raise FileNotFoundError(f"Input file not found: {path}")

    text = path.read_text(encoding="utf-8").strip()
    if not text:
        raise ValueError(f"Input file is empty: {path}")
    return text


def speed_to_rate(speed: float) -> str:
    if not 0.5 <= speed <= 2.0:
        raise ValueError("Speed must be between 0.5 and 2.0.")

    percentage = round((speed - 1.0) * 100)
    return f"{percentage:+d}%"


async def generate_audio(
    text: str,
    output: Path,
    voice: str,
    speed: float,
    pitch: str,
) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    communicate = edge_tts.Communicate(
        text,
        voice=voice,
        rate=speed_to_rate(speed),
        pitch=pitch,
    )
    await communicate.save(str(output))


def print_voices() -> None:
    for key, (description, voice) in VOICES.items():
        print(f"{key:12} {voice:24} {description}")


def main() -> int:
    args = parse_args()

    if args.list_voices:
        print_voices()
        return 0

    try:
        text = read_text(args.input)
        voice = VOICES[args.voice][1]
        asyncio.run(generate_audio(text, args.output, voice, args.speed, args.pitch))
    except (FileNotFoundError, ValueError, OSError) as error:
        print(f"Error: {error}")
        return 1
    except Exception as error:
        print(f"Audio generation failed: {error}")
        print("Check your internet connection and try again.")
        return 1

    print(f"Generated: {args.output}")
    print(f"Voice: {voice} | Speed: {args.speed:g}x | Pitch: {args.pitch}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())