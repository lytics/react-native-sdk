import React, { useEffect } from 'react';
import { View, Text, Button } from 'react-native';
import { screen, track } from 'react-native-sdk';

import { styles } from '../components/Styles';

export function EventDetailScreen() {
  useEffect(() => {
    console.log('Load Event Detail');
    screen({
      name: 'Event_Detail',
      properties: { artistID: 123, eventID: 345 },
    });
  }, []);

  const handleBuy = () => {
    console.log('Buy');
    track({
      name: 'Buy_Tickets',
      properties: { artistID: 123, eventID: 345 },
    });
  };

  return (
    <View style={styles.container}>
      <Text>Event Detail</Text>
      <Button title="Buy Tickets" onPress={handleBuy} />
    </View>
  );
}
