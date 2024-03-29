import React, { useState } from 'react';
import { View, Text, TextInput, Button } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { identify } from 'react-native-lytics';

import { styles } from '../components/Styles';
import type { LoginStackParams } from '../navigation/LoginStackParams';

export function LoginScreen({
  navigation,
}: NativeStackScreenProps<LoginStackParams, 'Login'>) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = () => {
    console.log('Login');
    identify({ identifiers: { email: email } });
  };

  const handleRegister = () => {
    navigation.navigate('SignUp');
  };

  return (
    <View style={styles.container}>
      <Text>Welcome!</Text>
      <TextInput
        style={styles.input}
        placeholder="Email Address"
        value={email}
        onChangeText={(text) => setEmail(text)}
      />
      <TextInput
        style={styles.input}
        placeholder="Password"
        secureTextEntry
        value={password}
        onChangeText={(text) => setPassword(text)}
      />
      <Button title="Login" onPress={handleLogin} />
      <Text>Don't have an account?</Text>
      <Button title="Register" onPress={handleRegister} />
    </View>
  );
}
