import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { db } from '../database/database';
import { Book } from '../models/Book';
import { ReadingStatistics } from '../models/ReadingStatistics';

interface DailyLog {
  [dateKey: string]: number;
}

interface StatisticsState {
  currentStats: ReadingStatistics | null;
  dailyLog: DailyLog;
  totalTime: number;
  totalWords: number;
  isLoading: boolean;
  loadStatistics: (book: Book) => Promise<void>;
  logReadingSession: (book: Book, durationSeconds: number, wordsRead: number) => Promise<void>;
  getWeekData: () => Array<{ date: string; seconds: number }>;
}

export const useStatisticsStore = create<StatisticsState>()(
  persist(
    (set, get) => ({
      currentStats: null,
      dailyLog: {},
      totalTime: 0,
      totalWords: 0,
      isLoading: false,
      async loadStatistics(book) {
        set({ isLoading: true });
        const stats = await db.getStatisticsByBook(book.filename);
        if (stats) {
          const dailyLog: DailyLog = {};
          stats.dates.forEach((date) => {
            const key = formatDateKey(date);
            dailyLog[key] = (dailyLog[key] || 0) + 1;
          });
          set({
            currentStats: stats,
            totalTime: stats.usedTime,
            totalWords: stats.readWords,
            dailyLog,
            isLoading: false,
          });
        } else {
          set({
            currentStats: null,
            dailyLog: {},
            totalTime: 0,
            totalWords: 0,
            isLoading: false,
          });
        }
      },
      async logReadingSession(book, durationSeconds, wordsRead) {
        if (durationSeconds <= 0) return;
        const existing = get().currentStats;
        const newStats: ReadingStatistics = existing
          ? {
              ...existing,
              usedTime: existing.usedTime + durationSeconds,
              readWords: existing.readWords + wordsRead,
              dates: [...existing.dates, new Date()],
            }
          : {
              id: book.id,
              bookFilename: book.filename,
              usedTime: durationSeconds,
              readWords: wordsRead,
              dates: [new Date()],
            };

        await db.addStatistics(newStats);
        await get().loadStatistics(book);
      },
      getWeekData() {
        const log = get().dailyLog;
        const result: Array<{ date: string; seconds: number }> = [];
        for (let i = 6; i >= 0; i--) {
          const date = new Date();
          date.setDate(date.getDate() - i);
          const key = formatDateKey(date);
          result.push({
            date: key.split('-').slice(1).join('/'),
            seconds: log[key] || 0,
          });
        }
        return result;
      },
    }),
    {
      name: 'statistics-store',
      partialize: (state) => ({
        dailyLog: state.dailyLog,
        totalTime: state.totalTime,
        totalWords: state.totalWords,
      }),
    }
  )
);

function formatDateKey(date: Date) {
  return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
}

