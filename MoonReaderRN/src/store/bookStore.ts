import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import * as DocumentPicker from 'expo-document-picker';
import { Alert } from 'react-native';
import { Book, BookFormat } from '../models/Book';
import { db } from '../database/database';
import { BookParserFactory } from '../core/parsers/BookParserFactory';
import { TextRenderer } from '../core/textRenderer/TextRenderer';
import { PageCalculator } from '../core/textRenderer/PageCalculator';
import { Theme, TextAlignment } from '../utils/constants';
import { generateUUID } from '../utils/helpers';

type ViewMode = 'grid' | 'list';

interface BookStoreState {
  books: Book[];
  isLoading: boolean;
  viewMode: ViewMode;
  searchQuery: string;
  error?: string;
  loadBooks: () => Promise<void>;
  refreshBooks: () => Promise<void>;
  setViewMode: (mode: ViewMode) => void;
  setSearchQuery: (query: string) => void;
  importBook: () => Promise<void>;
}

export const useBookStore = create<BookStoreState>()(
  persist(
    (set, get) => ({
      books: [],
      isLoading: false,
      viewMode: 'grid',
      searchQuery: '',
      async loadBooks() {
        set({ isLoading: true });
        try {
          const books = await db.getAllBooks();
          set({ books, isLoading: false, error: undefined });
        } catch (error) {
          set({ isLoading: false, error: 'Không thể load danh sách sách' });
        }
      },
      async refreshBooks() {
        await get().loadBooks();
      },
      setViewMode(mode) {
        set({ viewMode: mode });
      },
      setSearchQuery(query) {
        set({ searchQuery: query });
      },
      async importBook() {
        try {
          const doc = await DocumentPicker.getDocumentAsync({
            type: '*/*',
            copyToCacheDirectory: true,
            multiple: false,
          });

          if (doc.canceled) {
            return;
          }

          const file = doc.assets?.[0];
          if (!file?.uri) {
            Alert.alert('Lỗi', 'Không chọn được file hợp lệ');
            return;
          }

          const parser = BookParserFactory.createParserFromUri(file.name ?? file.uri);
          const parsedBook = await parser.parse(file.uri);
          const metadata = parsedBook.metadata;
          const format = BookParserFactory.getFormatFromUri(file.name ?? file.uri);

          const renderedContent = TextRenderer.render(
            parsedBook.chapters.map((chapter) => chapter.content).join('\n\n'),
            {
              fontFamily: 'System',
              fontSize: 16,
              lineHeight: 24,
              theme: Theme.DAY,
              margin: 16,
              alignment: TextAlignment.LEFT,
              width: 375,
              height: 667,
            }
          );

          const pagination = PageCalculator.calculate(renderedContent, {
            fontFamily: 'System',
            fontSize: 16,
            lineHeight: 24,
            theme: Theme.DAY,
            margin: 16,
            alignment: TextAlignment.LEFT,
            width: 375,
            height: 667,
          });

          const newBook: Book = {
            id: generateUUID(),
            title: metadata.title || file.name || 'Không tên',
            filename: file.name ?? `book_${Date.now()}`,
            author: metadata.author || 'Không rõ',
            description: metadata.description || '',
            category: '',
            coverImagePath: undefined,
            thumbnailPath: undefined,
            addTime: new Date(),
            favorite: false,
            downloadUrl: file.uri,
            rating: 0,
            groupName: undefined,
            groupBooks: [],
            lastChapter: 0,
            lastPosition: 0,
            totalPages: pagination.totalPages,
            currentPage: 0,
            isbn: metadata.isbn,
            publisher: metadata.publisher,
            publishDate: metadata.publishDate,
            language: metadata.language,
            fileSize: file.size ?? 0,
            fileFormat: format ?? BookFormat.UNKNOWN,
          };

          await db.addBook(newBook);
          await get().loadBooks();

          Alert.alert('Thành công', `Đã import sách "${newBook.title}"`);
        } catch (error) {
          Alert.alert('Lỗi', 'Không thể import sách. Vui lòng thử lại.');
        }
      },
    }),
    {
      name: 'book-store',
      partialize: (state) => ({
        viewMode: state.viewMode,
        searchQuery: state.searchQuery,
      }),
    }
  )
);

