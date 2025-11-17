import { create } from 'zustand';
import { RenderedContent } from '../core/textRenderer/types';

export interface SearchResult {
  paragraphId: string;
  paragraphIndex: number;
  snippet: string;
}

interface SearchState {
  isVisible: boolean;
  query: string;
  results: SearchResult[];
  selectedIndex: number;
  setVisible: (visible: boolean) => void;
  setQuery: (query: string) => void;
  performSearch: (content: RenderedContent | null, query: string) => void;
  nextResult: () => void;
  prevResult: () => void;
  clear: () => void;
}

export const useSearchStore = create<SearchState>((set, get) => ({
  isVisible: false,
  query: '',
  results: [],
  selectedIndex: 0,
  setVisible(visible) {
    set({ isVisible: visible });
    if (!visible) {
      set({ query: '', results: [], selectedIndex: 0 });
    }
  },
  setQuery(query) {
    set({ query });
  },
  performSearch(content, query) {
    if (!content || !query.trim()) {
      set({ results: [], selectedIndex: 0 });
      return;
    }
    const lowerQuery = query.toLowerCase();
    const results: SearchResult[] = [];
    content.paragraphs.forEach((paragraph, index) => {
      const paragraphText = paragraph.spans.map((span) => span.text).join(' ');
      if (paragraphText.toLowerCase().includes(lowerQuery)) {
        const snippetIndex = paragraphText.toLowerCase().indexOf(lowerQuery);
        const start = Math.max(0, snippetIndex - 40);
        const end = Math.min(paragraphText.length, snippetIndex + query.length + 40);
        const snippet = paragraphText.slice(start, end);
        results.push({
          paragraphId: paragraph.id,
          paragraphIndex: index,
          snippet,
        });
      }
    });
    set({ results, selectedIndex: 0 });
  },
  nextResult() {
    const { selectedIndex, results } = get();
    if (results.length === 0) return;
    set({ selectedIndex: (selectedIndex + 1) % results.length });
  },
  prevResult() {
    const { selectedIndex, results } = get();
    if (results.length === 0) return;
    set({ selectedIndex: (selectedIndex - 1 + results.length) % results.length });
  },
  clear() {
    set({ query: '', results: [], selectedIndex: 0 });
  },
}));

