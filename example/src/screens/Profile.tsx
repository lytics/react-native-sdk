import * as React from 'react';
import { View, Text, ScrollView } from 'react-native';

import { styles } from '../components/Styles';

export function ProfileScreen() {
  const [data, setData] = React.useState({});

  return (
    <View style={styles.container}>
      <Text>
        The following is an output of the current user’s stored data in JSON
        format:
      </Text>
      <ScrollView style={styles.scrollView}>
        <Text>{JSON.stringify(data)}</Text>
      </ScrollView>
    </View>
  );
}
