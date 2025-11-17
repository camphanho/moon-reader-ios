import { create } from 'zustand';
import { useAuthStore } from './authStore';
import { useBookStore } from './bookStore';
import { useBookmarkStore } from './bookmarkStore';
import { useStatisticsStore } from './statisticsStore';
import { firebaseUtils, db } from '../services/firebase';
import { useReaderStore } from './readerStore';
import { collection, doc, setDoc, getDocs } from 'firebase/firestore';

interface SyncState {
  isSyncing: boolean;
  lastSynced?: Date;
  error?: string;
  syncAll: () => Promise<void>;
}

export const useSyncStore = create<SyncState>((set, get) => ({
  isSyncing: false,
  lastSynced: undefined,
  error: undefined,
  async syncAll() {
    const authStore = useAuthStore.getState();
    if (!authStore.user) {
      set({ error: 'Bạn cần đăng nhập để đồng bộ.' });
      return;
    }
    set({ isSyncing: true, error: undefined });
    try {
      const uid = authStore.user.uid;
      await Promise.all([syncBooks(uid), syncBookmarks(uid), syncStats(uid)]);
      set({ lastSynced: new Date() });
    } catch (error: any) {
      set({ error: error.message });
    } finally {
      set({ isSyncing: false });
    }
  },
}));

async function syncBooks(uid: string) {
  const bookStore = useBookStore.getState();
  const books = bookStore.books;
  const booksRef = collection(db, 'users', uid, 'books');
  for (const book of books) {
    await setDoc(doc(booksRef, book.id), {
      ...book,
      updatedAt: firebaseUtils.serverTimestamp(),
    });
  }

  const remoteBooks = await getDocs(booksRef);
  const remoteData = remoteBooks.docs.map((d) => d.data());
  if (remoteData.length > books.length) {
    bookStore.loadBooks();
  }
}

async function syncBookmarks(uid: string) {
  const bookmarkStore = useBookmarkStore.getState();
  const currentBook = useReaderBook();
  if (!currentBook) return;
  const bookmarksRef = collection(db, 'users', uid, 'books', currentBook.id, 'bookmarks');
  for (const bookmark of bookmarkStore.bookmarks) {
    await setDoc(doc(bookmarksRef, bookmark.id), {
      ...bookmark,
      updatedAt: firebaseUtils.serverTimestamp(),
    });
  }
}

async function syncStats(uid: string) {
  const statsStore = useStatisticsStore.getState();
  const currentBook = useReaderBook();
  if (!currentBook || !statsStore.currentStats) return;
  const statsRef = doc(db, 'users', uid, 'books', currentBook.id, 'statistics');
  await setDoc(statsRef, {
    ...statsStore.currentStats,
    updatedAt: firebaseUtils.serverTimestamp(),
  });
}

function useReaderBook() {
  return useReaderStore.getState().currentBook;
}

