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

// Types

export enum LogLevel {
  error,
  warning,
  info,
  debug,
}

export type LyticsConfiguration = {
  collectionEndpoint?: URL;
  entityEndpoint?: URL;
  defaultStream?: string;
  primaryIdentityKey?: string;
  anonymousIdentityKey?: string;
  trackApplicationLifecycleEvents?: boolean;
  uploadInterval?: number;
  maxQueueSize?: number;
  maxLoadRetryAttempts?: number;
  maxUploadRetryAttempts?: number;
  sessionDuration?: number;
  enableSandbox?: boolean;
  requireConsent?: boolean;
  logLevel?: LogLevel;
  defaultTable?: string;
};

// Properties

export function hasStarted(): Promise<boolean> {
  return Sdk.hasStarted();
}

// Configuration

export type LyticsConfiguration = {
  [key: string]: any;
};

export function start(apiToken: string, options: LyticsConfiguration) {
  Sdk.start(apiToken, options);
}
