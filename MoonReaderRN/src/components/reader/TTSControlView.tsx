import React, { useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Picker } from '@react-native-picker/picker';
import Slider from '@react-native-community/slider';
import { useTTSStore } from '../../store/ttsStore';

interface TTSControlViewProps {
  text: string;
}

export const TTSControlView: React.FC<TTSControlViewProps> = ({ text }) => {
  const { isSpeaking, isPaused, voices, voice, rate, pitch, loadVoices, setVoice, setRate, setPitch, speak, pause, resume, stop } =
    useTTSStore();

  useEffect(() => {
    loadVoices();
  }, [loadVoices]);

  const pickerVoices = voices.filter((v) => v.language.startsWith('vi') || v.language.startsWith('en')).slice(0, 6);

  return (
    <View style={styles.container}>
      <View style={styles.row}>
        <TouchableOpacity style={styles.controlButton} onPress={() => speak(text)}>
          <Text style={styles.buttonText}>{isSpeaking && !isPaused ? 'Đọc lại' : 'Đọc'}</Text>
        </TouchableOpacity>
        {isSpeaking && !isPaused ? (
          <TouchableOpacity style={styles.controlButton} onPress={pause}>
            <Text style={styles.buttonText}>Tạm dừng</Text>
          </TouchableOpacity>
        ) : (
          <TouchableOpacity style={styles.controlButton} onPress={resume}>
            <Text style={styles.buttonText}>Tiếp tục</Text>
          </TouchableOpacity>
        )}
        <TouchableOpacity style={styles.controlButton} onPress={stop}>
          <Text style={styles.buttonText}>Stop</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.pickerRow}>
        <Text style={styles.label}>Giọng đọc</Text>
        <View style={styles.pickerWrapper}>
          <Picker selectedValue={voice} style={styles.picker} onValueChange={(value) => setVoice(value.toString())}>
            {pickerVoices.map((v) => (
              <Picker.Item key={v.identifier} label={`${v.name} (${v.language})`} value={v.identifier} />
            ))}
          </Picker>
        </View>
      </View>

      <View style={styles.sliderBlock}>
        <Text style={styles.label}>Tốc độ: {rate.toFixed(1)}</Text>
        <Slider minimumValue={0.5} maximumValue={1.5} step={0.1} value={rate} onValueChange={setRate} />
      </View>

      <View style={styles.sliderBlock}>
        <Text style={styles.label}>Pitch: {pitch.toFixed(1)}</Text>
        <Slider minimumValue={0.7} maximumValue={1.3} step={0.1} value={pitch} onValueChange={setPitch} />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { padding: 16, backgroundColor: '#0F172A', borderRadius: 16, marginHorizontal: 16, marginTop: 12 },
  row: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 12 },
  controlButton: { flex: 1, marginHorizontal: 4, paddingVertical: 10, backgroundColor: '#2563EB', borderRadius: 12, alignItems: 'center' },
  buttonText: { color: '#FFFFFF', fontWeight: '600' },
  pickerRow: { marginBottom: 12 },
  label: { color: '#E5E7EB', marginBottom: 6 },
  pickerWrapper: { borderRadius: 12, overflow: 'hidden', backgroundColor: '#1F2937' },
  picker: { color: '#F9FAFB' },
  sliderBlock: { marginBottom: 12 },
});

export default TTSControlView;

