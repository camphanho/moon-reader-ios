/**
 * Text Renderer Types
 * Shared type definitions for rendering text content
 */

import { Theme, TextAlignment } from '../../utils/constants';

export interface TextRenderOptions {
  fontFamily: string;
  fontSize: number;
  lineHeight: number;
  theme: Theme;
  margin: number;
  alignment: TextAlignment;
  width: number; // content width in px
  height: number; // content height in px
  letterSpacing?: number;
  paragraphSpacing?: number;
}

export interface TextSpanStyle {
  bold?: boolean;
  italic?: boolean;
  underline?: boolean;
  highlight?: boolean;
  highlightColor?: string;
  color?: string;
  fontFamily?: string;
  fontSize?: number;
  lineHeight?: number;
  letterSpacing?: number;
}

export interface RenderedSpan {
  text: string;
  style: TextSpanStyle;
}

export interface RenderedParagraph {
  id: string;
  spans: RenderedSpan[];
}

export interface RenderedContent {
  paragraphs: RenderedParagraph[];
  plainText: string;
  wordCount: number;
}

export interface RenderedPage {
  index: number;
  paragraphs: RenderedParagraph[];
  startOffset: number;
  endOffset: number;
}

export interface PageCalculationResult {
  pages: RenderedPage[];
  totalPages: number;
  wordsPerPage: number[];
}

