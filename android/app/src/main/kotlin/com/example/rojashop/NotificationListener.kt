package com.example.rojashop

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.io.IOException

class NotificationListener : NotificationListenerService() {
    companion object {
        var channel: MethodChannel? = null
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val packageName = sbn.packageName
        val id = sbn.id
        val tag = sbn.tag
        val postTime = sbn.postTime
        val channelId = sbn.notification.channelId
        val extras: Bundle = sbn.notification.extras
        val title = extras.getString("android.title")
        val text = extras.getString("android.text")
        val subText = extras.getString("android.subText")
        val infoText = extras.getString("android.infoText")
        val bigText = extras.getString("android.bigText")
        val summaryText = extras.getString("android.summaryText")

        val data = hashMapOf<String, Any?>(
            "packageName" to packageName,
            "id" to id,
            "tag" to tag,
            "postTime" to postTime,
            "channelId" to channelId,
            "title" to title,
            "text" to text,
            "subText" to subText,
            "infoText" to infoText,
            "bigText" to bigText,
            "summaryText" to summaryText
        )

        channel?.invokeMethod("onNotification", data)
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        // Optionally handle notification removal
    }
}
