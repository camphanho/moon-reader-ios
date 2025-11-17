import React, { useEffect, useMemo, useCallback } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  RefreshControl,
  SafeAreaView,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useBookStore } from '../../store/bookStore';
import { useAppSettingsStore } from '../../store/appSettingsStore';
import { Theme } from '../../utils/constants';
import { Book } from '../../models/Book';
import { BookCard } from './BookCard';
import { BookListItem } from './BookListItem';
import { SearchBar } from './SearchBar';
import { ViewModeToggle } from './ViewModeToggle';
import { EmptyState } from './EmptyState';
import LoadingView from '../common/LoadingView';

export default function BookShelfView() {
  const books = useBookStore((state) => state.books);
  const isLoading = useBookStore((state) => state.isLoading);
  const viewMode = useBookStore((state) => state.viewMode);
  const searchQuery = useBookStore((state) => state.searchQuery);
  const loadBooks = useBookStore((state) => state.loadBooks);
  const refreshBooks = useBookStore((state) => state.refreshBooks);
  const setViewMode = useBookStore((state) => state.setViewMode);
  const setSearchQuery = useBookStore((state) => state.setSearchQuery);
  const importBook = useBookStore((state) => state.importBook);
  const appTheme = useAppSettingsStore((state) => state.theme);
  const accentColor = useAppSettingsStore((state) => state.accentColor);

  useEffect(() => {
    loadBooks();
  }, [loadBooks]);

  const filteredBooks = useMemo(() => {
    if (!searchQuery) return books;
    const query = searchQuery.toLowerCase();
    return books.filter(
      (book) =>
        book.title.toLowerCase().includes(query) ||
        (book.author && book.author.toLowerCase().includes(query))
    );
  }, [books, searchQuery]);

  const handleBookPress = useCallback((book: Book) => {
    // TODO: Navigate to book details
  }, []);

  const keyExtractor = useCallback((item: Book) => item.id, []);

  const renderGridItem = useCallback(
    ({ item }: { item: Book }) => <BookCard book={item} onPress={handleBookPress} />,
    [handleBookPress]
  );

  const renderListItem = useCallback(
    ({ item }: { item: Book }) => <BookListItem book={item} onPress={handleBookPress} />,
    [handleBookPress]
  );

  const listEmptyComponent = (
    <EmptyState
      title="Chưa có sách nào"
      description="Nhấn nút Import để thêm sách vào thư viện của bạn."
      actionLabel="Import sách"
      onAction={importBook}
    />
  );

  if (isLoading && books.length === 0) {
    return <LoadingView message="Đang load thư viện..." />;
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: appTheme === Theme.NIGHT || appTheme === Theme.AMOLED ? '#0F172A' : '#F9FAFB' }]}>
      <View style={styles.header}>
        <View>
          <Text style={[styles.heading, appTheme === Theme.NIGHT || appTheme === Theme.AMOLED ? styles.headingDark : null]}>Thư viện</Text>
          <Text style={[styles.subHeading, appTheme === Theme.NIGHT || appTheme === Theme.AMOLED ? styles.subHeadingDark : null]}>{books.length} sách</Text>
        </View>
        <TouchableOpacity style={[styles.importButton, { backgroundColor: accentColor }]} onPress={importBook}>
          <Ionicons name="add" size={20} color="#FFFFFF" />
          <Text style={styles.importText}>Import</Text>
        </TouchableOpacity>
      </View>

      <SearchBar value={searchQuery} onChange={setSearchQuery} />

      <View style={styles.controls}>
        <Text style={styles.controlLabel}>Chế độ hiển thị</Text>
        <ViewModeToggle mode={viewMode} onChange={setViewMode} />
      </View>

      <FlatList
        data={filteredBooks}
        key={viewMode === 'grid' ? 'grid' : 'list'}
        keyExtractor={keyExtractor}
        contentContainerStyle={styles.listContent}
        numColumns={viewMode === 'grid' ? 2 : 1}
        renderItem={viewMode === 'grid' ? renderGridItem : renderListItem}
        columnWrapperStyle={viewMode === 'grid' ? styles.columnWrapper : undefined}
        ListEmptyComponent={listEmptyComponent}
        refreshControl={<RefreshControl refreshing={isLoading} onRefresh={refreshBooks} />}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    paddingHorizontal: 16,
    paddingTop: 16,
    paddingBottom: 12,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  heading: {
    fontSize: 26,
    fontWeight: '700',
    color: '#111827',
  },
  headingDark: {
    color: '#F9FAFB',
  },
  subHeading: {
    fontSize: 14,
    color: '#6B7280',
    marginTop: 4,
  },
  subHeadingDark: {
    color: '#94A3B8',
  },
  importButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#2563EB',
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: 12,
  },
  importText: {
    color: '#FFFFFF',
    fontWeight: '600',
    marginLeft: 6,
  },
  controls: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    marginVertical: 12,
  },
  controlLabel: {
    fontSize: 14,
    color: '#6B7280',
  },
  listContent: {
    paddingBottom: 32,
  },
  columnWrapper: {
    paddingHorizontal: 8,
  },
});

