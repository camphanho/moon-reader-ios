import React, { useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView, SafeAreaView, Switch, TouchableOpacity } from 'react-native';
import Slider from '@react-native-community/slider';
import { useAppSettingsStore } from '../../store/appSettingsStore';
import { useReaderStore } from '../../store/readerStore';
import { Theme } from '../../utils/constants';
import ReadingStatisticsView from '../reader/ReadingStatisticsView';
import ReadingCalendarView from '../reader/ReadingCalendarView';
import { useAuthStore } from '../../store/authStore';
import { useSyncStore } from '../../store/syncStore';

const themeOptions = [
  { label: 'Day', value: Theme.DAY, preview: ['#FFFFFF', '#F3F4F6'] },
  { label: 'Night', value: Theme.NIGHT, preview: ['#1F2933', '#111827'] },
  { label: 'AMOLED', value: Theme.AMOLED, preview: ['#000000', '#0F172A'] },
  { label: 'Sepia', value: Theme.SEPIA, preview: ['#F3E9DC', '#E0D1C0'] },
];

const accentPalette = ['#2563EB', '#EC4899', '#F97316', '#84CC16', '#10B981', '#A855F7'];

export default function SettingsView() {
  const user = useAuthStore((state) => state.user);
  const authLoading = useAuthStore((state) => state.isLoading);
  const authError = useAuthStore((state) => state.error);
  const initializeAuth = useAuthStore((state) => state.initialize);
  const signIn = useAuthStore((state) => state.signIn);
  const signOut = useAuthStore((state) => state.signOut);

  const { isSyncing, lastSynced, error: syncError, syncAll } = useSyncStore();

  useEffect(() => {
    initializeAuth();
  }, [initializeAuth]);
  const theme = useAppSettingsStore((state) => state.theme);
  const useSystemTheme = useAppSettingsStore((state) => state.useSystemTheme);
  const setTheme = useAppSettingsStore((state) => state.setTheme);
  const toggleSystemTheme = useAppSettingsStore((state) => state.toggleSystemTheme);
  const accentColor = useAppSettingsStore((state) => state.accentColor);
  const setAccentColor = useAppSettingsStore((state) => state.setAccentColor);

  const fontSize = useReaderStore((state) => state.fontSize);
  const lineHeight = useReaderStore((state) => state.lineHeight);
  const margin = useReaderStore((state) => state.margin);
  const updateSettings = useReaderStore((state) => state.updateSettings);

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <Text style={styles.heading}>Giao diện</Text>

        <View style={styles.row}>
          <View>
            <Text style={styles.rowTitle}>Đồng bộ Theme với hệ thống</Text>
            <Text style={styles.rowSubtitle}>Tự động chọn theme theo cài đặt thiết bị</Text>
          </View>
          <Switch value={useSystemTheme} onValueChange={toggleSystemTheme} />
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Chọn Theme</Text>
          <View style={styles.themeGrid}>
            {themeOptions.map((item) => (
              <TouchableOpacity
                key={item.value}
                style={[styles.themeCard, theme === item.value && styles.themeCardActive]}
                onPress={() => setTheme(item.value)}
              >
                <View style={[styles.themePreview, { backgroundColor: item.preview[0] }]}>
                  <View style={[styles.themePreviewAccent, { backgroundColor: item.preview[1] }]} />
                </View>
                <Text style={styles.themeLabel}>{item.label}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Màu nhấn</Text>
          <View style={styles.accentRow}>
            {accentPalette.map((color) => (
              <TouchableOpacity
                key={color}
                style={[
                  styles.accentDot,
                  { backgroundColor: color },
                  accentColor === color && styles.accentDotActive,
                ]}
                onPress={() => setAccentColor(color)}
              />
            ))}
          </View>
        </View>

        <Text style={styles.heading}>Đọc sách</Text>

        <View style={styles.settingBlock}>
          <Text style={styles.sliderLabel}>Cỡ chữ: {fontSize.toFixed(0)}</Text>
          <Slider
            minimumValue={12}
            maximumValue={32}
            step={1}
            value={fontSize}
            onValueChange={(value) => updateSettings({ fontSize: value, lineHeight: value * 1.5 })}
          />
        </View>

        <View style={styles.settingBlock}>
          <Text style={styles.sliderLabel}>Giãn dòng: {Math.round(lineHeight)}</Text>
          <Slider
            minimumValue={16}
            maximumValue={40}
            step={1}
            value={lineHeight}
            onValueChange={(value) => updateSettings({ lineHeight: value })}
          />
        </View>

        <View style={styles.settingBlock}>
          <Text style={styles.sliderLabel}>Margin: {Math.round(margin)}</Text>
          <Slider
            minimumValue={10}
            maximumValue={40}
            step={1}
            value={margin}
            onValueChange={(value) => updateSettings({ margin: value })}
          />
        </View>

        <View style={styles.noteCard}>
          <Text style={styles.noteTitle}>Ghi chú</Text>
          <Text style={styles.noteDescription}>
            Các cài đặt đọc sách (cỡ chữ, giãn dòng, margin) sẽ áp dụng trực tiếp trong Reader. Theme và màu nhấn áp dụng
            cho toàn bộ ứng dụng.
          </Text>
        </View>

        <Text style={styles.heading}>Cloud Sync</Text>
        <View style={styles.card}>
          <Text style={styles.rowTitle}>Trạng thái</Text>
          <Text style={styles.rowSubtitle}>
            {user ? `Đã đăng nhập (ID: ${user.uid.slice(0, 6)}…)` : 'Chưa đăng nhập'}
          </Text>
          <Text style={styles.rowSubtitle}>
            Lần sync cuối: {lastSynced ? lastSynced.toLocaleString() : 'Chưa sync'}
          </Text>
          {authError ? <Text style={styles.errorText}>{authError}</Text> : null}
          {syncError ? <Text style={styles.errorText}>{syncError}</Text> : null}
          <View style={styles.rowButtons}>
            {!user ? (
              <TouchableOpacity style={styles.syncButton} onPress={signIn}>
                <Text style={styles.syncButtonText}>{authLoading ? 'Đang đăng nhập...' : 'Đăng nhập ẩn danh'}</Text>
              </TouchableOpacity>
            ) : (
              <>
                <TouchableOpacity style={styles.syncButton} onPress={syncAll}>
                  <Text style={styles.syncButtonText}>{isSyncing ? 'Đang sync...' : 'Đồng bộ ngay'}</Text>
                </TouchableOpacity>
                <TouchableOpacity style={[styles.syncButton, styles.signOutButton]} onPress={signOut}>
                  <Text style={[styles.syncButtonText, styles.signOutText]}>Đăng xuất</Text>
                </TouchableOpacity>
              </>
            )}
          </View>
        </View>

        <Text style={styles.heading}>Thống kê đọc</Text>
        <ReadingStatisticsView />
        <ReadingCalendarView />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#F8FAFC',
  },
  container: {
    padding: 16,
    paddingBottom: 40,
  },
  heading: {
    fontSize: 18,
    fontWeight: '700',
    marginVertical: 12,
    color: '#111827',
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 8,
    color: '#111827',
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 16,
    borderRadius: 16,
    backgroundColor: '#FFFFFF',
    shadowColor: '#000',
    shadowOpacity: 0.05,
    shadowRadius: 8,
    shadowOffset: { width: 0, height: 2 },
    marginBottom: 16,
  },
  rowTitle: {
    fontSize: 15,
    fontWeight: '600',
    color: '#111827',
  },
  rowSubtitle: {
    fontSize: 13,
    color: '#6B7280',
    marginTop: 4,
  },
  rowButtons: {
    flexDirection: 'row',
    marginTop: 12,
    gap: 12,
  },
  syncButton: {
    flex: 1,
    backgroundColor: '#2563EB',
    paddingVertical: 10,
    borderRadius: 12,
    alignItems: 'center',
  },
  syncButtonText: {
    color: '#FFFFFF',
    fontWeight: '600',
  },
  signOutButton: {
    backgroundColor: '#FEE2E2',
  },
  signOutText: {
    color: '#B91C1C',
  },
  errorText: {
    marginTop: 8,
    color: '#DC2626',
  },
  themeGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  card: {
    padding: 16,
    borderRadius: 16,
    backgroundColor: '#FFFFFF',
    marginBottom: 16,
    shadowColor: '#000',
    shadowOpacity: 0.04,
    shadowRadius: 6,
    shadowOffset: { width: 0, height: 2 },
  },
  themeCard: {
    width: '47%',
    padding: 16,
    borderRadius: 16,
    backgroundColor: '#FFFFFF',
    borderWidth: 1,
    borderColor: '#E5E7EB',
  },
  themeCardActive: {
    borderColor: '#2563EB',
  },
  themePreview: {
    height: 48,
    borderRadius: 12,
    marginBottom: 10,
    justifyContent: 'flex-end',
  },
  themePreviewAccent: {
    height: 12,
    borderBottomLeftRadius: 12,
    borderBottomRightRadius: 12,
  },
  themeLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#111827',
  },
  accentRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  accentDot: {
    width: 36,
    height: 36,
    borderRadius: 18,
  },
  accentDotActive: {
    borderWidth: 3,
    borderColor: '#374151',
  },
  settingBlock: {
    padding: 16,
    borderRadius: 16,
    backgroundColor: '#FFFFFF',
    marginBottom: 16,
    shadowColor: '#000',
    shadowOpacity: 0.04,
    shadowRadius: 6,
    shadowOffset: { width: 0, height: 2 },
  },
  sliderLabel: {
    marginBottom: 8,
    fontSize: 14,
    color: '#111827',
  },
  noteCard: {
    padding: 16,
    borderRadius: 16,
    backgroundColor: '#E0E7FF',
  },
  noteTitle: {
    fontSize: 15,
    fontWeight: '600',
    color: '#1E3A8A',
    marginBottom: 4,
  },
  noteDescription: {
    fontSize: 13,
    color: '#1E3A8A',
  },
});

