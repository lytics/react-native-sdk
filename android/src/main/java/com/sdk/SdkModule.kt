package com.sdk

import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

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
    }

    companion object {
        const val NAME = "LyticsBridge"
    }
}
