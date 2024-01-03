import * as React from 'react';
import { View, Button } from 'react-native';

import { styles } from '../components/Styles';

export function SettingsScreen() {
  const handleReset = () => {
    console.log('Reset');
  };

  return (
    <View style={styles.container}>
      <Button title="Reset Demo App" onPress={handleReset} />
    </View>
  );
}
