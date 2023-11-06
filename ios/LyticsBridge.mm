//
//  LyticsBridge.mm
//  Sdk
//
//  Created by Mathew Gacy on 10/13/23.
//  Copyright © 2023 Lytics Inc. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(LyticsBridge, NSObject)

#pragma mark - Properties

RCT_EXTERN_METHOD(hasStartedWithResolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(isOptedInResolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(isIDFAEnabledWithResolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(userWithResolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

#pragma mark - Configuration

RCT_EXTERN_METHOD(startWithApiToken:(NSString *) apiToken
                  configuration:(NSDictionary<NSString *,id> *) configuration)

#pragma mark - Events

RCT_EXTERN_METHOD(trackWithStream:(NSString *) stream
                  name:(NSString *) name
                  identifiers:(NSDictionary<NSString *,id> *) identifiers
                  properties:(NSDictionary<NSString *,id> *) properties)

RCT_EXTERN_METHOD(identifyWithStream:(NSString *) stream
                  name:(NSString *) name
                  identifiers:(NSDictionary<NSString *,id> *) identifiers
                  attributes:(NSDictionary<NSString *,id> *) attributes
                  shouldSend:(BOOL) shouldSend)


RCT_EXTERN_METHOD(consentWithStream:(NSString *) stream
                  name:(NSString *) name
                  identifiers:(NSDictionary<NSString *,id> *) identifiers
                  attributes:(NSDictionary<NSString *,id> *) attributes
                  consent:(NSDictionary<NSString *,id> *) consent
                  shouldSend:(BOOL) shouldSend)

RCT_EXTERN_METHOD(screenWithStream:(NSString *) stream
                  name:(NSString *) name
                  identifiers:(NSDictionary<NSString *,id> *) identifiers
                  properties:(NSDictionary<NSString *,id> *) properties)

#pragma mark - Personalization

RCT_EXTERN_METHOD(getProfileWithResolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getProfileWithIdentifierName:(NSString *) identifierName
                  identifierValue:(NSString *) identifierValue
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

#pragma mark - Tracking

RCT_EXTERN_METHOD(optIn)

RCT_EXTERN_METHOD(optOut)

RCT_EXTERN_METHOD(requestTrackingAuthorizationWithResolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(disableTracking)

#pragma mark - Utility

RCT_EXTERN_METHOD(identifierWithResolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(dispatch)

RCT_EXTERN_METHOD(reset)

RCT_EXTERN_METHOD(dispatch)

RCT_EXTERN_METHOD(removeIdentifier:(NSString *) path)

RCT_EXTERN_METHOD(removeAttribute:(NSString *) path)

#pragma mark - React Native

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end