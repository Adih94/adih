"""Generate MP3 voice assets for Mengenal Huruf A-Z (run once).

Usage: EMERGENT_LLM_KEY=... python3 tools/gen_audio.py
"""
import asyncio
import os
from pathlib import Path

from emergentintegrations.llm.openai import OpenAITextToSpeech

ROOT = Path(__file__).resolve().parent.parent / "assets" / "audio"

LETTERS = {
    "a": "Ah!", "b": "Bé!", "c": "Ché!", "d": "Dé!", "e": "É!", "f": "Ef!",
    "g": "Gé!", "h": "Ha!", "i": "Ii!", "j": "Jé!", "k": "Ka!", "l": "El!",
    "m": "Em!", "n": "En!", "o": "O!", "p": "Pé!", "q": "Ki!", "r": "Er!",
    "s": "Es!", "t": "Té!", "u": "Uu!", "v": "Fé!", "w": "Wé!", "x": "Eks!",
    "y": "Yé!", "z": "Zet!",
}

WORDS = {
    "a": "Apel", "b": "Beruang", "c": "Cicak", "d": "Durian", "e": "Es Krim",
    "f": "Foto", "g": "Gajah", "h": "Harimau", "i": "Ikan", "j": "Jeruk",
    "k": "Kucing", "l": "Lampu", "m": "Mangga", "n": "Nanas", "o": "Orang",
    "p": "Pisang", "q": "Queen", "r": "Roti", "s": "Sapi", "t": "Topi",
    "u": "Ular", "v": "Vas", "w": "Wortel", "x": "Xilofon", "y": "Yoyo", "z": "Zebra",
}


async def main():
    tts = OpenAITextToSpeech(api_key=os.environ["EMERGENT_LLM_KEY"])
    jobs = [("letters", k, v) for k, v in LETTERS.items()] + [("words", k, f"{v}!") for k, v in WORDS.items()]
    sem = asyncio.Semaphore(4)

    async def one(folder, key, text):
        out = ROOT / folder / f"{key}.mp3"
        if out.exists():
            return
        out.parent.mkdir(parents=True, exist_ok=True)
        async with sem:
            audio = await tts.generate_speech(text=text, model="tts-1-hd", voice="nova", speed=0.95)
        out.write_bytes(audio)
        print("ok", folder, key, text)

    await asyncio.gather(*(one(*j) for j in jobs))


if __name__ == "__main__":
    asyncio.run(main())
