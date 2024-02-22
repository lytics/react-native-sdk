package com.lytics.react_native

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.lytics.android.LyticsUser
import com.lytics.android.logging.LogLevel
import kotlin.reflect.KClass

fun ReadableMap.getBooleanOrNull(key: String): Boolean? {
    return if (this.hasKey(key)) {
        this.getBoolean(key)
    } else {
        null
    }
}

fun ReadableMap.getDoubleOrNull(key: String): Double? {
    return if (this.hasKey(key)) {
        this.getDouble(key)
    } else {
        null
    }
}

fun ReadableMap.getIntOrNull(key: String): Int? {
    return if (this.hasKey(key)) {
        this.getInt(key)
    } else {
        null
    }
}

fun KClass<LogLevel>.fromLevelOrNull(level: Int): LogLevel? {
    return LogLevel.values().firstOrNull { it.ordinal == level }
}

fun LyticsUser.toReadableMap(): ReadableMap {
    val readableMap = Arguments.createMap()
    this.identifiers?.let {
        readableMap.putMap("identifiers", createReadableMapFromMap(it))
    }
    this.attributes?.let {
        readableMap.putMap("attributes", createReadableMapFromMap(it))
    }
    this.consent?.let {
        readableMap.putMap("consent", createReadableMapFromMap(it))
    }
    this.profile?.let {
        readableMap.putMap("profile", createReadableMapFromMap(it))
    }
    return readableMap
}

fun createReadableMapFromMap(map: Map<String, Any?>): ReadableMap = Arguments.createMap().apply {
    map.forEach { (key, value) ->
        when (value) {
            is Int -> putInt(key, value)
            is Double -> putDouble(key, value)
            is String -> putString(key, value)
            is Boolean -> putBoolean(key, value)
            is Map<*, *> -> putMap(key, createReadableMapFromMap(value as Map<String, Any?>))
            is List<*> -> putArray(key, createReadableArrayFromList(value))
            else -> putNull(key)
        }
    }
}

fun createReadableArrayFromList(list: List<*>): ReadableArray = Arguments.createArray().apply {
    list.forEach { item ->
        when (item) {
            is Int -> pushInt(item)
            is Double -> pushDouble(item)
            is String -> pushString(item)
            is Boolean -> pushBoolean(item)
            is Map<*, *> -> pushMap(createReadableMapFromMap(item as Map<String, Any?>))
            is List<*> -> pushArray(createReadableArrayFromList(item))
            else -> pushNull()
        }
    }
}
