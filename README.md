# Lytics SDK for React Native

## Installation

Install the SDK:

```
yarn add react-native-sdk
# or
npm install --save react-native-sdk
```

### Android

Add the following permissions to your `AndroidManifest.xml` file:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

This permission is required to send events to the Lytics API.

```xml
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

This permission is technically optional but highly recommended to allow the library to determine the best time to send events to the API.

### iOS

Install native modules:

```sh
npx pod-install
```

## Configuration

You must initialize the Lytics SDK with your [API token](https://learn.lytics.com/documentation/product/features/account-management/managing-api-tokens) before using it.

```jsx
import { start } from 'react-native-sdk';

start({
  apiToken: 'xxxxxx',
  ...
});
```

## Sending Data

### Identity Events

Tracking identity events provides an interface for updating the current user's properties stored on device as well as emitting an identify event to the downstream collections API.

```jsx
import { identify } from 'react-native-sdk';

identify({ identifiers: { email: 'jdoe@email.com' } });
```

### Consent Events

Consent events provide an interface for configuring and emitting a special event that represents an app users explicit consent. This event does everything a normal event does in addition to providing a special payload for consent details at the discretion of the developer.

```jsx
import { consent } from 'react-native-sdk';

consent({
  consent: {
    documents: ['terms_aug_2022', 'privacy_may_2022'],
    consented: true,
  },
});
```

### Track Custom Events

Track custom events provides an interface for configuring and emitting a custom event at the customers discretion throughout their application (e.g. made a purchase or logged in).

```jsx
import { track } from 'react-native-sdk';

track({ name: 'Event_Tap', properties: { event: 'Event_Tap' } });
```

### Screen Events

Screen events provide an interface for configuring and emitting a special event that represents a screen or page view. It should be seen as an extension of the track method.

```jsx
import { screen } from 'react-native-sdk';

screen({
  name: 'Event_Detail',
  properties: { artistID: 123, eventID: 345 },
});
```

## Advertising ID

### Android

To support collecting the Android Advertising ID, add the following to the application's gradle dependencies:

`implementation 'com.google.android.gms:play-services-ads-identifier:18.0.1'`

Additionally, declare a Google Play services normal permission in the manifest file as follows:

`<uses-permission android:name="com.google.android.gms.permission.AD_ID"/>`

After confirming with the user and getting their consent, enable Advertiser ID collection via `Lytics.enableGAID()`.

The user's Android Advertising ID will be sent with each event's identifiers.

Note, the user can disable or change the Advertising ID via the Android system privacy settings.

### iOS

Before collecting the IDFA you must first add a [`NSUserTrackingUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsusertrackingusagedescription) to your app's `Info.plist`. You can then call `requestTrackingAuthorization()` to have iOS request authorization to access the IDFA. Note that the alert will not be displayed if the user has turned off “Allow Apps to Request to Track” in the system privacy settings and that authorization can be revoked at any time.

### Usage

```jsx
import { requestTrackingAuthorization } from 'react-native-sdk';

requestTrackingAuthorization();
```
