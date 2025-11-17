import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Modal } from 'react-native';
import Slider from '@react-native-community/slider';
import { Theme, TextAlignment } from '../../utils/constants';
import { useReaderStore } from '../../store/readerStore';

interface ReaderSettingsViewProps {
  visible: boolean;
  onClose: () => void;
}

const themes = [
  { label: 'Day', value: Theme.DAY },
  { label: 'Night', value: Theme.NIGHT },
  { label: 'AMOLED', value: Theme.AMOLED },
  { label: 'Sepia', value: Theme.SEPIA },
];

const alignments = [
  { label: 'Trái', value: TextAlignment.LEFT },
  { label: 'Giữa', value: TextAlignment.CENTER },
  { label: 'Phải', value: TextAlignment.RIGHT },
  { label: 'Justify', value: TextAlignment.JUSTIFY },
];

export const ReaderSettingsView: React.FC<ReaderSettingsViewProps> = ({ visible, onClose }) => {
  const theme = useReaderStore((state) => state.theme);
  const fontSize = useReaderStore((state) => state.fontSize);
  const lineHeight = useReaderStore((state) => state.lineHeight);
  const alignment = useReaderStore((state) => state.alignment);
  const updateSettings = useReaderStore((state) => state.updateSettings);

  const onThemeChange = (value: Theme) => updateSettings({ theme: value });
  const onAlignmentChange = (value: TextAlignment) => updateSettings({ alignment: value });

  return (
    <Modal visible={visible} animationType="slide" transparent>
      <View style={styles.overlay}>
        <View style={styles.container}>
          <Text style={styles.title}>Cài đặt đọc sách</Text>

          <Text style={styles.label}>Theme</Text>
          <View style={styles.buttonGroup}>
            {themes.map((item) => (
              <TouchableOpacity
                key={item.value}
                style={[styles.button, theme === item.value && styles.buttonActive]}
                onPress={() => onThemeChange(item.value)}
              >
                <Text style={[styles.buttonText, theme === item.value && styles.buttonTextActive]}>{item.label}</Text>
              </TouchableOpacity>
            ))}
          </View>

          <Text style={styles.label}>Cỡ chữ: {fontSize}</Text>
          <Slider
            minimumValue={12}
            maximumValue={32}
            step={1}
            value={fontSize}
            onValueChange={(value: number) => updateSettings({ fontSize: value, lineHeight: value * 1.5 })}
          />

          <Text style={styles.label}>Giãn dòng: {Math.round(lineHeight)}</Text>
          <Slider
            minimumValue={16}
            maximumValue={40}
            step={1}
            value={lineHeight}
            onValueChange={(value: number) => updateSettings({ lineHeight: value })}
          />

          <Text style={styles.label}>Canh lề</Text>
          <View style={styles.buttonGroup}>
            {alignments.map((item) => (
              <TouchableOpacity
                key={item.value}
                style={[styles.button, alignment === item.value && styles.buttonActive]}
                onPress={() => onAlignmentChange(item.value)}
              >
                <Text style={[styles.buttonText, alignment === item.value && styles.buttonTextActive]}>{item.label}</Text>
              </TouchableOpacity>
            ))}
          </View>

          <TouchableOpacity style={styles.closeButton} onPress={onClose}>
            <Text style={styles.closeText}>Đóng</Text>
          </TouchableOpacity>
        </View>
      </View>
    </Modal>
  );
};

const styles = StyleSheet.create({
  overlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' },
  container: { backgroundColor: '#FFFFFF', borderTopLeftRadius: 20, borderTopRightRadius: 20, padding: 16 },
  title: { fontSize: 18, fontWeight: '600', marginBottom: 12 },
  label: { marginTop: 16, marginBottom: 8, fontSize: 14, color: '#6B7280' },
  buttonGroup: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  button: { paddingVertical: 8, paddingHorizontal: 16, borderRadius: 12, backgroundColor: '#F3F4F6' },
  buttonActive: { backgroundColor: '#2563EB' },
  buttonText: { color: '#6B7280' },
  buttonTextActive: { color: '#FFFFFF', fontWeight: '600' },
  closeButton: { marginTop: 16, paddingVertical: 12, borderRadius: 12, backgroundColor: '#111827', alignItems: 'center' },
  closeText: { color: '#FFFFFF', fontWeight: '600' },
});

export default ReaderSettingsView;

