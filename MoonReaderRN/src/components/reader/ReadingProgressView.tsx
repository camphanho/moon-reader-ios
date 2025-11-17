import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useReadingProgress } from '../../hooks/useReadingProgress';
import { useReaderStore } from '../../store/readerStore';

export const ReadingProgressView: React.FC = () => {
  const currentBook = useReaderStore((state) => state.currentBook);
  const { currentPage, totalPages, progress } = useReadingProgress();

  if (!currentBook || totalPages === 0) return null;

  return (
    <View style={styles.container}>
      <View style={styles.progressBar}>
        <View style={[styles.progressIndicator, { width: `${progress}%` }]} />
      </View>
      <View style={styles.row}>
        <Text style={styles.text}>Trang {currentPage + 1}/{totalPages}</Text>
        <Text style={styles.text}>{progress}%</Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { marginTop: 12 },
  progressBar: { height: 4, backgroundColor: '#E5E7EB', borderRadius: 2, overflow: 'hidden' },
  progressIndicator: { height: '100%', backgroundColor: '#2563EB' },
  row: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 6 },
  text: { fontSize: 12, color: '#6B7280' },
});

export default ReadingProgressView;

