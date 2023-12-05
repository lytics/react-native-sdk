import * as React from 'react';
import { View, Text, Button } from 'react-native';

import { styles } from '../components/Styles';

export function EventDetailScreen() {
  const handleBuy = () => {
    console.log('Buy');
  };

  return (
    <View style={styles.container}>
      <Text>Event Detail</Text>
      <Button title="Buy Tickets" onPress={handleBuy} />
    </View>
  );
}
