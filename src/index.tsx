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
  verbose,
  debug,
  info,
  warning,
  error,
  none,
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

export type JSONValue =
  | boolean
  | number
  | string
  | null
  | JSONValue[]
  | JSONMap;

export type JSONMap = {
  [key: string]: JSONValue;
};

export type LyticsUser = {
  identifiers?: JSONMap;
  attributes?: JSONMap;
  consent?: JSONMap;
  profile?: JSONMap;
};

// Properties

export function hasStarted(): Promise<boolean> {
  return Sdk.hasStarted();
}

export function isOptedIn(): Promise<boolean> {
  return Sdk.isOptedIn();
}

export function isTrackingEnabled(): Promise<boolean> {
  return Sdk.isTrackingEnabled();
}

export function user(): Promise<LyticsUser> {
  return Sdk.user();
}

// Configuration

export function start(apiToken: string, options: LyticsConfiguration) {
  Sdk.start(apiToken, options);
}

// Events
export interface TrackParams {
  stream?: string;
  name?: string;
  identifiers?: JSONMap;
  properties?: JSONMap;
}

export function track(params: TrackParams) {
  Sdk.track(params.stream, params.name, params.identifiers, params.properties);
}

export interface IdentifyParams {
  stream?: string;
  name?: string;
  identifiers?: JSONMap;
  attributes?: JSONMap;
  shouldSend?: boolean;
}

export function identify(params: IdentifyParams) {
  Sdk.identify(
    params.stream,
    params.name,
    params.identifiers,
    params.attributes,
    params.shouldSend ?? true
  );
}

export interface ConsentParams {
  stream?: string;
  name?: string;
  identifiers?: JSONMap;
  attributes?: JSONMap;
  consent?: JSONMap;
  shouldSend?: boolean;
}

export function consent(params: ConsentParams) {
  Sdk.consent(
    params.stream,
    params.name,
    params.identifiers,
    params.attributes,
    params.consent,
    params.shouldSend ?? true
  );
}

export interface ScreenParams {
  stream?: string;
  name?: string;
  identifiers?: JSONMap;
  properties?: JSONMap;
}

export function screen(params: ScreenParams) {
  Sdk.screen(params.stream, params.name, params.identifiers, params.properties);
}

// Personalization

export type EntityIdentifier = {
  name: string;
  value: string;
};

export function getProfile(identifier?: EntityIdentifier): Promise<LyticsUser> {
  return Sdk.getProfile(identifier?.name, identifier?.value);
}

// Tracking

export function optIn() {
  Sdk.optIn();
}

export function optOut() {
  Sdk.optOut();
}

export function requestTrackingAuthorization(): Promise<boolean> {
  return Sdk.requestTrackingAuthorization();
}

export function disableTracking() {
  Sdk.disableTracking();
}

// Utility

export function identifier(): Promise<string> {
  return Sdk.identifier();
}

export function dispatch() {
  Sdk.dispatch();
}

export function reset() {
  Sdk.reset();
}
