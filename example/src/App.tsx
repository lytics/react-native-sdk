import * as React from 'react';

import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';

import { EventsScreen } from './screens/Events';
import { LoginScreen } from './screens/Login';
import { ProfileScreen } from './screens/Profile';
import { SettingsScreen } from './screens/Settings';

import { start, hasStarted } from 'react-native-sdk';

const Tab = createBottomTabNavigator();

export default function App() {
  const [result, setResult] = React.useState<boolean | undefined>();

  // WARNING: this is not a safe way to store your API token!
  const apiToken = 'xxxxxx';

  React.useEffect(() => {
    // Configure the SDK at startup
    start(apiToken, {});
    hasStarted().then(setResult);
  }, []);

  console.log('hasStarted:', result);

  return (
    <NavigationContainer>
      <Tab.Navigator>
        <Tab.Screen name="Events" component={EventsScreen} />
        <Tab.Screen name="Login" component={LoginScreen} />
        <Tab.Screen name="Profile" component={ProfileScreen} />
        <Tab.Screen name="Settings" component={SettingsScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}
