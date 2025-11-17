import * as Speech from 'expo-speech';
import { create } from 'zustand';

interface TTSState {
  isSpeaking: boolean;
  isPaused: boolean;
  voice?: string;
  rate: number;
  pitch: number;
  voices: Speech.Voice[];
  loadVoices: () => Promise<void>;
  setVoice: (voice: string) => void;
  setRate: (rate: number) => void;
  setPitch: (pitch: number) => void;
  speak: (text: string) => Promise<void>;
  pause: () => void;
  resume: () => void;
  stop: () => void;
}

export const useTTSStore = create<TTSState>((set, get) => ({
  isSpeaking: false,
  isPaused: false,
  voice: undefined,
  rate: 1.0,
  pitch: 1.0,
  voices: [],
  async loadVoices() {
    try {
      const voices = await Speech.getAvailableVoicesAsync();
      set({ voices });
      if (!get().voice && voices.length > 0) {
        set({ voice: voices.find((v) => v.language.startsWith('vi'))?.identifier || voices[0].identifier });
      }
    } catch (error) {
      console.warn('Không thể tải danh sách giọng đọc', error);
    }
  },
  setVoice(voice) {
    set({ voice });
  },
  setRate(rate) {
    set({ rate });
  },
  setPitch(pitch) {
    set({ pitch });
  },
  async speak(text) {
    if (!text.trim()) return;
    const { voice, rate, pitch } = get();
    Speech.stop();
    set({ isSpeaking: true, isPaused: false });
    Speech.speak(text, {
      voice,
      rate,
      pitch,
      onDone: () => set({ isSpeaking: false, isPaused: false }),
      onStopped: () => set({ isSpeaking: false, isPaused: false }),
      onError: () => set({ isSpeaking: false, isPaused: false }),
    });
  },
  pause() {
    if (!get().isSpeaking) return;
    Speech.pause();
    set({ isPaused: true });
  },
  resume() {
    Speech.resume();
    set({ isPaused: false });
  },
  stop() {
    Speech.stop();
    set({ isSpeaking: false, isPaused: false });
  },
}));

