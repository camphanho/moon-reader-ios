/**
 * Page Calculator
 * Calculate pagination based on rendered paragraphs and layout options
 */

import {
  RenderedContent,
  RenderedPage,
  TextRenderOptions,
  PageCalculationResult,
} from './types';

export class PageCalculator {
  static calculate(content: RenderedContent, options: TextRenderOptions): PageCalculationResult {
    const charsPerLine = estimateCharsPerLine(options);
    const linesPerPage = estimateLinesPerPage(options);
    const charsPerPage = charsPerLine * linesPerPage;

    const text = content.plainText;
    const pages: RenderedPage[] = [];
    const wordsPerPage: number[] = [];

    let start = 0;
    let pageIndex = 0;

    while (start < text.length) {
      const end = Math.min(start + charsPerPage, text.length);
      const pageText = text.slice(start, end);
      const wordCount = pageText.split(/\s+/).filter(Boolean).length;

      pages.push({
        index: pageIndex,
        paragraphs: extractParagraphsForRange(content, start, end),
        startOffset: start,
        endOffset: end,
      });

      wordsPerPage.push(wordCount);

      start = end;
      pageIndex += 1;
    }

    return {
      pages,
      totalPages: pages.length,
      wordsPerPage,
    };
  }
}

function estimateCharsPerLine(options: TextRenderOptions): number {
  const margin = options.margin * 2;
  const width = Math.max(options.width - margin, 100);
  const averageCharWidth = options.fontSize * 0.6; // approx
  return Math.max(Math.floor(width / averageCharWidth), 20);
}

function estimateLinesPerPage(options: TextRenderOptions): number {
  const margin = options.margin * 2;
  const height = Math.max(options.height - margin, 200);
  const lineHeightPx = options.lineHeight || options.fontSize * 1.4;
  return Math.max(Math.floor(height / lineHeightPx), 10);
}

function extractParagraphsForRange(content: RenderedContent, start: number, end: number) {
  const text = content.plainText;
  const pageText = text.slice(start, end);
  const paragraphTexts = pageText.split('\n');

  const paragraphs: any[] = [];
  paragraphTexts.forEach((paragraphText, index) => {
    const trimmed = paragraphText.trim();
    if (!trimmed) return;

    paragraphs.push({
      id: `page_paragraph_${index}`,
      spans: [
        {
          text: trimmed,
          style: {},
        },
      ],
    });
  });

  return paragraphs;
}

