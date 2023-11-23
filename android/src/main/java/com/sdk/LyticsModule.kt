package com.sdk

import android.content.Context
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.lytics.android.EntityIdentifier
import com.lytics.android.events.LyticsConsentEvent
import com.lytics.android.events.LyticsEvent
import com.lytics.android.events.LyticsIdentityEvent
import com.lytics.android.logging.LogLevel
import com.lytics.android.Lytics
import com.lytics.android.LyticsConfiguration
import java.util.concurrent.TimeUnit
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

class LyticsModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {

    private val context: Context

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    init {
        context = reactContext.applicationContext
    }

    override fun getName(): String {
        return NAME
    }

    // Properties

    @ReactMethod
    fun hasStarted(promise: Promise) {
        // TODO: implement
        promise.resolve(true)
    }

    @ReactMethod
    fun isOptedIn(promise: Promise) {
        promise.resolve(Lytics.isOptedIn)
    }

    @ReactMethod
    fun isTrackingEnabled(promise: Promise) {
        // TODO: change to ` isGAIDEnabled` after package updated
        promise.resolve(Lytics.isIDFAEnabled)
    }

    @ReactMethod
    fun user(promise: Promise) {
        promise.resolve(Lytics.currentUser?.toHashMap())
    }

    // Configuration

    @ReactMethod
    fun start(apiToken: String, options: ReadableMap) {
        val uploadInterval = options.getDoubleOrNull("uploadInterval") ?: DEFAULT_UPLOAD_INTERVAL
        val sessionTimeout = options.getDoubleOrNull("sessionTimeout") ?: DEFAULT_SESSION_TIMEOUT
        val requestTimeout =
            options.getDoubleOrNull("networkRequestTimeout") ?: DEFAULT_NETWORK_REQUEST_TIMEOUT
        val logLevel =
            options.getString("logLevel")?.let { LogLevel::class.byNameIgnoreCaseOrNull(it) }
                ?: LogLevel.NONE

        val config = LyticsConfiguration(
            apiKey = apiToken,
            defaultStream = options.getString("defaultStream") ?: DEFAULT_STREAM,
            primaryIdentityKey = options.getString("primaryIdentityKey")
                ?: LyticsConfiguration.DEFAULT_PRIMARY_IDENTITY_KEY,
            anonymousIdentityKey = options.getString("anonymousIdentityKey")
                ?: LyticsConfiguration.DEFAULT_ANONYMOUS_IDENTITY_KEY,
            defaultTable = options.getString("defaultTable")
                ?: LyticsConfiguration.DEFAULT_ENTITY_TABLE,
            requireConsent = options.getBooleanOrNull("requireConsent") ?: false,
            autoTrackActivityScreens = options.getBooleanOrNull("autoTrackActivityScreens")
                ?: false,
            autoTrackFragmentScreens = options.getBooleanOrNull("autoTrackFragmentScreens")
                ?: false,
            autoTrackAppOpens = options.getBooleanOrNull("autoTrackAppOpens") ?: false,
            maxQueueSize = options.getIntOrNull("maxQueueSize") ?: DEFAULT_MAX_QUEUE_SIZE,
            maxUploadRetryAttempts = options.getIntOrNull("maxUploadRetryAttempts")
                ?: DEFAULT_MAX_UPLOAD_RETRY_ATTEMPTS,
            maxLoadRetryAttempts = options.getIntOrNull("maxLoadRetryAttempts")
                ?: DEFAULT_MAX_LOAD_RETRY_ATTEMPTS,
            uploadInterval = TimeUnit.SECONDS.toMillis(uploadInterval.toLong()),
            sessionTimeout = TimeUnit.MINUTES.toMillis(sessionTimeout.toLong()),
            logLevel = logLevel,
            sandboxMode = options.getBooleanOrNull("sandboxMode") ?: false,
            collectionEndpoint = options.getString("collectionEndpoint")
                ?: LyticsConfiguration.DEFAULT_COLLECTION_ENDPOINT,
            entityEndpoint = options.getString("entityEndpoint")
                ?: LyticsConfiguration.DEFAULT_ENTITY_ENDPOINT,
            networkRequestTimeout = TimeUnit.SECONDS.toMillis(requestTimeout.toLong()).toInt()
        )

        Lytics.init(context = context, configuration = config)
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

    // Personalization

    @ReactMethod
    fun getProfile(promise: Promise) {
        getProfile(
            identifier = null,
            promise = promise
        )
    }

    @ReactMethod
    fun getProfile(name: String, value: String, promise: Promise) {
        getProfile(
            identifier = EntityIdentifier(name = name, value = value),
            promise = promise
        )
    }

    private fun getProfile(identifier: EntityIdentifier?, promise: Promise) {
        scope.launch {
            promise.resolve(Lytics.getProfile(identifier)?.toHashMap())
        }
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

    @ReactMethod
    fun requestTrackingAuthorization(promise: Promise) {
        // TODO: change to `enableGAID()` after package updated
        Lytics.enableIDFA()
        promise.resolve(true)
    }

    @ReactMethod
    fun disableTracking() {
        // TODO: change to `disableGAID()` after package updated
        Lytics.disableIDFA()
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
        const val DEFAULT_MAX_LOAD_RETRY_ATTEMPTS = 1
        const val DEFAULT_MAX_QUEUE_SIZE = 10
        const val DEFAULT_MAX_UPLOAD_RETRY_ATTEMPTS = 3
        const val DEFAULT_NETWORK_REQUEST_TIMEOUT = 30.0
        const val DEFAULT_SESSION_TIMEOUT = 20.0
        const val DEFAULT_STREAM = "android_sdk"
        const val DEFAULT_UPLOAD_INTERVAL = 10.0
    }
}
