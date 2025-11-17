import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image } from 'react-native';
import { Book } from '../../models/Book';
import { calculateProgress, formatDate } from '../../utils/helpers';

interface BookListItemProps {
  book: Book;
  onPress?: (book: Book) => void;
  onLongPress?: (book: Book) => void;
}

export const BookListItem: React.FC<BookListItemProps> = React.memo(({ book, onPress, onLongPress }) => (
  <TouchableOpacity style={styles.container} onPress={() => onPress?.(book)} onLongPress={() => onLongPress?.(book)}>
    <Image
      source={{ uri: book.thumbnailPath || book.coverImagePath || undefined }}
      style={styles.cover}
      defaultSource={require('../../../assets/icon.png')}
    />
    <View style={styles.content}>
      <Text numberOfLines={2} style={styles.title}>
        {book.title}
      </Text>
      <Text style={styles.author}>{book.author || 'Tác giả không rõ'}</Text>
      <Text style={styles.meta}>
        {book.totalPages > 0 ? `${book.currentPage}/${book.totalPages} trang` : 'Chưa đọc'} · Thêm {formatDate(book.addTime)}
      </Text>
      <View style={styles.progressBar}>
        <View style={[styles.progressIndicator, { width: `${calculateProgress(book.currentPage, book.totalPages)}%` }]} />
      </View>
    </View>
  </TouchableOpacity>
));

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    padding: 12,
    marginHorizontal: 16,
    marginVertical: 6,
    borderRadius: 12,
    backgroundColor: '#FFFFFF',
    shadowColor: '#000',
    shadowOpacity: 0.05,
    shadowRadius: 8,
    shadowOffset: { width: 0, height: 2 },
    elevation: 1,
  },
  cover: {
    width: 60,
    height: 90,
    borderRadius: 8,
    backgroundColor: '#E5E7EB',
    marginRight: 12,
  },
  content: {
    flex: 1,
    justifyContent: 'space-between',
  },
  title: {
    fontSize: 16,
    fontWeight: '600',
    color: '#111827',
  },
  author: {
    fontSize: 14,
    color: '#6B7280',
    marginTop: 2,
  },
  meta: {
    fontSize: 12,
    color: '#9CA3AF',
    marginTop: 4,
  },
  progressBar: {
    marginTop: 8,
    height: 4,
    backgroundColor: '#E5E7EB',
    borderRadius: 2,
  },
  progressIndicator: {
    height: '100%',
    backgroundColor: '#2563EB',
    borderRadius: 2,
  },
});

export default BookListItem;

