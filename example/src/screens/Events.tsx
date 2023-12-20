import * as React from 'react';
import { View, Text, Button } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { track } from 'react-native-sdk';

import { styles } from '../components/Styles';
import type { EventsStackParams } from '../navigation/EventsStackParams';

export function EventsScreen({
  navigation,
}: NativeStackScreenProps<EventsStackParams, 'Events'>) {
  const handleSelect = () => {
    console.log('Select');
    track({ name: 'Event_Tap', properties: { event: 'Event_Tap' } });
    navigation.navigate('EventDetail');
  };

  return (
    <View style={styles.container}>
      <Text>Events</Text>
      <Button title="Select Event" onPress={handleSelect} />
    </View>
  );
}
