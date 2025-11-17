/**
 * HTML Parser
 * Lightweight parser to convert basic HTML to structured spans
 */

import { RenderedParagraph, RenderedSpan, TextSpanStyle } from './types';

const BLOCK_TAGS = ['p', 'div', 'br', 'hr', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'];
const INLINE_TAGS = ['b', 'strong', 'i', 'em', 'u', 'span', 'mark'];

interface ParseContext {
  paragraphs: RenderedParagraph[];
  currentParagraph: RenderedParagraph | null;
  currentStyle: TextSpanStyle;
}

export class HTMLParser {
  /**
   * Parse HTML string into paragraphs with styled spans
   */
  static parse(html: string): RenderedParagraph[] {
    const sanitized = html.replace(/\r/g, '');
    const tokens = tokenizeHTML(sanitized);

    const ctx: ParseContext = {
      paragraphs: [],
      currentParagraph: createParagraph(),
      currentStyle: {},
    };

    tokens.forEach((token) => {
      if (token.type === 'text') {
        appendText(ctx, decodeHTMLEntities(token.value));
      } else if (token.type === 'tag') {
        handleTag(token, ctx);
      }
    });

    finalizeParagraph(ctx);

    if (ctx.paragraphs.length === 0) {
      return [
        {
          id: 'paragraph_0',
          spans: [
            {
              text: decodeHTMLEntities(html),
              style: {},
            },
          ],
        },
      ];
    }

    return ctx.paragraphs;
  }
}

function tokenizeHTML(html: string) {
  const tokens: Array<{ type: 'text' | 'tag'; value: string }> = [];
  const regex = /(<[^>]+>)|([^<]+)/g;
  let match;

  while ((match = regex.exec(html)) !== null) {
    if (match[1]) {
      tokens.push({ type: 'tag', value: match[1] });
    } else if (match[2]) {
      tokens.push({ type: 'text', value: match[2] });
    }
  }

  return tokens;
}

function handleTag(token: { value: string }, ctx: ParseContext) {
  const tagMatch = token.value.match(/^<\/?([a-zA-Z0-9]+)([^>]*)>/);
  if (!tagMatch) {
    return;
  }

  const [, tagNameRaw] = tagMatch;
  const tagName = tagNameRaw.toLowerCase();
  const isClosing = token.value.startsWith('</');

  if (BLOCK_TAGS.includes(tagName)) {
    if (isClosing) {
      finalizeParagraph(ctx);
    } else if (tagName === 'br' || tagName === 'hr') {
      finalizeParagraph(ctx);
    } else {
      finalizeParagraph(ctx);
    }
    return;
  }

  if (INLINE_TAGS.includes(tagName)) {
    if (!isClosing) {
      switch (tagName) {
        case 'b':
        case 'strong':
          ctx.currentStyle.bold = true;
          break;
        case 'i':
        case 'em':
          ctx.currentStyle.italic = true;
          break;
        case 'u':
          ctx.currentStyle.underline = true;
          break;
        case 'mark':
          ctx.currentStyle.highlight = true;
          ctx.currentStyle.highlightColor = '#FFE066';
          break;
        default:
          break;
      }
    } else {
      switch (tagName) {
        case 'b':
        case 'strong':
          ctx.currentStyle.bold = false;
          break;
        case 'i':
        case 'em':
          ctx.currentStyle.italic = false;
          break;
        case 'u':
          ctx.currentStyle.underline = false;
          break;
        case 'mark':
          ctx.currentStyle.highlight = false;
          ctx.currentStyle.highlightColor = undefined;
          break;
        default:
          break;
      }
    }
  }
}

function appendText(ctx: ParseContext, text: string) {
  if (!ctx.currentParagraph) {
    ctx.currentParagraph = createParagraph();
  }

  const trimmed = text.replace(/\s+/g, ' ');
  if (!trimmed.trim()) {
    return;
  }

  const span: RenderedSpan = {
    text: trimmed,
    style: { ...ctx.currentStyle },
  };

  ctx.currentParagraph.spans.push(span);
}

function finalizeParagraph(ctx: ParseContext) {
  if (ctx.currentParagraph && ctx.currentParagraph.spans.length > 0) {
    ctx.paragraphs.push(ctx.currentParagraph);
  }
  ctx.currentParagraph = createParagraph(ctx.paragraphs.length);
}

function createParagraph(index: number = 0): RenderedParagraph {
  return {
    id: `paragraph_${index}`,
    spans: [],
  };
}

function decodeHTMLEntities(text: string): string {
  const entities: Record<string, string> = {
    '&nbsp;': ' ',
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
    '&quot;': '"',
    '&#39;': "'",
  };

  return text.replace(/&[a-z]+;|&#\d+;/gi, (entity) => {
    if (entity.startsWith('&#')) {
      const code = parseInt(entity.slice(2, -1), 10);
      return String.fromCharCode(code);
    }
    return entities[entity] || entity;
  });
}

