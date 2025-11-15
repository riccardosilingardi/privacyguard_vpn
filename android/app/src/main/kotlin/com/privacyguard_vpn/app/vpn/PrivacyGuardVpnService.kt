package com.privacyguard_vpn.app.vpn

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.util.Log
import com.wireguard.android.backend.Tunnel
import com.wireguard.config.Config
import com.wireguard.config.InetNetwork
import com.wireguard.config.Interface
import com.wireguard.config.Peer
import kotlinx.coroutines.*
import java.io.FileInputStream
import java.io.FileOutputStream
import java.net.InetAddress

class PrivacyGuardVpnService : VpnService() {

    companion object {
        private const val TAG = "PrivacyGuardVPN"
        private const val NOTIFICATION_CHANNEL_ID = "vpn_channel"
        private const val NOTIFICATION_ID = 1

        var isRunning = false
            private set

        var currentConfig: String? = null
            private set
    }

    private var vpnInterface: ParcelFileDescriptor? = null
    private val serviceScope = CoroutineScope(Dispatchers.IO + Job())

    private var bytesIn: Long = 0
    private var bytesOut: Long = 0
    private var startTime: Long = 0

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        Log.d(TAG, "VPN Service created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_CONNECT -> {
                val config = intent.getStringExtra(EXTRA_CONFIG)
                if (config != null) {
                    connect(config)
                } else {
                    Log.e(TAG, "No config provided")
                    stopSelf()
                }
            }
            ACTION_DISCONNECT -> {
                disconnect()
            }
        }
        return START_STICKY
    }

    private fun connect(configString: String) {
        try {
            Log.d(TAG, "Connecting to VPN...")

            currentConfig = configString
            startTime = System.currentTimeMillis()

            // Start foreground service with notification
            startForeground(NOTIFICATION_ID, createNotification("Connecting..."))

            // Establish VPN
            establishVpn(configString)

            isRunning = true

            // Update notification
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.notify(NOTIFICATION_ID, createNotification("Connected"))

            Log.d(TAG, "VPN Connected successfully")

        } catch (e: Exception) {
            Log.e(TAG, "Failed to connect VPN", e)
            disconnect()
        }
    }

    private fun establishVpn(configString: String) {
        // Parse WireGuard config
        val config = parseWireGuardConfig(configString)

        // Build VPN interface
        val builder = Builder()
            .setSession("PrivacyGuard VPN")
            .setMtu(1420)

        // Add addresses
        config.addresses.forEach { address ->
            builder.addAddress(address.address, address.mask)
        }

        // Add DNS servers
        config.dnsServers.forEach { dns ->
            builder.addDnsServer(dns)
        }

        // Add routes
        builder.addRoute("0.0.0.0", 0)

        // Set blocking mode
        builder.setBlocking(false)

        // Establish VPN
        vpnInterface = builder.establish()

        if (vpnInterface != null) {
            // Start packet handling
            startPacketHandling()
        } else {
            throw Exception("Failed to establish VPN interface")
        }
    }

    private fun parseWireGuardConfig(configString: String): WgConfig {
        // Simple WireGuard config parser
        val addresses = mutableListOf<InetNetwork>()
        val dnsServers = mutableListOf<InetAddress>()

        // Default values if config is simple
        // In production, parse full WireGuard config format
        addresses.add(InetNetwork.parse("10.8.0.2/24"))
        dnsServers.add(InetAddress.getByName("1.1.1.1"))
        dnsServers.add(InetAddress.getByName("1.0.0.1"))

        return WgConfig(addresses, dnsServers)
    }

    private fun startPacketHandling() {
        serviceScope.launch {
            try {
                val input = FileInputStream(vpnInterface!!.fileDescriptor)
                val output = FileOutputStream(vpnInterface!!.fileDescriptor)

                val buffer = ByteArray(32767)

                while (isActive && vpnInterface != null) {
                    val length = input.read(buffer)
                    if (length > 0) {
                        // Track bytes
                        bytesIn += length

                        // In production:
                        // 1. Parse packet headers
                        // 2. Check against tracker/ad block lists
                        // 3. Encrypt and forward allowed packets

                        // For now, just forward packets
                        output.write(buffer, 0, length)
                        bytesOut += length
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Packet handling error", e)
            }
        }
    }

    private fun disconnect() {
        Log.d(TAG, "Disconnecting VPN...")

        try {
            vpnInterface?.close()
            vpnInterface = null

            serviceScope.coroutineContext.cancelChildren()

            isRunning = false
            currentConfig = null

            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()

            Log.d(TAG, "VPN Disconnected")
        } catch (e: Exception) {
            Log.e(TAG, "Error disconnecting VPN", e)
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "VPN Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "PrivacyGuard VPN Connection Status"
                setShowBadge(false)
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(status: String): Notification {
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            packageManager.getLaunchIntentForPackage(packageName),
            PendingIntent.FLAG_IMMUTABLE
        )

        return Notification.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("PrivacyGuard VPN")
            .setContentText(status)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build()
    }

    fun getStats(): VpnStats {
        val duration = if (startTime > 0) {
            (System.currentTimeMillis() - startTime) / 1000
        } else {
            0
        }

        return VpnStats(
            bytesIn = bytesIn,
            bytesOut = bytesOut,
            durationSeconds = duration
        )
    }

    override fun onDestroy() {
        disconnect()
        serviceScope.cancel()
        super.onDestroy()
    }

    override fun onRevoke() {
        Log.d(TAG, "VPN permission revoked")
        disconnect()
        super.onRevoke()
    }

    data class WgConfig(
        val addresses: List<InetNetwork>,
        val dnsServers: List<InetAddress>
    )

    data class VpnStats(
        val bytesIn: Long,
        val bytesOut: Long,
        val durationSeconds: Long
    )

    companion object {
        const val ACTION_CONNECT = "com.privacyguard_vpn.ACTION_CONNECT"
        const val ACTION_DISCONNECT = "com.privacyguard_vpn.ACTION_DISCONNECT"
        const val EXTRA_CONFIG = "config"
    }
}
