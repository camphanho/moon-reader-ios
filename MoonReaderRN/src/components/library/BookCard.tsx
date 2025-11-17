import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Book } from '../../models/Book';
import { calculateProgress } from '../../utils/helpers';

interface BookCardProps {
  book: Book;
  onPress?: (book: Book) => void;
  onLongPress?: (book: Book) => void;
}

const gradients: [string, string][] = [
  ['#FF9A9E', '#FAD0C4'],
  ['#A18CD1', '#FBC2EB'],
  ['#FAD961', '#F76B1C'],
  ['#84FAB0', '#8FD3F4'],
];

export const BookCard: React.FC<BookCardProps> = React.memo(({ book, onPress, onLongPress }) => {
  const hasCover = Boolean(book.thumbnailPath || book.coverImagePath);
  const gradient = gradients[book.title.length % gradients.length];

  return (
    <TouchableOpacity
      style={styles.card}
      onPress={() => onPress?.(book)}
      onLongPress={() => onLongPress?.(book)}
      activeOpacity={0.8}
    >
      <View style={styles.coverContainer}>
        {hasCover ? (
          <Image source={{ uri: book.thumbnailPath || book.coverImagePath || undefined }} style={styles.coverImage} />
        ) : (
          <LinearGradient colors={gradient} style={styles.coverPlaceholder}>
            <Text style={styles.coverLetter}>{book.title.charAt(0).toUpperCase()}</Text>
          </LinearGradient>
        )}
      </View>
      <Text numberOfLines={2} style={styles.title}>
        {book.title}
      </Text>
      <Text numberOfLines={1} style={styles.author}>
        {book.author || 'Tác giả không rõ'}
      </Text>
      <View style={styles.progressBar}>
        <View style={[styles.progressIndicator, { width: `${calculateProgress(book.currentPage, book.totalPages)}%` }]} />
      </View>
      <Text style={styles.progressText}>
        {book.totalPages > 0 ? `${book.currentPage}/${book.totalPages} trang` : 'Chưa đọc'}
      </Text>
    </TouchableOpacity>
  );
});

const styles = StyleSheet.create({
  card: {
    flex: 1,
    margin: 8,
    padding: 8,
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    shadowColor: '#000',
    shadowOpacity: 0.05,
    shadowRadius: 10,
    shadowOffset: { width: 0, height: 4 },
    elevation: 2,
  },
  coverContainer: {
    width: '100%',
    aspectRatio: 3 / 4,
    borderRadius: 10,
    overflow: 'hidden',
    marginBottom: 8,
  },
  coverImage: {
    width: '100%',
    height: '100%',
  },
  coverPlaceholder: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  coverLetter: {
    fontSize: 48,
    color: '#FFFFFF',
    fontWeight: '700',
  },
  title: {
    fontWeight: '600',
    fontSize: 14,
    color: '#111827',
  },
  author: {
    fontSize: 12,
    color: '#6B7280',
    marginBottom: 4,
  },
  progressBar: {
    height: 4,
    backgroundColor: '#E5E7EB',
    borderRadius: 2,
    overflow: 'hidden',
  },
  progressIndicator: {
    height: '100%',
    backgroundColor: '#2563EB',
  },
  progressText: {
    marginTop: 4,
    fontSize: 12,
    color: '#6B7280',
  },
});

export default BookCard;

