# txt2audio

A lightweight, local developer tool built to convert English text into high-quality audio files to assist with daily language learning and listening practice.

## 🚀 Features
* **High-Quality Voices**: Powered by `edge-tts`, utilizing natural-sounding neural voices.
* **Local Operations**: Easily input text via a local file and generate MP3 files instantly.
* **Customisable**: Easily switch between standard American (US) and British (UK) accents.

## 🛠️ Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/DerekJi/txt2audio.git
cd txt2audio
```

### 2. Install Dependencies
Make sure you have Python installed, then run:
```bash
pip install -r requirements.txt
```

### 3. Usage
1. Open `input.txt` and paste the English text, vocabulary, or articles you want to practice.
2. Run the script:
   ```bash
   python main.py
   ```
3. Find your generated audio file at `english_audio.mp3`.

## ⚙️ Configuration
You can change the speaker voice in `main.py` by modifying the `VOICE` variable:
* **US Female**: `en-US-EmmaNeural`
* **US Male**: `en-US-BrianNeural`
* **UK Female**: `en-GB-SoniaNeural`

## 📄 License
MIT License
