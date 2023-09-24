//
//  LyticsBridge.swift
//  Sdk
//
//  Created by Mathew Gacy on 9/24/23.
//  Copyright © 2023 Lytics Inc. All rights reserved.
//

@objc(LyticsBridge)
public final class LyticsBridge: NSObject {
    private let encoder: JSONEncoder

    public init(encoder: JSONEncoder = .init()) {
        self.encoder = encoder
    }

    // MARK: - Properties

    /// Returns a Boolean value indicating whether this instance has been started.
    @objc
    public func hasStarted() -> Bool {
        // ...
        true
    }

    /// Returns a Boolean value indicating whether the user has opted in to event collection.
    @objc
    public func isOptedIn() -> Bool {
        // ...
        true
    }

    /// Returns a Boolean value indicating whether IDFA is enabled.
    @objc
    public func isIDFAEnabled() -> Bool {
        // ...
        true
    }

    /// The current Lytics user.
    public func user() {
        Task {
            // ...
        }
    }

    // MARK: - Configuration

    @objc
    public func start(
        apiToken: String,
        configuration: [String: Any]?
    ) {
        if let urlString = configuration["collectionEndpoint"] as? String,
           let collectionEndpoint = URL(string: urlString) {
            // ...
        }

        if let urlString = configuration["entityEndpoint"] as? String,
           let entityEndpoint = URL(string: urlString) {
            // ...
        }

        if let defaultStream = configuration["defaultStream"] as? String {
            // ...
        }

        if let primaryIdentityKey = configuration["primaryIdentityKey"] as? String {
            // ...
        }

        if let anonymousIdentityKey = configuration["anonymousIdentityKey"] as? String {
            // ...
        }

        // skipping `.trackApplicationLifecycleEvents`

        if let uploadInterval = configuration["uploadInterval"] as? Double {
            // ...
        }

        if let maxQueueSize = configuration["maxQueueSize"] as? Int {
            // ...
        }

        if let maxUploadRetryAttempts = configuration["maxUploadRetryAttempts"] as? Int {
            // ...
        }

        if let sessionDuration = configuration["sessionDuration"] as? Double {
            // ...
        }

        // TODO: do `Bool`s work as expected?
        if let enableSandbox = configuration["enableSandbox"] as? Bool {
            // ...
        }

        if let requireConsent = configuration["requireConsent"] as? Bool {
            // ...
        }

        if let logLevel = configuration["logLevel"] as? String {
            switch logLevel {
            case "debug":
                config.logLevel = .debug
            case "info":
                config.logLevel = .info
            case "error":
                config.logLevel = .error
            case "none":
                config.logLevel = .none
            default:
                break
            }
        }

        if let defaultTable = configuration["defaultTable"] as? String {
            config.defaultTable = defaultTable
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
        // ...
    }

    @objc
    public func identify(
        stream: String? = nil,
        name: String? = nil,
        identifiers: [String: Any],
        attributes: [String: Any],
        shouldSend: Bool = true
    ) {
        // ...
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
        // ...
    }

    @objc
    public func screen(
        stream: String? = nil,
        name: String? = nil,
        identifiers: [String: Any],
        properties: [String: Any]
    ) {
        // ...
    }

    // MARK: - Personalization

    @objc
    public func getProfile(
        // TODO: add completion handler
    ) {
        Task {
            do {
                // TODO: call completion handler with result
            } catch {
                // TODO: call completion handler
            }
        }
    }

    @objc
    public func getProfile(
        identifierName: String,
        identifierValue: String
        // TODO: add completion handler
    ) {
        Task {
            do {
                // TODO: call completion handler with result
            } catch {
                // TODO: call completion handler
            }
        }
    }

    // MARK: - Tracking

    public func optIn() {
        // ...
    }

    public func optOut() {
        // ...
    }


    public func requestTrackingAuthorization(
        // TODO: add completion handler for `Bool`
    ) {
        Task {
            // TODO: call completion handler with result
        }
    }

    public func disableTracking() {
        // ...
    }

    // MARK: - Utility

    public func identifier(
        // TODO: add completion handler for `String` return value
    ) {
        // TODO: call completion handler with result
    }

    public func dispatch() {
        // ...
    }

    public func reset() {
        // ...
    }

    public func removeIdentifier(_ path: String) {
        // ...
    }

    public func removeAttribute(_ path: String) {
        // ...
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
