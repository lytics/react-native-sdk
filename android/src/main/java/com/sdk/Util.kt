package com.sdk

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

fun KClass<LogLevel>.byNameIgnoreCaseOrNull(level: String): LogLevel? {
    return LogLevel.values().firstOrNull { it.name.equals(level, true) }
}

fun LyticsUser.toHashMap(): HashMap<String, Any?> {
    return hashMapOf(
        "identifiers" to this.identifiers,
        "attributes" to this.attributes,
        "consent" to this.consent,
        "profile" to this.profile
    )
}
