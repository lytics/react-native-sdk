//
//  LyticsBridge.swift
//  Sdk
//
//  Created by Mathew Gacy on 9/24/23.
//  Copyright © 2023 Lytics Inc. All rights reserved.
//

import AnyCodable
import Foundation
import Lytics

@objc(LyticsBridge)
public final class LyticsBridge: NSObject {
    private let encoder: JSONEncoder
    private let lytics: Lytics

    public override init() {
        self.encoder = JSONEncoder()
        self.lytics = Lytics.shared
        super.init()
    }

    // MARK: - Properties

    @objc(hasStarted:rejecter:)
    public func hasStarted(
        resolver resolve: RCTPromiseResolveBlock,
        rejecter reject: RCTPromiseRejectBlock
    ) {
        resolve(lytics.hasStarted)
    }

    @objc(isOptedIn:rejecter:)
    public func isOptedIn(
        resolver resolve: RCTPromiseResolveBlock,
        rejecter reject: RCTPromiseRejectBlock
    ) {
        resolve(lytics.isOptedIn)
    }

    @objc(isTrackingEnabled:rejecter:)
    public func isTrackingEnabled(
        resolver resolve: RCTPromiseResolveBlock,
        rejecter reject: RCTPromiseRejectBlock
    ) {
        resolve(lytics.isIDFAEnabled)
    }

    @objc(user:rejecter:)
    public func user(
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        Task {
            let user = await lytics.user
            do {
                let dictionary = try convert(user)
                resolve(dictionary)
            } catch {
                reject("failure", error.localizedDescription, error)
            }
        }
    }

    // MARK: - Configuration

    @objc(start:resolver:rejecter:)
    public func start(
        configuration: [String: Any],
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        guard let apiToken = configuration["apiToken"] as? String else {
            reject("invalid_api_token", "Missing or Invalid API Token", nil)
            return
        }

        lytics.start(apiToken: apiToken) { lyticsConfig in
            if let urlString = configuration["collectionEndpoint"] as? String,
               let collectionEndpoint = URL(string: urlString) {
                lyticsConfig.collectionEndpoint = collectionEndpoint
            }

            if let urlString = configuration["entityEndpoint"] as? String,
               let entityEndpoint = URL(string: urlString) {
                lyticsConfig.entityEndpoint = entityEndpoint
            }

            if let defaultStream = configuration["defaultStream"] as? String {
                lyticsConfig.defaultStream = defaultStream
            }

            if let primaryIdentityKey = configuration["primaryIdentityKey"] as? String {
                lyticsConfig.primaryIdentityKey = primaryIdentityKey
            }

            if let anonymousIdentityKey = configuration["anonymousIdentityKey"] as? String {
                lyticsConfig.anonymousIdentityKey = anonymousIdentityKey
            }

            if let trackApplicationLifecycleEvents = configuration["trackApplicationLifecycleEvents"] as? Bool {
                lyticsConfig.trackApplicationLifecycleEvents = trackApplicationLifecycleEvents
            }

            if let uploadInterval = configuration["uploadInterval"] as? Double {
                lyticsConfig.uploadInterval = uploadInterval
            }

            if let maxQueueSize = configuration["maxQueueSize"] as? Int {
                lyticsConfig.maxQueueSize = maxQueueSize
            }

            if let maxUploadRetryAttempts = configuration["maxUploadRetryAttempts"] as? Int {
                lyticsConfig.maxUploadRetryAttempts = maxUploadRetryAttempts
            }

            if let sessionDuration = configuration["sessionDuration"] as? Double {
                lyticsConfig.sessionDuration = sessionDuration
            }

            if let enableSandbox = configuration["enableSandbox"] as? Bool {
                lyticsConfig.enableSandbox = enableSandbox
            }

            if let requireConsent = configuration["requireConsent"] as? Bool {
                lyticsConfig.requireConsent = requireConsent
            }

            if let logLevel = configuration["logLevel"] as? Int {
                switch logLevel {
                // .verbose, .debug
                case 0, 1:
                    lyticsConfig.logLevel = .debug
                case 2:
                    lyticsConfig.logLevel = .info
                // .warning, .error
                case 3, 4:
                    lyticsConfig.logLevel = .error
                case 5:
                    lyticsConfig.logLevel = .none
                default:
                    break
                }
            }

            if let defaultTable = configuration["defaultTable"] as? String {
                lyticsConfig.defaultTable = defaultTable
            }
            resolve(())
        }
    }

    // MARK: - Events

    @objc(track:name:identifiers:properties:)
    public func track(
        stream: String?,
        name: String?,
        identifiers: [String: Any],
        properties: [String: Any]
    ) {
        lytics.track(
            stream: stream,
            name: name,
            identifiers: AnyCodable(identifiers),
            properties: AnyCodable(properties))
    }

    @objc(identify:name:identifiers:attributes:shouldSend:)
    public func identify(
        stream: String?,
        name: String?,
        identifiers: [String: Any],
        attributes: [String: Any],
        shouldSend: Bool = true
    ) {
        lytics.identify(
            stream: stream,
            name: name,
            identifiers: AnyCodable(identifiers),
            attributes: AnyCodable(attributes),
            shouldSend: shouldSend)
    }

    @objc(consent:name:identifiers:attributes:consent:shouldSend:)
    public func consent(
        stream: String?,
        name: String?,
        identifiers: [String: Any],
        attributes: [String: Any],
        consent: [String: Any],
        shouldSend: Bool = true
    ) {
        lytics.consent(
            stream: stream,
            name: name,
            identifiers: AnyCodable(identifiers),
            attributes: AnyCodable(attributes),
            consent: AnyCodable(consent))
    }

    @objc(screen:name:identifiers:properties:)
    public func screen(
        stream: String?,
        name: String?,
        identifiers: [String: Any],
        properties: [String: Any]
    ) {
        lytics.screen(
            stream: stream,
            name: name,
            identifiers: AnyCodable(identifiers),
            properties: AnyCodable(properties))
    }

    // MARK: - Personalization

    @objc(getProfile:identifierValue:resolver:rejecter:)
    public func getProfile(
        identifierName: String?,
        identifierValue: String?,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        Task {
            do {
                var identifier: EntityIdentifier?
                if let identifierName, let identifierValue {
                    identifier = EntityIdentifier(
                        name: identifierName,
                        value: identifierValue)
                }
                let profile = try await lytics.getProfile(identifier)
                let dictionary = try convert(profile)
                resolve(dictionary)
            } catch {
                reject("failure", error.localizedDescription, error)
            }
        }
    }

    // MARK: - Tracking

    @objc
    public func optIn() {
        lytics.optIn()
    }

    @objc
    public func optOut() {
        lytics.optOut()
    }

    @objc(requestTrackingAuthorization:rejecter:)
    public func requestTrackingAuthorization(
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        Task {
            resolve(await lytics.requestTrackingAuthorization())
        }
    }

    @objc
    public func disableTracking() {
        lytics.disableTracking()
    }

    // MARK: - Utility

    @objc(identifier:rejecter:)
    public func identifier(
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        resolve(lytics.identifier())
    }

    @objc
    public func dispatch() {
        lytics.dispatch()
    }

    @objc
    public func reset() {
        lytics.reset()
    }

    @objc
    public func removeIdentifier(_ path: String) {
        lytics.removeIdentifier(DictionaryPath(path))
    }

    @objc
    public func removeAttribute(_ path: String) {
        lytics.removeAttribute(DictionaryPath(path))
    }
}

// MARK: - Helpers
private extension LyticsBridge {
    func convert<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try JSONEncoder().encode(value)
        guard let dictionary = try JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        ) as? [String: Any]
        else {
            throw EncodingError.invalidValue(
                T.self,
                .init(
                    codingPath: [],
                    debugDescription: "Unable to create a dictionary from \(value)."
                )
            )
        }

        return dictionary
    }
}
