/**
 * Text Renderer Tests
 */

import { TextRenderer } from '../src/core/textRenderer/TextRenderer';
import { PageCalculator } from '../src/core/textRenderer/PageCalculator';
import { Theme, TextAlignment } from '../src/utils/constants';

const baseOptions = {
  fontFamily: 'System',
  fontSize: 16,
  lineHeight: 24,
  theme: Theme.DAY,
  margin: 16,
  alignment: TextAlignment.LEFT,
  width: 375,
  height: 667,
};

describe('TextRenderer', () => {
  it('should render plain text into paragraphs', () => {
    const content = 'Paragraph 1\\n\\nParagraph 2';
    const result = TextRenderer.render(content, baseOptions);
    expect(result.paragraphs.length).toBe(2);
  });

  it('should detect HTML content', () => {
    const content = '<p>Hello <strong>World</strong></p>';
    const result = TextRenderer.render(content, baseOptions);
    expect(result.paragraphs.length).toBeGreaterThan(0);
    expect(result.wordCount).toBeGreaterThan(0);
  });
});

describe('PageCalculator', () => {
  it('should calculate pages from rendered content', () => {
    const content = TextRenderer.render('Lorem ipsum '.repeat(200), baseOptions);
    const result = PageCalculator.calculate(content, baseOptions);
    expect(result.totalPages).toBeGreaterThan(0);
  });
});

