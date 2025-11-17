import React from 'react';
import { View, Text, StyleSheet, Modal, TouchableOpacity, FlatList } from 'react-native';
import { Bookmark } from '../../models/Bookmark';

interface BookmarkListViewProps {
  visible: boolean;
  bookmarks: Bookmark[];
  onClose: () => void;
  onSelect: (bookmark: Bookmark) => void;
  onDelete: (bookmark: Bookmark) => void;
}

export const BookmarkListView: React.FC<BookmarkListViewProps> = ({ visible, bookmarks, onClose, onSelect, onDelete }) => (
  <Modal visible={visible} animationType="slide" onRequestClose={onClose}>
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Bookmarks ({bookmarks.length})</Text>
        <TouchableOpacity onPress={onClose}>
          <Text style={styles.closeText}>Đóng</Text>
        </TouchableOpacity>
      </View>
      <FlatList
        data={bookmarks}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <TouchableOpacity style={styles.item} onPress={() => onSelect(item)}>
            <View style={styles.itemContent}>
              <Text style={styles.itemTitle}>{item.originalText.slice(0, 100)}</Text>
              {item.note ? <Text style={styles.itemNote}>{item.note}</Text> : null}
              <Text style={styles.itemMeta}>Chapter {item.chapter} · Page {Math.round(item.position * 100)}%</Text>
            </View>
            <TouchableOpacity onPress={() => onDelete(item)}>
              <Text style={styles.deleteText}>Xóa</Text>
            </TouchableOpacity>
          </TouchableOpacity>
        )}
        ListEmptyComponent={<Text style={styles.emptyText}>Chưa có bookmark nào</Text>}
      />
    </View>
  </Modal>
);

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#FFFFFF', paddingTop: 16 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 16, marginBottom: 12 },
  title: { fontSize: 18, fontWeight: '600' },
  closeText: { color: '#2563EB', fontWeight: '600' },
  item: { flexDirection: 'row', justifyContent: 'space-between', padding: 16, borderBottomWidth: 1, borderBottomColor: '#E5E7EB' },
  itemContent: { flex: 1, marginRight: 12 },
  itemTitle: { fontSize: 14, color: '#111827', marginBottom: 4 },
  itemNote: { fontSize: 13, color: '#6B7280' },
  itemMeta: { fontSize: 12, color: '#9CA3AF', marginTop: 4 },
  deleteText: { color: '#EF4444', fontWeight: '600' },
  emptyText: { textAlign: 'center', marginTop: 32, color: '#9CA3AF' },
});

export default BookmarkListView;

