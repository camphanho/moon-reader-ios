import { Model } from '@nozbe/watermelondb';
import { field, text, date, readonly } from '@nozbe/watermelondb/decorators';

// TypeScript interface (sẽ dùng cho app logic)
export interface Book {
  id: string;
  title: string;
  filename: string;
  author: string;
  description: string;
  category: string;
  coverImagePath?: string;
  thumbnailPath?: string;
  addTime: Date;
  favorite: boolean;
  downloadUrl?: string;
  rating: number;
  groupName?: string;
  groupBooks: string[];
  lastChapter: number;
  lastPosition: number;
  totalPages: number;
  currentPage: number;
  isbn?: string;
  publisher?: string;
  publishDate?: Date;
  language?: string;
  fileSize: number;
  fileFormat: BookFormat;
}

export enum BookFormat {
  EPUB = 'epub',
  FB2 = 'fb2',
  MOBI = 'mobi',
  PDF = 'pdf',
  TXT = 'txt',
  DOCX = 'docx',
  RTF = 'rtf',
  CHM = 'chm',
  MD = 'md',
  CBZ = 'cbz',
  CBR = 'cbr',
  DJVU = 'djvu',
  UNKNOWN = 'unknown',
}

// WatermelonDB Model class
export class BookModel extends Model {
  static table = 'books';

  @text('title') title!: string;
  @text('filename') filename!: string;
  @text('lowerFilename') lowerFilename!: string;
  @text('author') author!: string;
  @text('description') description!: string;
  @text('category') category!: string;
  @text('thumbFile') thumbFile?: string;
  @text('coverFile') coverFile?: string;
  @date('addTime') addTime!: Date;
  @field('favorite') favorite!: boolean;
  @text('downloadUrl') downloadUrl?: string;
  @field('rate') rate!: number;
  @field('lastChapter') lastChapter!: number;
  @field('lastPosition') lastPosition!: number;
  @field('totalPages') totalPages!: number;
  @field('currentPage') currentPage!: number;
  @field('fileSize') fileSize!: number;
  @text('fileFormat') fileFormat!: string;
  @text('groupName') groupName?: string;
  @text('groupBooks') groupBooks!: string; // JSON string
  @text('isbn') isbn?: string;
  @text('publisher') publisher?: string;
  @field('publishDate') publishDate?: number;
  @text('language') language?: string;

  // Helper methods
  get progress(): number {
    if (this.totalPages === 0) return 0;
    return Math.round((this.currentPage / this.totalPages) * 100);
  }

  get groupBooksArray(): string[] {
    try {
      return JSON.parse(this.groupBooks || '[]');
    } catch {
      return [];
    }
  }
}

