import React, { useEffect, useState, useMemo } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, SafeAreaView } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useReaderStore } from '../../store/readerStore';
import { useBookStore } from '../../store/bookStore';
import { useReadingProgress } from '../../hooks/useReadingProgress';
import LoadingView from '../common/LoadingView';
import ReaderSettingsView from './ReaderSettingsView';
import HighlightMenuView from './HighlightMenuView';
import BookmarkListView from './BookmarkListView';
import SearchModal from './SearchModal';
import TTSControlView from './TTSControlView';
import PDFReaderView from './PDFReaderView';
import { Theme } from '../../utils/constants';
import { useBookmarkStore } from '../../store/bookmarkStore';
import { HighlightColor } from '../../models/Bookmark';
import { useSearchStore } from '../../store/searchStore';
import { useStatisticsStore } from '../../store/statisticsStore';
import { useTTSStore } from '../../store/ttsStore';

export default function ReadingView() {
  const books = useBookStore((state) => state.books);
  const loadBook = useReaderStore((state) => state.loadBook);
  const currentBook = useReaderStore((state) => state.currentBook);
  const isLoading = useReaderStore((state) => state.isLoading);
  const pagination = useReaderStore((state) => state.pagination);
  const renderedContent = useReaderStore((state) => state.renderedContent);
  const theme = useReaderStore((state) => state.theme);

  const { currentPage, totalPages, progress, goToNextPage, goToPreviousPage } = useReadingProgress();
  const [settingsVisible, setSettingsVisible] = useState(false);
  const [bookmarkListVisible, setBookmarkListVisible] = useState(false);
  const bookmarks = useBookmarkStore((state) => state.bookmarks);
  const loadBookmarks = useBookmarkStore((state) => state.loadBookmarks);
  const setSelection = useBookmarkStore((state) => state.setSelection);
  const addBookmark = useBookmarkStore((state) => state.addBookmark);
  const deleteBookmark = useBookmarkStore((state) => state.deleteBookmark);
  const setColor = useBookmarkStore((state) => state.setColor);
  const selectedColor = useBookmarkStore((state) => state.selectedColor);
  const isMenuVisible = useBookmarkStore((state) => state.isMenuVisible);
  const setMenuVisible = useBookmarkStore((state) => state.setMenuVisible);
  const searchVisible = useSearchStore((state) => state.isVisible);
  const setSearchVisible = useSearchStore((state) => state.setVisible);
  const statisticsStore = useStatisticsStore();
  const ttsStore = useTTSStore();

  useEffect(() => {
    if (!currentBook && books.length > 0) {
      loadBook(books[0]); // Load first book as default
    }
  }, [books, currentBook, loadBook]);

  useEffect(() => {
    if (currentBook) {
      loadBookmarks(currentBook);
    }
  }, [currentBook, loadBookmarks]);

  useEffect(() => {
    if (currentBook) {
      statisticsStore.loadStatistics(currentBook);
    }
  }, [currentBook, statisticsStore]);

  useEffect(() => {
    return () => {
      logReadingSession();
    };
  }, []);

  const logReadingSession = () => {
    const state = useReaderStore.getState();
    if (!state.currentBook || state.sessionStart === null) return;
    const durationSeconds = (Date.now() - state.sessionStart) / 1000;
    const pagination = state.pagination;
    const wordsPerPage =
      pagination && pagination.totalPages > 0 ? Math.round((state.renderedContent?.wordCount || 0) / pagination.totalPages) : 250;
    useStatisticsStore.getState().logReadingSession(state.currentBook, durationSeconds, wordsPerPage);
  };

  if (!currentBook) {
    return (
      <View style={styles.emptyContainer}>
        <Text style={styles.emptyText}>Chọn một cuốn sách từ thư viện để đọc</Text>
      </View>
    );
  }

  const isPDF = currentBook.fileFormat === 'pdf';

  if (isLoading || (!isPDF && (!renderedContent || !pagination))) {
    return <LoadingView message="Đang load nội dung sách..." />;
  }

  if (isPDF && currentBook.downloadUrl) {
    return (
      <SafeAreaView style={styles.container}>
        <PDFReaderView uri={currentBook.downloadUrl} />
      </SafeAreaView>
    );
  }

  const page = pagination!.pages[currentPage];
  const pageText = useMemo(
    () => page.paragraphs.map((paragraph) => paragraph.spans.map((span) => span.text).join(' ')).join(' '),
    [page]
  );

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: THEME_STYLES[theme].backgroundColor }]}>
      <View style={styles.header}>
        <View style={styles.headerLeft}>
          <Text style={[styles.title, { color: THEME_STYLES[theme].textColor }]}>{currentBook.title}</Text>
          <Text style={[styles.subtitle, { color: THEME_STYLES[theme].secondaryTextColor }]}>{currentBook.author || 'Tác giả không rõ'}</Text>
        </View>
        <View style={styles.headerActions}>
          <TouchableOpacity
            style={styles.iconButton}
            onPress={() => {
              setSearchVisible(true);
            }}
          >
            <Ionicons name="search-outline" size={18} color={THEME_STYLES[theme].textColor} />
          </TouchableOpacity>
          <TouchableOpacity style={styles.iconButton} onPress={() => setBookmarkListVisible(true)}>
            <Ionicons name="bookmarks-outline" size={18} color={THEME_STYLES[theme].textColor} />
          </TouchableOpacity>
          <TouchableOpacity style={styles.iconButton} onPress={() => setSettingsVisible(true)}>
            <Ionicons name="settings-outline" size={18} color={THEME_STYLES[theme].textColor} />
          </TouchableOpacity>
        </View>
      </View>

      <ScrollView contentContainerStyle={[styles.pageContainer, { marginHorizontal: 16 }]} showsVerticalScrollIndicator={false}>
        {page?.paragraphs.map((paragraph, index) => {
          const matchingBookmark = bookmarks.find((bookmark) => bookmark.splitIndex === index);
          const highlightColor = matchingBookmark ? getHighlightHex(matchingBookmark.highlightColor) : undefined;

          return (
            <Text
              key={paragraph.id}
              style={[
                styles.paragraph,
                {
                  color: THEME_STYLES[theme].textColor,
                  backgroundColor: highlightColor,
                  padding: matchingBookmark ? 8 : 0,
                  borderRadius: matchingBookmark ? 10 : 0,
                },
              ]}
              onLongPress={() => {
                const paragraphText = paragraph.spans.map((span) => span.text).join(' ');
                setSelection({ paragraphId: paragraph.id, text: paragraphText });
                setMenuVisible(true);
              }}
            >
              {paragraph.spans.map((span, spanIndex) => (
                <Text
                  key={spanIndex}
                  style={{
                    fontWeight: span.style.bold ? '700' : '400',
                    fontStyle: span.style.italic ? 'italic' : 'normal',
                    textDecorationLine: span.style.underline ? 'underline' : 'none',
                    color: span.style.color || THEME_STYLES[theme].textColor,
                  }}
                >
                  {span.text}
                </Text>
              ))}
            </Text>
          );
        })}
      </ScrollView>

      <TTSControlView text={pageText} />

      <View style={styles.footer}>
        <TouchableOpacity onPress={goToPreviousPage} style={styles.navButton}>
          <Ionicons name="chevron-back" size={20} color="#FFFFFF" />
        </TouchableOpacity>

        <View style={styles.progressContainer}>
          <View style={styles.progressBar}>
            <View style={[styles.progressIndicator, { width: `${progress}%` }]} />
          </View>
          <Text style={styles.progressText}>
            {currentPage + 1}/{totalPages} trang
          </Text>
        </View>

        <TouchableOpacity onPress={goToNextPage} style={styles.navButton}>
          <Ionicons name="chevron-forward" size={20} color="#FFFFFF" />
        </TouchableOpacity>
      </View>

      <ReaderSettingsView visible={settingsVisible} onClose={() => setSettingsVisible(false)} />
      <HighlightMenuView
        visible={isMenuVisible}
        onClose={() => setMenuVisible(false)}
        onSelectColor={setColor}
        onAddBookmark={async () => {
          if (!currentBook || !pagination) return;
          const selection = useBookmarkStore.getState().currentSelection;
          if (!selection) return;
          const paragraphIndex = parseInt(selection.paragraphId.split('_').pop() || '0', 10);
          const currentPagination = useReaderStore.getState().pagination;
          if (!currentPagination) return;
          await addBookmark({
            bookId: currentBook.id,
            bookFilename: currentBook.filename,
            chapter: 0,
            position: paragraphIndex / Math.max(currentPagination.totalPages, 1),
            splitIndex: paragraphIndex,
            highlightLength: selection.text.length,
            highlightColor: selectedColor,
            note: undefined,
            originalText: selection.text,
            isUnderline: false,
            isStrikethrough: false,
          });
        }}
      />
      <BookmarkListView
        visible={bookmarkListVisible}
        bookmarks={bookmarks}
        onClose={() => setBookmarkListVisible(false)}
        onSelect={(bookmark) => {
          const currentPagination = useReaderStore.getState().pagination;
          if (!currentPagination) return;
          const targetPage = Math.min(Math.floor(bookmark.position * (currentPagination.totalPages || 1)), currentPagination.totalPages - 1);
          useReaderStore.getState().setPage(targetPage);
          setBookmarkListVisible(false);
        }}
        onDelete={(bookmark) => deleteBookmark(bookmark.id)}
      />
      <SearchModal
        visible={searchVisible}
        onClose={() => setSearchVisible(false)}
        onSelectResult={(paragraphIndex) => {
          const currentPagination = useReaderStore.getState().pagination;
          if (!renderedContent || !currentPagination) return;
          const paragraphsPerPage = Math.max(1, Math.floor(renderedContent.paragraphs.length / Math.max(1, currentPagination.totalPages)));
          const targetPage = Math.min(Math.floor(paragraphIndex / paragraphsPerPage), currentPagination.totalPages - 1);
          useReaderStore.getState().setPage(targetPage);
        }}
      />
    </SafeAreaView>
  );
}

const THEME_STYLES = {
  [Theme.DAY]: { backgroundColor: '#FFFFFF', textColor: '#111827', secondaryTextColor: '#6B7280' },
  [Theme.NIGHT]: { backgroundColor: '#1F2933', textColor: '#F9FAFB', secondaryTextColor: '#94A3B8' },
  [Theme.AMOLED]: { backgroundColor: '#000000', textColor: '#FFFFFF', secondaryTextColor: '#9CA3AF' },
  [Theme.SEPIA]: { backgroundColor: '#F3E9DC', textColor: '#5C4033', secondaryTextColor: '#8D6B5D' },
};

function getHighlightHex(color: HighlightColor): string {
  switch (color) {
    case HighlightColor.GREEN:
      return '#D1FAE5';
    case HighlightColor.BLUE:
      return '#DBEAFE';
    case HighlightColor.PINK:
      return '#FCE7F3';
    case HighlightColor.PURPLE:
      return '#EDE9FE';
    case HighlightColor.ORANGE:
      return '#FEF3C7';
    case HighlightColor.YELLOW:
    default:
      return '#FEF9C3';
  }
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: { paddingHorizontal: 16, paddingTop: 12, paddingBottom: 4, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  headerLeft: { flex: 1, paddingRight: 12 },
  headerActions: { flexDirection: 'row', alignItems: 'center' },
  iconButton: { padding: 6 },
  title: { fontSize: 20, fontWeight: '600' },
  subtitle: { fontSize: 14, marginTop: 4 },
  pageContainer: { paddingBottom: 80 },
  paragraph: { fontSize: 16, lineHeight: 26, marginBottom: 12 },
  footer: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16, backgroundColor: '#111827' },
  navButton: { width: 40, height: 40, borderRadius: 20, backgroundColor: '#2563EB', alignItems: 'center', justifyContent: 'center' },
  progressContainer: { flex: 1, marginHorizontal: 12 },
  progressBar: { height: 4, backgroundColor: '#4B5563', borderRadius: 2 },
  progressIndicator: { height: '100%', backgroundColor: '#60A5FA', borderRadius: 2 },
  progressText: { marginTop: 8, color: '#E5E7EB', textAlign: 'center' },
  settingsButton: { padding: 8 },
  emptyContainer: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 24 },
  emptyText: { color: '#6B7280', fontSize: 16, textAlign: 'center' },
});

