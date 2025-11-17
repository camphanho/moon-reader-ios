import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { Book } from '../models/Book';
import { TextRenderer } from '../core/textRenderer/TextRenderer';
import { PageCalculator } from '../core/textRenderer/PageCalculator';
import { Theme, TextAlignment } from '../utils/constants';
import { useStatisticsStore } from './statisticsStore';

interface ReaderState {
  currentBook?: Book;
  renderedContent: ReturnType<typeof TextRenderer.render> | null;
  pagination: ReturnType<typeof PageCalculator.calculate> | null;
  currentPage: number;
  sessionStart: number | null;
  theme: Theme;
  fontSize: number;
  lineHeight: number;
  margin: number;
  alignment: TextAlignment;
  isLoading: boolean;
  loadBook: (book: Book) => Promise<void>;
  setPage: (page: number) => void;
  updateSettings: (settings: Partial<ReaderSettings>) => void;
}

interface ReaderSettings {
  theme: Theme;
  fontSize: number;
  lineHeight: number;
  margin: number;
  alignment: TextAlignment;
}

const defaultSettings: ReaderSettings = {
  theme: Theme.DAY,
  fontSize: 16,
  lineHeight: 24,
  margin: 16,
  alignment: TextAlignment.LEFT,
};

export const useReaderStore = create<ReaderState>()(
  persist(
    (set, get) => ({
      renderedContent: null,
      pagination: null,
      currentPage: 0,
      theme: defaultSettings.theme,
      fontSize: defaultSettings.fontSize,
      lineHeight: defaultSettings.lineHeight,
      margin: defaultSettings.margin,
      alignment: defaultSettings.alignment,
      sessionStart: null,
      isLoading: false,
      async loadBook(book: Book) {
        const statsStore = useStatisticsStore.getState();
        set({ isLoading: true });
        try {
          // Placeholder content - actual content should be stored in book record or separate table
          const bookContent = book.groupBooks.join('\n\n');

          const content = TextRenderer.render(
            bookContent,
            {
              fontFamily: 'System',
              fontSize: get().fontSize,
              lineHeight: get().lineHeight,
              theme: get().theme,
              margin: get().margin,
              alignment: get().alignment,
              width: 375,
              height: 667,
            }
          );

          const pagination = PageCalculator.calculate(content, {
            fontFamily: 'System',
            fontSize: get().fontSize,
            lineHeight: get().lineHeight,
            theme: get().theme,
            margin: get().margin,
            alignment: get().alignment,
            width: 375,
            height: 667,
          });

          set({
            currentBook: book,
            renderedContent: content,
            pagination,
            currentPage: book.currentPage,
            sessionStart: Date.now(),
            isLoading: false,
          });
        } catch (error) {
          set({ isLoading: false });
        }
      },
      setPage(page) {
        const statsStore = useStatisticsStore.getState();
        const state = get();
        const pagination = state.pagination;
        if (!pagination || !state.currentBook || state.sessionStart === null) return;
        const clampedPage = Math.max(0, Math.min(page, pagination.totalPages - 1));
        const durationSeconds = (Date.now() - state.sessionStart) / 1000;
        const wordsPerPage = pagination.totalPages > 0 ? Math.round((state.renderedContent?.wordCount || 0) / pagination.totalPages) : 250;
        statsStore.logReadingSession(state.currentBook, durationSeconds, wordsPerPage);
        set({ currentPage: clampedPage, sessionStart: Date.now() });
      },
      updateSettings(settings) {
        set(settings);
        const book = get().currentBook;
        if (book) {
          get().loadBook(book);
        }
      },
    }),
    {
      name: 'reader-store',
      partialize: (state) => ({
        theme: state.theme,
        fontSize: state.fontSize,
        lineHeight: state.lineHeight,
        margin: state.margin,
        alignment: state.alignment,
      }),
    }
  )
);

