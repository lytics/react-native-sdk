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
    
    @objc
    public func hasStarted(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        resolve(lytics.hasStarted)
    }

    @objc
    public func isOptedIn(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        resolve(lytics.isOptedIn)
    }

    @objc
    public func isIDFAEnabled(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        resolve(lytics.isIDFAEnabled)
    }

    @objc
    public func user(
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
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

    @objc
    public func start(
        apiToken: String,
        configuration: [String: Any]?
    ) {
        lytics.start(apiToken: apiToken) { lyticsConfig in
            guard let configuration, !configuration.isEmpty else {
                return
            }

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

            // skipping `.trackApplicationLifecycleEvents`

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

            // TODO: do `Bool`s work as expected?
            if let enableSandbox = configuration["enableSandbox"] as? Bool {
                lyticsConfig.enableSandbox = enableSandbox
            }

            if let requireConsent = configuration["requireConsent"] as? Bool {
                lyticsConfig.requireConsent = requireConsent
            }

            if let logLevel = configuration["logLevel"] as? String {
                switch logLevel {
                case "debug":
                    lyticsConfig.logLevel = .debug
                case "info":
                    lyticsConfig.logLevel = .info
                case "error":
                    lyticsConfig.logLevel = .error
                case "none":
                    lyticsConfig.logLevel = .none
                default:
                    break
                }
            }

            if let defaultTable = configuration["defaultTable"] as? String {
                lyticsConfig.defaultTable = defaultTable
            }
        }
    }

    // MARK: - Events

    @objc
    public func track(
        stream: String? = nil,
        name: String? = nil,
        identifiers: [String: Any],
        properties: [String: Any]
    ) {
        lytics.track(
            stream: stream,
            name: name,
            identifiers: AnyCodable(identifiers),
            properties: AnyCodable(properties))
    }

    @objc
    public func identify(
        stream: String? = nil,
        name: String? = nil,
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

    @objc
    public func consent(
        stream: String? = nil,
        name: String? = nil,
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

    @objc
    public func screen(
        stream: String? = nil,
        name: String? = nil,
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

    @objc
    public func getProfile(
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        Task {
            do {
                let profile = try await lytics.getProfile()
                let dictionary = try convert(profile)
                resolve(dictionary)
            } catch {
                reject("failure", error.localizedDescription, error)
            }
        }
    }

    @objc
    public func getProfile(
        identifierName: String,
        identifierValue: String,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        Task {
            do {
                let profile = try await lytics.getProfile(
                    EntityIdentifier(
                        name: identifierName,
                        value: identifierValue))
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

    @objc
    public func requestTrackingAuthorization(
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
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

    @objc
    public func identifier(
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
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
