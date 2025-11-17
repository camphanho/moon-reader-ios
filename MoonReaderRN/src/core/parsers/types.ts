/**
 * Parser Types
 * Type definitions for book parsers
 */

export interface ParsedBook {
  metadata: BookMetadata;
  chapters: Chapter[];
  coverImage?: string; // Base64 or file path
}

export interface BookMetadata {
  title: string;
  author: string;
  description?: string;
  publisher?: string;
  isbn?: string;
  publishDate?: Date;
  language?: string;
  coverImage?: string; // Base64 or file path
}

export interface Chapter {
  id: string;
  title: string;
  content: string;
  order: number;
  filePath?: string;
}

export interface BookParser {
  parse(fileUri: string): Promise<ParsedBook>;
  extractMetadata(fileUri: string): Promise<BookMetadata>;
  extractChapters(fileUri: string): Promise<Chapter[]>;
}

export enum BookParserError {
  NOT_IMPLEMENTED = 'NOT_IMPLEMENTED',
  INVALID_FORMAT = 'INVALID_FORMAT',
  FILE_NOT_FOUND = 'FILE_NOT_FOUND',
  CORRUPTED_FILE = 'CORRUPTED_FILE',
  UNSUPPORTED_FORMAT = 'UNSUPPORTED_FORMAT',
}

