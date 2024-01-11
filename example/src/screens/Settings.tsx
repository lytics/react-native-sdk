import React, { useEffect, useState } from 'react';
import { View, Button, Text } from 'react-native';
import {
  disableTracking,
  dispatch,
  isOptedIn,
  isTrackingEnabled,
  optIn,
  optOut,
  requestTrackingAuthorization,
  reset,
  user,
} from 'react-native-sdk';

import { styles } from '../components/Styles';

export function SettingsScreen() {
  const [optedIn, setOptedIn] = useState(false);
  const [trackingEnabled, setTrackingEnabled] = useState(false);
  const [userProfile, setUserProfile] = useState({});

  useEffect(() => {
    isOptedIn().then((value) => {
      console.log('isOptedIn:', value);
      setOptedIn(value);
    });
    isTrackingEnabled().then((value) => {
      console.log('isTrackingEnabled:', value);
      setTrackingEnabled(value);
    });
    user().then((value) => {
      console.log('user:', value);
      setUserProfile(value);
    });
  }, []);

  const handleOptInOrOut = () => {
    if (optedIn) {
      console.log('Opting out...');
      optOut();
    } else {
      console.log('Opting in...');
      optIn();
    }

    isOptedIn().then((value) => {
      setOptedIn(value);
    });
  };

  const handleTracking = () => {
    if (trackingEnabled) {
      console.log('Disabling tracking...');
      disableTracking();

      isTrackingEnabled().then((value) => {
        setTrackingEnabled(value);
      });
    } else {
      console.log('Enabling tracking...');
      requestTrackingAuthorization().then((granted) => {
        if (granted) {
          console.log('Tracking Authorized');
        } else {
          console.log('Tracking Denied');
        }

        isTrackingEnabled().then((value) => {
          setTrackingEnabled(value);
        });
      });
    }
  };

  const handleDispatch = () => {
    console.log('Dispatching...');
    dispatch();
  };

  const handleReset = () => {
    console.log('Reseting...');
    reset();
  };

  return (
    <View style={styles.container}>
      <Button title="Reset Demo App" onPress={handleReset} />
      <Button title="Dispatch Events" onPress={handleDispatch} />
      <Button
        title={optedIn ? 'Opt Out' : 'Opt In'}
        onPress={handleOptInOrOut}
      />
      <Button
        title={trackingEnabled ? 'Disable Tracking' : 'Enable Tracking'}
        onPress={handleTracking}
      />
      <Text>User Profile:</Text>
      <Text>{JSON.stringify(userProfile, null, 2)}</Text>
    </View>
  );
}
