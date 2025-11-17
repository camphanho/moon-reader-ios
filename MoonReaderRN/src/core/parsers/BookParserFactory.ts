/**
 * Book Parser Factory
 * Factory to create appropriate parser for book format
 */

import { BookFormat } from '../../models/Book';
import { BookParser } from './types';
import { TXTParser } from './TXTParser';
import { MDParser } from './MDParser';
import { RTFParser } from './RTFParser';
import { PDFParser } from './PDFParser';
import { EPUBParser } from './EPUBParser';

export class BookParserFactory {
  /**
   * Create parser for book format
   */
  static createParser(format: BookFormat): BookParser {
    switch (format) {
      case BookFormat.TXT:
        return new TXTParser();
      case BookFormat.MD:
        return new MDParser();
      case BookFormat.RTF:
        return new RTFParser();
      case BookFormat.PDF:
        return new PDFParser();
      case BookFormat.EPUB:
        return new EPUBParser();
      // TODO: Add more parsers
      // case BookFormat.FB2:
      //   return new FB2Parser();
      // case BookFormat.MOBI:
      //   return new MOBIParser();
      // case BookFormat.DOCX:
      //   return new DOCXParser();
      default:
        // Fallback to TXT parser
        return new TXTParser();
    }
  }

  /**
   * Create parser from file URI
   */
  static createParserFromUri(fileUri: string): BookParser {
    const format = this.getFormatFromUri(fileUri);
    return this.createParser(format);
  }

  /**
   * Get format from file URI
   */
  static getFormatFromUri(fileUri: string): BookFormat {
    const parts = fileUri.split('.');
    const extension = parts.length > 1 ? parts[parts.length - 1].toLowerCase() : '';

    switch (extension) {
      case 'txt':
        return BookFormat.TXT;
      case 'md':
      case 'markdown':
        return BookFormat.MD;
      case 'rtf':
        return BookFormat.RTF;
      case 'pdf':
        return BookFormat.PDF;
      case 'epub':
        return BookFormat.EPUB;
      case 'fb2':
        return BookFormat.FB2;
      case 'mobi':
      case 'azw':
      case 'azw3':
        return BookFormat.MOBI;
      case 'docx':
        return BookFormat.DOCX;
      case 'chm':
        return BookFormat.CHM;
      case 'cbz':
        return BookFormat.CBZ;
      case 'cbr':
        return BookFormat.CBR;
      case 'djvu':
        return BookFormat.DJVU;
      default:
        return BookFormat.UNKNOWN;
    }
  }
}

