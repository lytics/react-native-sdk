//
//  LyticsBridge.mm
//  Sdk
//
//  Created by Mathew Gacy on 10/13/23.
//  Copyright © 2023 Lytics Inc. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(LyticsBridge, NSObject)

RCT_EXTERN_METHOD(multiply:(float)a withB:(float)b
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

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

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
