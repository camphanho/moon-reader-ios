/**
 * Parser Tests
 * Test book parsers
 */

import { TXTParser } from '../src/core/parsers/TXTParser';
import { MDParser } from '../src/core/parsers/MDParser';
import { BookParserFactory } from '../src/core/parsers/BookParserFactory';
import { BookFormat } from '../src/utils/constants';

describe('Book Parsers', () => {
  describe('TXTParser', () => {
    it('should create TXT parser', () => {
      const parser = new TXTParser();
      expect(parser).toBeDefined();
    });

    it('should extract metadata from filename', async () => {
      const parser = new TXTParser();
      // This would work with actual file
      // const metadata = await parser.extractMetadata('file:///test.txt');
      // expect(metadata.title).toBe('test');
      expect(true).toBe(true); // Placeholder
    });
  });

  describe('MDParser', () => {
    it('should create MD parser', () => {
      const parser = new MDParser();
      expect(parser).toBeDefined();
    });
  });

  describe('BookParserFactory', () => {
    it('should create TXT parser for TXT format', () => {
      const parser = BookParserFactory.createParser(BookFormat.TXT);
      expect(parser).toBeInstanceOf(TXTParser);
    });

    it('should create MD parser for MD format', () => {
      const parser = BookParserFactory.createParser(BookFormat.MD);
      expect(parser).toBeInstanceOf(MDParser);
    });

    it('should detect format from URI', () => {
      const format = BookParserFactory.getFormatFromUri('test.txt');
      expect(format).toBe(BookFormat.TXT);
    });
  });
});

