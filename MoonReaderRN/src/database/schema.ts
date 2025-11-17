import { appSchema, tableSchema } from '@nozbe/watermelondb';

export const schema = appSchema({
  version: 1,
  tables: [
    // Books table
    tableSchema({
      name: 'books',
      columns: [
        { name: 'title', type: 'string' },
        { name: 'filename', type: 'string', isIndexed: true },
        { name: 'lowerFilename', type: 'string', isIndexed: true },
        { name: 'author', type: 'string' },
        { name: 'description', type: 'string' },
        { name: 'category', type: 'string' },
        { name: 'thumbFile', type: 'string', isOptional: true },
        { name: 'coverFile', type: 'string', isOptional: true },
        { name: 'addTime', type: 'number' },
        { name: 'favorite', type: 'boolean' },
        { name: 'downloadUrl', type: 'string', isOptional: true },
        { name: 'rate', type: 'number' },
        { name: 'lastChapter', type: 'number' },
        { name: 'lastPosition', type: 'number' },
        { name: 'totalPages', type: 'number' },
        { name: 'currentPage', type: 'number' },
        { name: 'fileSize', type: 'number' },
        { name: 'fileFormat', type: 'string' },
        { name: 'groupName', type: 'string', isOptional: true },
        { name: 'groupBooks', type: 'string' }, // JSON array as string
        { name: 'isbn', type: 'string', isOptional: true },
        { name: 'publisher', type: 'string', isOptional: true },
        { name: 'publishDate', type: 'number', isOptional: true },
        { name: 'language', type: 'string', isOptional: true },
      ],
    }),

    // Bookmarks table (notes in SQLite)
    tableSchema({
      name: 'bookmarks',
      columns: [
        { name: 'bookId', type: 'string', isIndexed: true },
        { name: 'bookFilename', type: 'string', isIndexed: true },
        { name: 'lowerFilename', type: 'string', isIndexed: true },
        { name: 'chapter', type: 'number' },
        { name: 'position', type: 'number' },
        { name: 'splitIndex', type: 'number' },
        { name: 'highlightLength', type: 'number' },
        { name: 'highlightColor', type: 'number' },
        { name: 'time', type: 'number' },
        { name: 'note', type: 'string', isOptional: true },
        { name: 'originalText', type: 'string' },
        { name: 'isUnderline', type: 'boolean' },
        { name: 'isStrikethrough', type: 'boolean' },
      ],
    }),

    // Notes table (separate from bookmarks)
    tableSchema({
      name: 'notes',
      columns: [
        { name: 'bookId', type: 'string', isIndexed: true },
        { name: 'chapter', type: 'number' },
        { name: 'position', type: 'number' },
        { name: 'text', type: 'string' },
        { name: 'createdAt', type: 'number' },
        { name: 'modifiedAt', type: 'number' },
      ],
    }),

    // Statistics table
    tableSchema({
      name: 'statistics',
      columns: [
        { name: 'bookFilename', type: 'string', isIndexed: true },
        { name: 'usedTime', type: 'number' },
        { name: 'readWords', type: 'number' },
        { name: 'dates', type: 'string' }, // JSON array as string
      ],
    }),
  ],
});

