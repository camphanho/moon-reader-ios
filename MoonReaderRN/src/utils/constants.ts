/**
 * App Constants
 * Centralized constants for Moon Reader RN
 */

export const APP_NAME = 'Moon Reader';
export const APP_VERSION = '1.0.0';

// Database
export const DB_NAME = 'moonreader.db';

// File Formats
export { BookFormat } from '../models/Book';

// Reading Settings
export const FONT_SIZES = {
  MIN: 12,
  MAX: 32,
  DEFAULT: 16,
};

export const LINE_SPACING = {
  MIN: 0,
  MAX: 20,
  DEFAULT: 4,
};

export const MARGINS = {
  MIN: 10,
  MAX: 50,
  DEFAULT: 20,
};

// Themes
export enum Theme {
  DAY = 'day',
  NIGHT = 'night',
  AMOLED = 'amoled',
  SEPIA = 'sepia',
}

// Highlight Colors
export enum HighlightColor {
  YELLOW = 0,
  GREEN = 1,
  BLUE = 2,
  PINK = 3,
  PURPLE = 4,
  ORANGE = 5,
}

// Text Alignment
export enum TextAlignment {
  LEFT = 'left',
  CENTER = 'center',
  RIGHT = 'right',
  JUSTIFY = 'justify',
}

