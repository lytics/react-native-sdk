import React, { useState } from 'react';
import { View, Text, TextInput, Button } from 'react-native';
import CheckBox from '@react-native-community/checkbox';
import {
  consent,
  identify,
  requestTrackingAuthorization,
} from 'react-native-lytics';

import { styles } from '../components/Styles';

export function SignUpScreen() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [acceptTerms, setAcceptTerms] = useState(false);
  const [allowPersonalization, setAllowPersonalization] = useState(false);

  const sendInfo = () => {
    identify({
      identifiers: { email: email },
      attributes: { name: name },
    });
    consent({
      consent: {
        documents: ['terms_aug_2022', 'privacy_may_2022'],
        consented: true,
      },
    });
  };

  const handleSignUp = () => {
    if (allowPersonalization) {
      console.log('Requesting Tracking Authorization...');
      requestTrackingAuthorization().then((granted) => {
        if (granted) {
          console.log('Authorized');
        } else {
          console.log('Denied');
        }

        sendInfo();
      });
    } else {
      sendInfo();
    }
    console.log('Sign Up');
  };

  return (
    <View style={styles.container}>
      <Text>Create an account to get started</Text>
      <TextInput
        style={styles.input}
        placeholder="Name"
        value={name}
        onChangeText={(text) => setName(text)}
      />
      <TextInput
        style={styles.input}
        placeholder="Email Address"
        value={email}
        onChangeText={(text) => setEmail(text)}
        autoCapitalize="none"
        keyboardType="email-address"
      />
      <TextInput
        style={styles.input}
        placeholder="Password"
        secureTextEntry
        value={password}
        onChangeText={(text) => setPassword(text)}
      />
      <View style={styles.checkboxContainer}>
        <CheckBox
          value={acceptTerms}
          onValueChange={(value: boolean) => setAcceptTerms(value)}
        />
        <Text style={styles.label}>
          I've read and agree with the Terms and Conditions and the Privacy
          Policy.
        </Text>
      </View>
      <View style={styles.checkboxContainer}>
        <CheckBox
          value={allowPersonalization}
          onValueChange={(value: boolean) => setAllowPersonalization(value)}
        />
        <Text style={styles.label}>
          Improve my experience with better personalization (IDFA Demo).
        </Text>
      </View>
      <Button
        title="Complete"
        onPress={handleSignUp}
        disabled={!name || !password || !password || !acceptTerms}
      />
    </View>
  );
}
