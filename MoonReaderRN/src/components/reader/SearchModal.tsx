import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Modal, TextInput, TouchableOpacity, FlatList } from 'react-native';
import { useSearchStore } from '../../store/searchStore';
import { useReaderStore } from '../../store/readerStore';
import { RenderedContent } from '../../core/textRenderer/types';

interface SearchModalProps {
  visible: boolean;
  onClose: () => void;
  onSelectResult: (paragraphIndex: number) => void;
}

export const SearchModal: React.FC<SearchModalProps> = ({ visible, onClose, onSelectResult }) => {
  const { query, setQuery, results, selectedIndex, performSearch, nextResult, prevResult, clear } = useSearchStore();
  const renderedContent = useReaderStore((state) => state.renderedContent);
  const [inputValue, setInputValue] = useState(query);

  useEffect(() => {
    setInputValue(query);
  }, [query]);

  return (
    <Modal visible={visible} animationType="slide" onRequestClose={onClose}>
      <View style={styles.container}>
        <View style={styles.header}>
          <TextInput
            value={inputValue}
            onChangeText={setInputValue}
            placeholder="Tìm kiếm trong sách..."
            placeholderTextColor="#9CA3AF"
            style={styles.input}
            autoFocus
            onSubmitEditing={() => handleSearch(inputValue, renderedContent, performSearch, setQuery)}
          />
          <TouchableOpacity style={styles.searchButton} onPress={() => handleSearch(inputValue, renderedContent, performSearch, setQuery)}>
            <Text style={styles.searchButtonText}>Tìm</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.resultsInfo}>
          <Text style={styles.resultsText}>{results.length} kết quả</Text>
          <View style={styles.navigation}>
            <TouchableOpacity onPress={prevResult} style={styles.navButton}>
              <Text style={styles.navButtonText}>←</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={nextResult} style={styles.navButton}>
              <Text style={styles.navButtonText}>→</Text>
            </TouchableOpacity>
          </View>
        </View>
        <FlatList
          data={results}
          keyExtractor={(item) => item.paragraphId}
          renderItem={({ item, index }) => (
            <TouchableOpacity
              style={[styles.resultItem, index === selectedIndex && styles.resultItemActive]}
              onPress={() => handleSelect(item.paragraphIndex, onSelectResult, onClose)}
            >
              <Text style={styles.resultSnippet}>{item.snippet}</Text>
              <Text style={styles.resultMeta}>Đoạn {item.paragraphIndex + 1}</Text>
            </TouchableOpacity>
          )}
          ListEmptyComponent={<Text style={styles.emptyText}>Nhập từ khóa để tìm kiếm</Text>}
        />
        <TouchableOpacity
          style={styles.closeButton}
          onPress={() => {
            clear();
            onClose();
          }}
        >
          <Text style={styles.closeButtonText}>Đóng</Text>
        </TouchableOpacity>
      </View>
    </Modal>
  );
};

function handleSearch(
  query: string,
  content: RenderedContent | null | undefined,
  performSearch: (content: RenderedContent | null, query: string) => void,
  setQuery: (query: string) => void
) {
  setQuery(query);
  performSearch(content || null, query);
}

function handleSelect(paragraphIndex: number, onSelectResult: (index: number) => void, onClose: () => void) {
  onSelectResult(paragraphIndex);
  onClose();
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#FFFFFF', padding: 16 },
  header: { flexDirection: 'row', marginBottom: 12 },
  input: { flex: 1, backgroundColor: '#F3F4F6', borderRadius: 12, paddingHorizontal: 12, paddingVertical: 10, fontSize: 15, color: '#111827' },
  searchButton: { marginLeft: 8, backgroundColor: '#2563EB', paddingHorizontal: 16, borderRadius: 12, justifyContent: 'center' },
  searchButtonText: { color: '#FFFFFF', fontWeight: '600' },
  resultsInfo: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 },
  resultsText: { color: '#6B7280' },
  navigation: { flexDirection: 'row', gap: 8 },
  navButton: { padding: 6, backgroundColor: '#E5E7EB', borderRadius: 8 },
  navButtonText: { color: '#374151', fontWeight: '600' },
  resultItem: { padding: 12, borderRadius: 12, borderWidth: 1, borderColor: '#E5E7EB', marginBottom: 8 },
  resultItemActive: { borderColor: '#2563EB', backgroundColor: '#EFF6FF' },
  resultSnippet: { color: '#111827', marginBottom: 4 },
  resultMeta: { fontSize: 12, color: '#6B7280' },
  emptyText: { textAlign: 'center', marginTop: 32, color: '#9CA3AF' },
  closeButton: { marginTop: 16, paddingVertical: 12, borderRadius: 12, backgroundColor: '#111827', alignItems: 'center' },
  closeButtonText: { color: '#FFFFFF', fontWeight: '600' },
});

export default SearchModal;

