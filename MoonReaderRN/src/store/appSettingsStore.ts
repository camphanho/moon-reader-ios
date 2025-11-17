import { Appearance } from 'react-native';
import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { Theme } from '../utils/constants';

interface AppSettingsState {
  theme: Theme;
  useSystemTheme: boolean;
  accentColor: string;
  setTheme: (theme: Theme) => void;
  toggleSystemTheme: (value: boolean) => void;
  setAccentColor: (color: string) => void;
}

const systemTheme = Appearance.getColorScheme();
const defaultTheme =
  systemTheme === 'dark'
    ? Theme.NIGHT
    : Theme.DAY;

export const useAppSettingsStore = create<AppSettingsState>()(
  persist(
    (set) => ({
      theme: defaultTheme,
      useSystemTheme: true,
      accentColor: '#2563EB',
      setTheme(theme) {
        set({ theme, useSystemTheme: false });
      },
      toggleSystemTheme(value) {
        if (value) {
          const systemPreference = Appearance.getColorScheme();
          set({
            useSystemTheme: true,
            theme: systemPreference === 'dark' ? Theme.NIGHT : Theme.DAY,
          });
        } else {
          set({ useSystemTheme: false });
        }
      },
      setAccentColor(color) {
        set({ accentColor: color });
      },
    }),
    {
      name: 'app-settings-store',
    }
  )
);

