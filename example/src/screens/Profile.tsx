import React, { useEffect, useState } from 'react';
import { View, Text, ScrollView } from 'react-native';
import { getProfile } from 'react-native-sdk';

import { styles } from '../components/Styles';

export function ProfileScreen() {
  const [data, setData] = useState({});

  const loadProfile = async () => {
    try {
      const profile = await getProfile();
      console.log('Profile:', profile);
      setData(profile);
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    loadProfile();
  }, []);

  return (
    <View style={styles.container}>
      <Text>
        The following is an output of the current user’s stored data in JSON
        format:
      </Text>
      <ScrollView style={styles.scrollView}>
        <Text>{JSON.stringify(data, null, 2)}</Text>
      </ScrollView>
    </View>
  );
}
