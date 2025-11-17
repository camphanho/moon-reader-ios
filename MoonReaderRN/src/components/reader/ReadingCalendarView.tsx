import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useStatisticsStore } from '../../store/statisticsStore';

export const ReadingCalendarView: React.FC = () => {
  const dailyLog = useStatisticsStore((state) => state.dailyLog);
  const days = getLastThirtyDays();

  return (
    <View style={styles.container}>
      <Text style={styles.heading}>Lịch đọc</Text>
      <View style={styles.grid}>
        {days.map((day) => {
          const seconds = dailyLog[day.key] || 0;
          const intensity = Math.min(1, seconds / 1800); // 30 min threshold
          return (
            <View key={day.key} style={[styles.cell, { backgroundColor: getIntensityColor(intensity) }]}>
              <Text style={styles.cellLabel}>{day.label}</Text>
            </View>
          );
        })}
      </View>
    </View>
  );
};

function getLastThirtyDays() {
  const result: Array<{ key: string; label: string }> = [];
  for (let i = 29; i >= 0; i--) {
    const date = new Date();
    date.setDate(date.getDate() - i);
    result.push({
      key: `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`,
      label: `${date.getDate()}/${date.getMonth() + 1}`,
    });
  }
  return result;
}

function getIntensityColor(intensity: number) {
  if (intensity === 0) return '#E5E7EB';
  if (intensity < 0.33) return '#BFDBFE';
  if (intensity < 0.66) return '#60A5FA';
  return '#2563EB';
}

const styles = StyleSheet.create({
  container: { padding: 16, backgroundColor: '#FFFFFF', borderRadius: 16 },
  heading: { fontSize: 16, fontWeight: '700', marginBottom: 12, color: '#111827' },
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  cell: { width: '30%', paddingVertical: 12, borderRadius: 12, alignItems: 'center' },
  cellLabel: { fontSize: 12, color: '#1F2937' },
});

export default ReadingCalendarView;

