/**
 * Markdown Parser
 * Parse Markdown files and split by headers
 */

import { BaseBookParser } from './BaseBookParser';
import { BookMetadata, Chapter } from './types';

export class MDParser extends BaseBookParser {
  /**
   * Extract metadata from MD file
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
   * Extract chapters from MD file
   * Splits by headers (# ## ###)
   */
  async extractChapters(fileUri: string): Promise<Chapter[]> {
    const content = await this.readFileAsString(fileUri);
    const lines = content.split('\n');

    const chapters: Chapter[] = [];
    let currentChapter: { title: string; content: string[] } | null = null;

    for (const line of lines) {
      // Check for header (starts with #)
      if (line.trim().match(/^#{1,3}\s+/)) {
        // Save previous chapter
        if (currentChapter) {
          const chapterContent = currentChapter.content.join('\n').trim();
          if (chapterContent.length > 0) {
            chapters.push({
              id: `chapter_${chapters.length}`,
              title: currentChapter.title,
              content: chapterContent,
              order: chapters.length,
              filePath: undefined,
            });
          }
        }

        // Start new chapter
        const title = line.replace(/^#{1,3}\s+/, '').trim();
        currentChapter = { title, content: [] };
      } else if (currentChapter) {
        // Add line to current chapter
        currentChapter.content.push(line);
      }
    }

    // Add last chapter
    if (currentChapter) {
      const chapterContent = currentChapter.content.join('\n').trim();
      if (chapterContent.length > 0) {
        chapters.push({
          id: `chapter_${chapters.length}`,
          title: currentChapter.title,
          content: chapterContent,
          order: chapters.length,
          filePath: undefined,
        });
      }
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

