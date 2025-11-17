/**
 * TXT Parser
 * Simple text file parser
 */

import { BaseBookParser } from './BaseBookParser';
import { BookMetadata, Chapter } from './types';

export class TXTParser extends BaseBookParser {
  /**
   * Extract metadata from TXT file
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
   * Extract chapters from TXT file
   * Splits by double newlines or large paragraphs
   */
  async extractChapters(fileUri: string): Promise<Chapter[]> {
    const content = await this.readFileAsString(fileUri);

    // Split by double newlines (simple implementation)
    const paragraphs = content.split(/\n\n+/).filter((p) => p.trim().length > 0);

    // If too many small paragraphs, group them
    let chapters: Chapter[] = [];
    if (paragraphs.length > 100) {
      // Group paragraphs into chapters (every 10 paragraphs = 1 chapter)
      const paragraphsPerChapter = 10;
      for (let i = 0; i < paragraphs.length; i += paragraphsPerChapter) {
        const chapterParagraphs = paragraphs.slice(i, i + paragraphsPerChapter);
        const chapterContent = chapterParagraphs.join('\n\n');
        chapters.push({
          id: `chapter_${chapters.length}`,
          title: `Chương ${chapters.length + 1}`,
          content: chapterContent,
          order: chapters.length,
          filePath: undefined,
        });
      }
    } else {
      // Use each paragraph as a chapter
      paragraphs.forEach((paragraph, index) => {
        chapters.push({
          id: `chapter_${index}`,
          title: `Chương ${index + 1}`,
          content: paragraph.trim(),
          order: index,
          filePath: undefined,
        });
      });
    }

    // If no chapters found, create one with all content
    if (chapters.length === 0) {
      chapters.push({
        id: 'chapter_0',
        title: 'Nội dung',
        content: content,
        order: 0,
        filePath: undefined,
      });
    }

    return chapters;
  }
}

