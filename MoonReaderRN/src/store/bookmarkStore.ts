import { create } from 'zustand';
import { Bookmark, HighlightColor } from '../models/Bookmark';
import { db } from '../database/database';
import { Book } from '../models/Book';
import { generateUUID } from '../utils/helpers';

interface SelectionRange {
  paragraphId: string;
  text: string;
}

interface BookmarkState {
  bookmarks: Bookmark[];
  currentSelection: SelectionRange | null;
  selectedColor: HighlightColor;
  isMenuVisible: boolean;
  loadBookmarks: (book: Book) => Promise<void>;
  addBookmark: (bookmark: PartialBookmark) => Promise<void>;
  deleteBookmark: (bookmarkId: string) => Promise<void>;
  setSelection: (range: SelectionRange | null) => void;
  setColor: (color: HighlightColor) => void;
  setMenuVisible: (visible: boolean) => void;
}

type PartialBookmark = Omit<Bookmark, 'id' | 'time'>;

export const useBookmarkStore = create<BookmarkState>((set, get) => ({
  bookmarks: [],
  currentSelection: null,
  selectedColor: HighlightColor.YELLOW,
  isMenuVisible: false,
  async loadBookmarks(book: Book) {
    const bookmarks = await db.getBookmarksByBook(book.id);
    set({ bookmarks });
  },
  async addBookmark(bookmark) {
    const newBookmark: Bookmark = {
      id: generateUUID(),
      time: new Date(),
      ...bookmark,
    };
    await db.addBookmark(newBookmark);
    set((state) => ({ bookmarks: [...state.bookmarks, newBookmark], isMenuVisible: false, currentSelection: null }));
  },
  async deleteBookmark(bookmarkId) {
    await db.deleteBookmark(bookmarkId);
    set((state) => ({ bookmarks: state.bookmarks.filter((b) => b.id !== bookmarkId) }));
  },
  setSelection(range) {
    set({ currentSelection: range, isMenuVisible: !!range });
  },
  setColor(color) {
    set({ selectedColor: color });
  },
  setMenuVisible(visible) {
    set({ isMenuVisible: visible });
  },
}));

