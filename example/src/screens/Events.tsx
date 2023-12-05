import * as React from 'react';
import { View, Text, Button } from 'react-native';

import { styles } from '../components/Styles';

export function EventsScreen({ navigation: { navigate } }) {
  const handleSelect = () => {
    console.log('Select');
    navigate('EventDetail');
  };

  return (
    <View style={styles.container}>
      <Text>Events</Text>
      <Button title="Select Event" onPress={handleSelect} />
    </View>
  );
}
