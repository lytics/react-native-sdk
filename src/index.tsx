import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const Sdk = NativeModules.LyticsBridge
  ? NativeModules.LyticsBridge
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

// Properties

export function hasStarted(): Promise<boolean> {
  return Sdk.hasStartedWithResolve();
}

// Configuration

export type LyticsConfiguration = {
  [key: string]: any;
};

export function start(apiToken: string, options: LyticsConfiguration) {
  Sdk.startWithApiToken(apiToken, options);
}
