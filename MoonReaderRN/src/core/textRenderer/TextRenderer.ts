/**
 * Text Renderer
 * Convert raw book content into structured paragraphs with styling
 */

import { Theme } from '../../utils/constants';
import { HTMLParser } from './HTMLParser';
import { getThemeStyle } from './ThemeStyles';
import {
  RenderedContent,
  RenderedParagraph,
  TextRenderOptions,
  RenderedSpan,
} from './types';

export class TextRenderer {
  /**
   * Render text content into paragraphs with styling
   */
  static render(content: string, options: TextRenderOptions): RenderedContent {
    const themeStyle = getThemeStyle(options.theme || Theme.DAY);
    const trimmedContent = content.trim();

    let paragraphs: RenderedParagraph[];
    if (containsHTML(trimmedContent)) {
      paragraphs = HTMLParser.parse(trimmedContent);
    } else {
      paragraphs = splitPlainText(trimmedContent);
    }

    const styledParagraphs = applyStyles(paragraphs, options, themeStyle.textColor);

    const plainText = paragraphs
      .map((paragraph) => paragraph.spans.map((span) => span.text).join(' '))
      .join('\n');

    const wordCount = plainText.split(/\s+/).filter(Boolean).length;

    return {
      paragraphs: styledParagraphs,
      plainText,
      wordCount,
    };
  }
}

function containsHTML(text: string): boolean {
  return /<[^>]+>/.test(text);
}

function splitPlainText(text: string): RenderedParagraph[] {
  const paragraphs: RenderedParagraph[] = [];
  const lines = text.split(/\n\n+/);

  lines.forEach((line, index) => {
    const trimmed = line.trim();
    if (!trimmed) return;

    paragraphs.push({
      id: `paragraph_${index}`,
      spans: [
        {
          text: trimmed,
          style: {},
        },
      ],
    });
  });

  if (paragraphs.length === 0) {
    paragraphs.push({
      id: 'paragraph_0',
      spans: [
        {
          text,
          style: {},
        },
      ],
    });
  }

  return paragraphs;
}

function applyStyles(
  paragraphs: RenderedParagraph[],
  options: TextRenderOptions,
  defaultColor: string
): RenderedParagraph[] {
  const { fontFamily, fontSize, lineHeight, letterSpacing = 0 } = options;

  return paragraphs.map((paragraph) => ({
    ...paragraph,
    spans: paragraph.spans.map((span) => applySpanStyle(span, fontFamily, fontSize, lineHeight, letterSpacing, defaultColor)),
  }));
}

function applySpanStyle(
  span: RenderedSpan,
  fontFamily: string,
  fontSize: number,
  lineHeight: number,
  letterSpacing: number,
  color: string
): RenderedSpan {
  return {
    ...span,
    style: {
      ...span.style,
      fontFamily,
      fontSize,
      lineHeight,
      letterSpacing,
      color,
    },
  };
}

