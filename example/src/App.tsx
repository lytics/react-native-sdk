import * as React from 'react';

import { NavigationContainer } from '@react-navigation/native';
import { StyleSheet, View, Text } from 'react-native';
import { start, hasStarted } from 'react-native-sdk';

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
      {
        <View style={styles.container}>
          <Text>Has Started: {result}</Text>
        </View>
      }
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
