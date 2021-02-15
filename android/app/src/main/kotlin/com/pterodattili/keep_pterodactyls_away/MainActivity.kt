package com.pterodattili.keep_pterodactyls_away

import io.flutter.embedding.android.FlutterActivity

import android.content.Context
import android.os.Build
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.app.NotificationManager
import android.app.NotificationChannel
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Random

class MainActivity: FlutterActivity() {
    private val CHANNEL = "notification"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        call, result ->
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val name = getString(R.string.app_name)
                val descriptionText = getString(R.string.app_name)
                val importance = NotificationManager.IMPORTANCE_DEFAULT
                val channel = NotificationChannel("0", name, importance).apply {
                    description = descriptionText
                }
                // Register the channel with the system
                val notificationManager: NotificationManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.createNotificationChannel(channel)
            }

            if (call.method == "sendNotification") {
                val value: String? = call.argument("value")

                if (value != null) {
                    val notificationId = sendNotification(value)

                    result.success(notificationId)
                }
            }
        }
    }

    private fun sendNotification(value: String): Int {
        val notificationId = Random().nextInt(100)

        var builder = NotificationCompat.Builder(this, "0")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Title" + value)
            .setContentText("Content")
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)

        with(NotificationManagerCompat.from(this)) {
            notify(notificationId, builder.build())
        }

        return notificationId
    }
}
