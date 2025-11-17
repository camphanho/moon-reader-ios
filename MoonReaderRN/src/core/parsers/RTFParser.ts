/**
 * RTF Parser
 * Parse RTF files (simplified - extracts text content)
 * Note: Full RTF parsing requires a library, this is a basic implementation
 */

import { BaseBookParser } from './BaseBookParser';
import { BookMetadata, Chapter } from './types';

export class RTFParser extends BaseBookParser {
  /**
   * Extract metadata from RTF file
   */
  async extractMetadata(fileUri: string): Promise<BookMetadata> {
    const title = this.getFilenameWithoutExtension(fileUri);

    return {
      title,
      author: '',
      description: undefined,
      publisher: undefined,
      isbn: undefined,
      publishDate: undefined,
      language: undefined,
      coverImage: undefined,
    };
  }

  /**
   * Extract chapters from RTF file
   * Simplified: extracts text content, removes RTF control codes
   */
  async extractChapters(fileUri: string): Promise<Chapter[]> {
    const content = await this.readFileAsString(fileUri);

    // Basic RTF text extraction - remove RTF control codes
    // This is simplified - full RTF parsing would need a library
    let textContent = content
      // Remove RTF header
      .replace(/\\rtf[0-9]?\\ansi[^\}]*\{/g, '')
      // Remove control words
      .replace(/\\[a-z]+\d*\s?/g, '')
      // Remove control symbols
      .replace(/\\[^a-z\s]/g, '')
      // Remove braces (but keep content)
      .replace(/\{|\}/g, '')
      // Clean up multiple spaces
      .replace(/\s+/g, ' ')
      .trim();

    // If extraction failed, try to get readable text
    if (textContent.length < 100) {
      // Fallback: try to extract text between braces
      const matches = content.match(/\{([^}]+)\}/g);
      if (matches) {
        textContent = matches
          .map((m) => m.replace(/\{|\}/g, ''))
          .filter((t) => !t.startsWith('\\'))
          .join(' ');
      }
    }

    // Split into paragraphs
    const paragraphs = textContent.split(/\n\n+/).filter((p) => p.trim().length > 0);

    const chapters: Chapter[] = [];
    if (paragraphs.length > 20) {
      // Group paragraphs into chapters
      const paragraphsPerChapter = 10;
      for (let i = 0; i < paragraphs.length; i += paragraphsPerChapter) {
        const chapterParagraphs = paragraphs.slice(i, i + paragraphsPerChapter);
        chapters.push({
          id: `chapter_${chapters.length}`,
          title: `Chương ${chapters.length + 1}`,
          content: chapterParagraphs.join('\n\n'),
          order: chapters.length,
          filePath: undefined,
        });
      }
    } else {
      // Single chapter
      chapters.push({
        id: 'chapter_0',
        title: 'Nội dung',
        content: textContent,
        order: 0,
        filePath: undefined,
      });
    }

    return chapters;
  }
}

