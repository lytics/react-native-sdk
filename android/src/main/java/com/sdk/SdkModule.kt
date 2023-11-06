package com.sdk

import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.lytics.android.events.LyticsConsentEvent
import com.lytics.android.events.LyticsEvent
import com.lytics.android.events.LyticsIdentityEvent
import com.lytics.android.logging.LogLevel
import com.lytics.android.Lytics
import com.lytics.android.LyticsConfiguration

class SdkModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return NAME
    }

    // Properties

    @ReactMethod
    fun hasStartedWithResolve(promise: Promise) {
        // TODO: implement
        promise.resolve(true)
    }

    // Configuration

    @ReactMethod
    fun startWithApiToken(apiToken: String, options: ReadableMap) {
        // TODO: implement
        val config = LyticsConfiguration(
            apiKey = apiToken,
        )
    }

    // Events

    @ReactMethod
    fun track(
        stream: String? = null,
        name: String? = null,
        identifiers: ReadableMap? = null,
        properties: ReadableMap? = null
    ) {
        Lytics.track(
            LyticsEvent(
                stream = stream,
                name = name,
                identifiers = identifiers?.toHashMap(),
                properties = properties?.toHashMap()
            )
        )
    }

    @ReactMethod
    fun identify(
        stream: String? = null,
        name: String? = null,
        identifiers: ReadableMap? = null,
        attributes: ReadableMap? = null,
        shouldSend: Boolean = true
    ) {
        Lytics.identify(
            LyticsIdentityEvent(
                stream = stream,
                name = name,
                identifiers = identifiers?.toHashMap(),
                attributes = attributes?.toHashMap(),
                sendEvent = shouldSend
            )
        )
    }

    @ReactMethod
    fun consent(
        stream: String? = null,
        name: String? = null,
        identifiers: ReadableMap? = null,
        attributes: ReadableMap? = null,
        consent: ReadableMap? = null,
        shouldSend: Boolean = true
    ) {
        Lytics.consent(
            LyticsConsentEvent(
                stream = stream,
                name = name,
                identifiers = identifiers?.toHashMap(),
                attributes = attributes?.toHashMap(),
                consent = consent?.toHashMap(),
                sendEvent = shouldSend
            )
        )
    }

    @ReactMethod
    fun screen(
        stream: String? = null,
        name: String? = null,
        identifiers: ReadableMap? = null,
        properties: ReadableMap? = null
    ) {
        Lytics.screen(
            LyticsEvent(
                stream = stream,
                name = name,
                identifiers = identifiers?.toHashMap(),
                properties = properties?.toHashMap()
            )
        )
    }

    // Tracking

    @ReactMethod
    fun optIn() {
        Lytics.optIn()
    }

    @ReactMethod
    fun optOut() {
        Lytics.optOut()
    }

    // Utility

    @ReactMethod
    fun dispatch() {
        Lytics.dispatch()
    }

    @ReactMethod
    fun reset() {
        Lytics.reset()
    }
    companion object {
        const val NAME = "LyticsBridge"
    }
}
