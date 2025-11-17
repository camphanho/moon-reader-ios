import React from 'react';
import { View, TouchableOpacity, Text, StyleSheet } from 'react-native';
import { Ionicons } from '@expo/vector-icons';

type ViewMode = 'grid' | 'list';

interface ViewModeToggleProps {
  mode: ViewMode;
  onChange: (mode: ViewMode) => void;
}

export const ViewModeToggle: React.FC<ViewModeToggleProps> = ({ mode, onChange }) => (
  <View style={styles.container}>
    <ToggleButton
      isActive={mode === 'grid'}
      icon="grid"
      label="Grid"
      onPress={() => onChange('grid')}
    />
    <ToggleButton
      isActive={mode === 'list'}
      icon="list"
      label="List"
      onPress={() => onChange('list')}
    />
  </View>
);

interface ToggleButtonProps {
  isActive: boolean;
  icon: keyof typeof Ionicons.glyphMap;
  label: string;
  onPress: () => void;
}

const ToggleButton: React.FC<ToggleButtonProps> = ({ isActive, icon, label, onPress }) => (
  <TouchableOpacity style={[styles.button, isActive && styles.buttonActive]} onPress={onPress}>
    <Ionicons name={icon} size={16} color={isActive ? '#2563EB' : '#6B7280'} />
    <Text style={[styles.buttonText, isActive && styles.buttonTextActive]}>{label}</Text>
  </TouchableOpacity>
);

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#F3F4F6',
    padding: 4,
    borderRadius: 12,
  },
  button: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 10,
  },
  buttonActive: {
    backgroundColor: '#FFFFFF',
    shadowColor: '#000',
    shadowOpacity: 0.05,
    shadowRadius: 6,
    shadowOffset: { width: 0, height: 2 },
    elevation: 1,
  },
  buttonText: {
    marginLeft: 4,
    fontSize: 14,
    color: '#6B7280',
  },
  buttonTextActive: {
    color: '#2563EB',
    fontWeight: '600',
  },
});

export default ViewModeToggle;

