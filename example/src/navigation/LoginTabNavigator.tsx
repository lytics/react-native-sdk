import * as React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

import { LoginScreen } from '../screens/Login';
import { SignUpScreen } from '../screens/SignUp';

export type LoginStackParams = {
  Login: undefined;
  SignUp: undefined;
};

const LoginStack = createNativeStackNavigator<LoginStackParams>();

export const LoginTabNavigator = () => {
  return (
    <LoginStack.Navigator initialRouteName="Login">
      <LoginStack.Screen name="Login" component={LoginScreen} />
      <LoginStack.Screen name="SignUp" component={SignUpScreen} />
    </LoginStack.Navigator>
  );
};
