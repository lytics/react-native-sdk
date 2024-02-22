import React, { useEffect } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { start, hasStarted, LogLevel } from 'react-native-lytics';

import { EventsTabNavigator } from './navigation/EventsTabNavigator';
import { LoginTabNavigator } from './navigation/LoginTabNavigator';
import { ProfileScreen } from './screens/Profile';
import { SettingsScreen } from './screens/Settings';

const Tab = createBottomTabNavigator();

export default function App() {
  // WARNING: this is not a safe way to store your API token!
  const apiToken = 'xxxxxx';

  useEffect(() => {
    // Configure the SDK at startup
    start({
      apiToken: apiToken,
      logLevel: LogLevel.debug,
    });

    hasStarted().then((result) => {
      console.log('hasStarted:', result);
    });
  }, []);

  return (
    <NavigationContainer>
      <Tab.Navigator>
        <Tab.Screen
          name="EventsTab"
          component={EventsTabNavigator}
          options={{ headerShown: false, title: 'Events' }}
        />
        <Tab.Screen
          name="LoginTab"
          component={LoginTabNavigator}
          options={{ headerShown: false, title: 'Login' }}
        />
        <Tab.Screen
          name="ProfileTab"
          component={ProfileScreen}
          options={{ title: 'Profile' }}
        />
        <Tab.Screen
          name="SettingsTab"
          component={SettingsScreen}
          options={{ title: 'Settings' }}
        />
      </Tab.Navigator>
    </NavigationContainer>
  );
}
