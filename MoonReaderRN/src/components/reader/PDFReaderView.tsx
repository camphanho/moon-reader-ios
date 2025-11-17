import React from 'react';
import { View, ActivityIndicator, StyleSheet, Dimensions } from 'react-native';
import Pdf from 'react-native-pdf';

interface PDFReaderViewProps {
  uri: string;
}

const { width, height } = Dimensions.get('window');

export const PDFReaderView: React.FC<PDFReaderViewProps> = ({ uri }) => {
  const source = { uri, cache: true };

  return (
    <View style={styles.container}>
      <Pdf
        source={source}
        onLoadComplete={(numberOfPages) => console.log(`PDF loaded, ${numberOfPages} pages`)}
        onError={(error) => console.warn(error)}
        onPressLink={(uri) => console.log(`Link pressed: ${uri}`)}
        style={styles.pdf}
        renderActivityIndicator={() => <ActivityIndicator size="large" color="#2563EB" />}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  pdf: {
    flex: 1,
    width,
    height,
  },
});

export default PDFReaderView;

