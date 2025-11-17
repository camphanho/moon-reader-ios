import { initializeApp, getApps } from 'firebase/app';
import {
  getAuth,
  signInAnonymously,
  onAuthStateChanged,
  signOut as firebaseSignOut,
  User,
} from 'firebase/auth';
import {
  getFirestore,
  collection,
  doc,
  setDoc,
  getDoc,
  getDocs,
  serverTimestamp,
} from 'firebase/firestore';
import { firebaseConfig } from '../config/firebaseConfig';

const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0];

export const auth = getAuth(app);
export const db = getFirestore(app);

export const firebaseUtils = {
  signInAnonymously: () => signInAnonymously(auth),
  onAuthStateChanged: (callback: (user: User | null) => void) => onAuthStateChanged(auth, callback),
  signOut: () => firebaseSignOut(auth),
  collection,
  doc,
  setDoc,
  getDoc,
  getDocs,
  serverTimestamp,
};

