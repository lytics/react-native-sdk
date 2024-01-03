import * as React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

import { LoginScreen } from '../screens/Login';
import { SignUpScreen } from '../screens/SignUp';
import type { LoginStackParams } from './LoginStackParams';

const LoginStack = createNativeStackNavigator<LoginStackParams>();

export const LoginTabNavigator = () => {
  return (
    <LoginStack.Navigator>
      <LoginStack.Screen name="Login" component={LoginScreen} />
      <LoginStack.Screen name="SignUp" component={SignUpScreen} />
    </LoginStack.Navigator>
  );
};
