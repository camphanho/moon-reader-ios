import { create } from 'zustand';
import { User } from 'firebase/auth';
import { firebaseUtils } from '../services/firebase';

interface AuthState {
  user: User | null;
  isLoading: boolean;
  error?: string;
  initialize: () => void;
  signIn: () => Promise<void>;
  signOut: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  isLoading: false,
  initialize() {
    set({ isLoading: true });
    firebaseUtils.onAuthStateChanged((user) => {
      set({ user, isLoading: false });
    });
  },
  async signIn() {
    set({ isLoading: true, error: undefined });
    try {
      await firebaseUtils.signInAnonymously();
    } catch (error: any) {
      set({ error: error.message });
    } finally {
      set({ isLoading: false });
    }
  },
  async signOut() {
    set({ isLoading: true, error: undefined });
    try {
      await firebaseUtils.signOut();
      set({ user: null });
    } catch (error: any) {
      set({ error: error.message });
    } finally {
      set({ isLoading: false });
    }
  },
}));

