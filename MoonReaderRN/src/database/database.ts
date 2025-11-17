import { Database } from '@nozbe/watermelondb';
import SQLiteAdapter from '@nozbe/watermelondb/adapters/sqlite';
import { schema } from './schema';
import { Book, BookModel } from '../models/Book';
import { Bookmark, BookmarkModel } from '../models/Bookmark';
import { Note, NoteModel } from '../models/Note';
import { ReadingStatistics, ReadingStatisticsModel } from '../models/ReadingStatistics';

const adapter = new SQLiteAdapter({
  schema,
  // migrations: [], // Sẽ thêm migrations sau
  dbName: 'moonreader',
  // jsi: true, // Enable JSI for better performance (optional)
});

export const database = new Database({
  adapter,
  modelClasses: [BookModel, BookmarkModel, NoteModel, ReadingStatisticsModel],
});

// Database helper functions
export const db = {
  // Books
  async addBook(book: Book): Promise<void> {
    await database.write(async () => {
      await database.collections.get<BookModel>('books').create((record) => {
        record._raw.id = book.id;
        (record as any).title = book.title;
        (record as any).filename = book.filename;
        (record as any).lowerFilename = book.filename.toLowerCase();
        (record as any).author = book.author;
        (record as any).description = book.description;
        (record as any).category = book.category;
        (record as any).thumbFile = book.thumbnailPath;
        (record as any).coverFile = book.coverImagePath;
        (record as any).addTime = book.addTime.getTime();
        (record as any).favorite = book.favorite;
        (record as any).downloadUrl = book.downloadUrl;
        (record as any).rate = book.rating;
        (record as any).lastChapter = book.lastChapter;
        (record as any).lastPosition = book.lastPosition;
        (record as any).totalPages = book.totalPages;
        (record as any).currentPage = book.currentPage;
        (record as any).fileSize = book.fileSize;
        (record as any).fileFormat = book.fileFormat;
        (record as any).groupName = book.groupName;
        (record as any).groupBooks = JSON.stringify(book.groupBooks);
        (record as any).isbn = book.isbn;
        (record as any).publisher = book.publisher;
        (record as any).publishDate = book.publishDate?.getTime();
        (record as any).language = book.language;
      });
    });
  },

  async getAllBooks(): Promise<Book[]> {
    const booksCollection = database.collections.get<BookModel>('books');
    const books = await booksCollection.query().fetch();
    return books.map((record) => ({
      id: record.id,
      title: (record as any).title,
      filename: (record as any).filename,
      author: (record as any).author,
      description: (record as any).description,
      category: (record as any).category,
      thumbnailPath: (record as any).thumbFile,
      coverImagePath: (record as any).coverFile,
      addTime: new Date((record as any).addTime),
      favorite: (record as any).favorite,
      downloadUrl: (record as any).downloadUrl,
      rating: (record as any).rate,
      lastChapter: (record as any).lastChapter,
      lastPosition: (record as any).lastPosition,
      totalPages: (record as any).totalPages,
      currentPage: (record as any).currentPage,
      fileSize: (record as any).fileSize,
      fileFormat: (record as any).fileFormat as any,
      groupName: (record as any).groupName,
      groupBooks: JSON.parse((record as any).groupBooks || '[]'),
      isbn: (record as any).isbn,
      publisher: (record as any).publisher,
      publishDate: (record as any).publishDate ? new Date((record as any).publishDate) : undefined,
      language: (record as any).language,
    }));
  },

  async deleteBook(bookId: string): Promise<void> {
    await database.write(async () => {
      const book = await database.collections.get<BookModel>('books').find(bookId);
      await book.destroyPermanently();
    });
  },

  // Bookmarks
  async addBookmark(bookmark: Bookmark): Promise<void> {
    await database.write(async () => {
      await database.collections.get<BookmarkModel>('bookmarks').create((record) => {
        record._raw.id = bookmark.id;
        (record as any).bookId = bookmark.bookId;
        (record as any).bookFilename = bookmark.bookFilename;
        (record as any).lowerFilename = bookmark.bookFilename.toLowerCase();
        (record as any).chapter = bookmark.chapter;
        (record as any).position = bookmark.position;
        (record as any).splitIndex = bookmark.splitIndex;
        (record as any).highlightLength = bookmark.highlightLength;
        (record as any).highlightColor = bookmark.highlightColor;
        (record as any).time = bookmark.time.getTime();
        (record as any).note = bookmark.note;
        (record as any).originalText = bookmark.originalText;
        (record as any).isUnderline = bookmark.isUnderline;
        (record as any).isStrikethrough = bookmark.isStrikethrough;
      });
    });
  },

  async getBookmarksByBook(bookId: string): Promise<Bookmark[]> {
    const bookmarksCollection = database.collections.get<BookmarkModel>('bookmarks');
    const bookmarks = await bookmarksCollection.query().fetch();
    return bookmarks
      .filter((record) => (record as any).bookId === bookId)
      .map((record) => ({
        id: record.id,
        bookId: (record as any).bookId,
        bookFilename: (record as any).bookFilename,
        chapter: (record as any).chapter,
        position: (record as any).position,
        splitIndex: (record as any).splitIndex,
        highlightLength: (record as any).highlightLength,
        highlightColor: (record as any).highlightColor as any,
        time: new Date((record as any).time),
        note: (record as any).note,
        originalText: (record as any).originalText,
        isUnderline: (record as any).isUnderline,
        isStrikethrough: (record as any).isStrikethrough,
      }));
  },

  async deleteBookmark(bookmarkId: string): Promise<void> {
    await database.write(async () => {
      const bookmark = await database.collections.get<BookmarkModel>('bookmarks').find(bookmarkId);
      await bookmark.destroyPermanently();
    });
  },

  // Statistics
  async addStatistics(statistics: ReadingStatistics): Promise<void> {
    await database.write(async () => {
      await database.collections.get<ReadingStatisticsModel>('statistics').create((record) => {
        record._raw.id = statistics.id;
        (record as any).bookFilename = statistics.bookFilename;
        (record as any).usedTime = statistics.usedTime;
        (record as any).readWords = statistics.readWords;
        (record as any).dates = JSON.stringify(statistics.dates.map((d) => d.getTime()));
      });
    });
  },

  async getStatisticsByBook(bookFilename: string): Promise<ReadingStatistics | null> {
    const statsCollection = database.collections.get<ReadingStatisticsModel>('statistics');
    const stats = await statsCollection.query().fetch();
    const stat = stats.find((record) => (record as any).bookFilename === bookFilename);
    if (!stat) return null;

    return {
      id: stat.id,
      bookFilename: (stat as any).bookFilename,
      usedTime: (stat as any).usedTime,
      readWords: (stat as any).readWords,
      dates: JSON.parse((stat as any).dates || '[]').map((t: number) => new Date(t)),
    };
  },
};

