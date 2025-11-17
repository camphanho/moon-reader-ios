import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useStatisticsStore } from '../../store/statisticsStore';

export const ReadingStatisticsView: React.FC = () => {
  const totalTime = useStatisticsStore((state) => state.totalTime);
  const totalWords = useStatisticsStore((state) => state.totalWords);
  const weekData = useStatisticsStore((state) => state.getWeekData());

  const totalHours = (totalTime / 3600).toFixed(1);
  const wordsPerMinute = totalTime > 0 ? Math.round(totalWords / (totalTime / 60)) : 0;

  return (
    <View style={styles.container}>
      <Text style={styles.heading}>Thống kê đọc sách</Text>
      <View style={styles.cardRow}>
        <View style={styles.card}>
          <Text style={styles.cardLabel}>Tổng thời gian</Text>
          <Text style={styles.cardValue}>{totalHours} giờ</Text>
        </View>
        <View style={styles.card}>
          <Text style={styles.cardLabel}>Tốc độ trung bình</Text>
          <Text style={styles.cardValue}>{wordsPerMinute} wpm</Text>
        </View>
      </View>
      <Text style={styles.subheading}>7 ngày gần đây</Text>
      <View style={styles.barRow}>
        {weekData.map((item) => (
          <View key={item.date} style={styles.barColumn}>
            <View style={styles.barTrack}>
              <View style={[styles.barFill, { height: Math.min(100, item.seconds / 60) }]} />
            </View>
            <Text style={styles.barLabel}>{item.date}</Text>
          </View>
        ))}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { padding: 16, backgroundColor: '#FFFFFF', borderRadius: 16, marginBottom: 16 },
  heading: { fontSize: 16, fontWeight: '700', marginBottom: 12, color: '#111827' },
  subheading: { fontSize: 14, fontWeight: '600', marginBottom: 8, color: '#6B7280' },
  cardRow: { flexDirection: 'row', gap: 12 },
  card: { flex: 1, padding: 12, borderRadius: 12, backgroundColor: '#F3F4F6' },
  cardLabel: { fontSize: 12, color: '#6B7280' },
  cardValue: { fontSize: 20, fontWeight: '700', marginTop: 4, color: '#111827' },
  barRow: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 8 },
  barColumn: { alignItems: 'center' },
  barTrack: { width: 20, height: 100, borderRadius: 10, backgroundColor: '#E5E7EB', overflow: 'hidden', justifyContent: 'flex-end' },
  barFill: { width: '100%', backgroundColor: '#2563EB', borderRadius: 10 },
  barLabel: { marginTop: 4, fontSize: 10, color: '#9CA3AF' },
});

export default ReadingStatisticsView;

