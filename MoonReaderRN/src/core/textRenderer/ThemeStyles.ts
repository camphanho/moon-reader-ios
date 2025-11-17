/**
 * Theme Styles
 * Mapping theme enum to actual colors
 */

import { Theme } from '../../utils/constants';

export interface ThemeStyle {
  backgroundColor: string;
  textColor: string;
  secondaryTextColor: string;
  highlightColor: string;
}

const themeStyles: Record<Theme, ThemeStyle> = {
  [Theme.DAY]: {
    backgroundColor: '#FFFFFF',
    textColor: '#111111',
    secondaryTextColor: '#6B7280',
    highlightColor: '#FFE066',
  },
  [Theme.NIGHT]: {
    backgroundColor: '#1F2933',
    textColor: '#F9FAFB',
    secondaryTextColor: '#94A3B8',
    highlightColor: '#FFC857',
  },
  [Theme.AMOLED]: {
    backgroundColor: '#000000',
    textColor: '#FFFFFF',
    secondaryTextColor: '#9CA3AF',
    highlightColor: '#F9C74F',
  },
  [Theme.SEPIA]: {
    backgroundColor: '#F3E9DC',
    textColor: '#5C4033',
    secondaryTextColor: '#8D6B5D',
    highlightColor: '#FFD166',
  },
};

export function getThemeStyle(theme: Theme): ThemeStyle {
  return themeStyles[theme];
}

