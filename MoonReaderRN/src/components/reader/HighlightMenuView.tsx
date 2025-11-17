import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Modal } from 'react-native';
import { HighlightColor } from '../../models/Bookmark';

interface HighlightMenuViewProps {
  visible: boolean;
  onClose: () => void;
  onSelectColor: (color: HighlightColor) => void;
  onAddBookmark: () => void;
}

const colors = [
  { color: HighlightColor.YELLOW, hex: '#FCD34D' },
  { color: HighlightColor.GREEN, hex: '#86EFAC' },
  { color: HighlightColor.BLUE, hex: '#93C5FD' },
  { color: HighlightColor.PINK, hex: '#F9A8D4' },
  { color: HighlightColor.PURPLE, hex: '#C4B5FD' },
  { color: HighlightColor.ORANGE, hex: '#FDBA74' },
];

export const HighlightMenuView: React.FC<HighlightMenuViewProps> = ({ visible, onClose, onSelectColor, onAddBookmark }) => (
  <Modal visible={visible} transparent animationType="fade">
    <View style={styles.overlay}>
      <View style={styles.container}>
        <Text style={styles.title}>Highlight</Text>
        <View style={styles.colorRow}>
          {colors.map((item) => (
            <TouchableOpacity key={item.color} style={[styles.colorDot, { backgroundColor: item.hex }]} onPress={() => onSelectColor(item.color)} />
          ))}
        </View>
        <TouchableOpacity style={styles.button} onPress={onAddBookmark}>
          <Text style={styles.buttonText}>Lưu Bookmark</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.closeButton} onPress={onClose}>
          <Text style={styles.closeText}>Hủy</Text>
        </TouchableOpacity>
      </View>
    </View>
  </Modal>
);

const styles = StyleSheet.create({
  overlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.3)', justifyContent: 'center', alignItems: 'center' },
  container: { width: '80%', backgroundColor: '#FFFFFF', borderRadius: 16, padding: 16 },
  title: { fontSize: 18, fontWeight: '600', marginBottom: 12 },
  colorRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 16 },
  colorDot: { width: 32, height: 32, borderRadius: 16 },
  button: { backgroundColor: '#2563EB', paddingVertical: 10, borderRadius: 12, marginBottom: 8 },
  buttonText: { color: '#FFFFFF', textAlign: 'center', fontWeight: '600' },
  closeButton: { paddingVertical: 8 },
  closeText: { textAlign: 'center', color: '#6B7280' },
});

export default HighlightMenuView;

