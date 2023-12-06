import * as React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

import { EventDetailScreen } from '../screens/EventDetail';
import { EventsScreen } from '../screens/Events';
import type { EventsStackParams } from './EventsStackParams';

const EventsStack = createNativeStackNavigator<EventsStackParams>();

export const EventsTabNavigator = () => {
  return (
    <EventsStack.Navigator initialRouteName="Events">
      <EventsStack.Screen name="Events" component={EventsScreen} />
      <EventsStack.Screen name="EventDetail" component={EventDetailScreen} />
    </EventsStack.Navigator>
  );
};
