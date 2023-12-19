import * as React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { start, hasStarted, LogLevel } from 'react-native-sdk';

import { EventsTabNavigator } from './navigation/EventsTabNavigator';
import { LoginTabNavigator } from './navigation/LoginTabNavigator';
import { ProfileScreen } from './screens/Profile';
import { SettingsScreen } from './screens/Settings';

const Tab = createBottomTabNavigator();

export default function App() {
  const [result, setResult] = React.useState<boolean | undefined>();

  // WARNING: this is not a safe way to store your API token!
  const apiToken = 'xxxxxx';

  React.useEffect(() => {
    // Configure the SDK at startup
    start(apiToken, {
      logLevel: LogLevel.debug,
    });
    hasStarted().then(setResult);
  }, []);

  console.log('hasStarted:', result);

  return (
    <NavigationContainer>
      <Tab.Navigator>
        <Tab.Screen
          name="Events"
          component={EventsTabNavigator}
          options={{ headerShown: false }}
        />
        <Tab.Screen
          name="Login"
          component={LoginTabNavigator}
          options={{ headerShown: false }}
        />
        <Tab.Screen name="Profile" component={ProfileScreen} />
        <Tab.Screen name="Settings" component={SettingsScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}
