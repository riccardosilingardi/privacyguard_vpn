package com.privacyguard_vpn.app.vpn

import android.app.Activity
import android.content.Intent
import android.net.VpnService
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class VpnMethodChannel(
    private val activity: Activity
) : MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {

    companion object {
        private const val TAG = "VpnMethodChannel"
        const val CHANNEL_NAME = "com.privacyguard.vpn/vpn"
        private const val VPN_REQUEST_CODE = 2024

        private const val METHOD_CONNECT = "connect"
        private const val METHOD_DISCONNECT = "disconnect"
        private const val METHOD_GET_STATUS = "getStatus"
        private const val METHOD_GET_STATS = "getStats"
        private const val METHOD_REQUEST_PERMISSION = "requestPermission"
    }

    private var pendingResult: MethodChannel.Result? = null
    private var pendingConfig: String? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_CONNECT -> {
                val config = call.argument<String>("config")
                if (config != null) {
                    connectVpn(config, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Config is required", null)
                }
            }

            METHOD_DISCONNECT -> {
                disconnectVpn(result)
            }

            METHOD_GET_STATUS -> {
                getStatus(result)
            }

            METHOD_GET_STATS -> {
                getStats(result)
            }

            METHOD_REQUEST_PERMISSION -> {
                requestVpnPermission(result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun connectVpn(config: String, result: MethodChannel.Result) {
        try {
            // Check if VPN permission is granted
            val prepareIntent = VpnService.prepare(activity)

            if (prepareIntent != null) {
                // Need to request permission
                pendingResult = result
                pendingConfig = config
                activity.startActivityForResult(prepareIntent, VPN_REQUEST_CODE)
            } else {
                // Permission already granted, start VPN
                startVpnService(config)
                result.success(mapOf(
                    "success" to true,
                    "message" to "VPN connection initiated"
                ))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error connecting VPN", e)
            result.error("VPN_ERROR", e.message, null)
        }
    }

    private fun disconnectVpn(result: MethodChannel.Result) {
        try {
            val intent = Intent(activity, PrivacyGuardVpnService::class.java).apply {
                action = PrivacyGuardVpnService.ACTION_DISCONNECT
            }
            activity.stopService(intent)

            result.success(mapOf(
                "success" to true,
                "message" to "VPN disconnected"
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Error disconnecting VPN", e)
            result.error("VPN_ERROR", e.message, null)
        }
    }

    private fun getStatus(result: MethodChannel.Result) {
        try {
            val status = if (PrivacyGuardVpnService.isRunning) {
                "connected"
            } else {
                "disconnected"
            }

            result.success(mapOf(
                "status" to status,
                "isRunning" to PrivacyGuardVpnService.isRunning
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Error getting status", e)
            result.error("VPN_ERROR", e.message, null)
        }
    }

    private fun getStats(result: MethodChannel.Result) {
        try {
            // Note: In production, get actual stats from service
            // For now, return mock stats
            result.success(mapOf(
                "bytesIn" to 0L,
                "bytesOut" to 0L,
                "durationSeconds" to 0L,
                "speed" to 0
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Error getting stats", e)
            result.error("VPN_ERROR", e.message, null)
        }
    }

    private fun requestVpnPermission(result: MethodChannel.Result) {
        try {
            val prepareIntent = VpnService.prepare(activity)

            if (prepareIntent != null) {
                pendingResult = result
                activity.startActivityForResult(prepareIntent, VPN_REQUEST_CODE)
            } else {
                result.success(mapOf(
                    "granted" to true,
                    "message" to "VPN permission already granted"
                ))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error requesting permission", e)
            result.error("PERMISSION_ERROR", e.message, null)
        }
    }

    private fun startVpnService(config: String) {
        val intent = Intent(activity, PrivacyGuardVpnService::class.java).apply {
            action = PrivacyGuardVpnService.ACTION_CONNECT
            putExtra(PrivacyGuardVpnService.EXTRA_CONFIG, config)
        }
        activity.startService(intent)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == VPN_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                // Permission granted
                if (pendingConfig != null) {
                    startVpnService(pendingConfig!!)
                    pendingResult?.success(mapOf(
                        "success" to true,
                        "message" to "VPN permission granted, connecting..."
                    ))
                } else {
                    pendingResult?.success(mapOf(
                        "granted" to true,
                        "message" to "VPN permission granted"
                    ))
                }
            } else {
                // Permission denied
                pendingResult?.error(
                    "PERMISSION_DENIED",
                    "VPN permission was denied by user",
                    null
                )
            }

            pendingResult = null
            pendingConfig = null
            return true
        }
        return false
    }
}
