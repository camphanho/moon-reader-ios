/**
 * Base Book Parser
 * Base implementation for all book parsers
 */

import * as FileSystem from 'expo-file-system';
import { BookParser, ParsedBook, BookMetadata, Chapter, BookParserError } from './types';

export abstract class BaseBookParser implements BookParser {
  /**
   * Parse book file
   */
  async parse(fileUri: string): Promise<ParsedBook> {
    const metadata = await this.extractMetadata(fileUri);
    const chapters = await this.extractChapters(fileUri);

    return {
      metadata,
      chapters,
      coverImage: metadata.coverImage,
    };
  }

  /**
   * Extract metadata from book file
   * Should be overridden by subclasses
   */
  abstract extractMetadata(fileUri: string): Promise<BookMetadata>;

  /**
   * Extract chapters from book file
   * Should be overridden by subclasses
   */
  abstract extractChapters(fileUri: string): Promise<Chapter[]>;

  /**
   * Read file content as string
   */
  protected async readFileAsString(fileUri: string, encoding: string = 'utf8'): Promise<string> {
    try {
      const content = await FileSystem.readAsStringAsync(fileUri);
      return content;
    } catch (error) {
      throw new Error(BookParserError.FILE_NOT_FOUND);
    }
  }

  /**
   * Get filename from URI
   */
  protected getFilename(fileUri: string): string {
    const parts = fileUri.split('/');
    return parts[parts.length - 1] || 'unknown';
  }

  /**
   * Get filename without extension
   */
  protected getFilenameWithoutExtension(fileUri: string): string {
    const filename = this.getFilename(fileUri);
    const lastDot = filename.lastIndexOf('.');
    return lastDot > 0 ? filename.substring(0, lastDot) : filename;
  }

  /**
   * Get file extension
   */
  protected getFileExtension(fileUri: string): string {
    const filename = this.getFilename(fileUri);
    const lastDot = filename.lastIndexOf('.');
    return lastDot > 0 ? filename.substring(lastDot + 1).toLowerCase() : '';
  }
}

