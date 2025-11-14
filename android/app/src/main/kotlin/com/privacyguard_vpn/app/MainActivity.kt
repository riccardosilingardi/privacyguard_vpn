package com.privacyguard_vpn.app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.privacyguard_vpn.app.vpn.VpnMethodChannel

class MainActivity: FlutterActivity() {

    private lateinit var vpnMethodChannel: VpnMethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize VPN Method Channel
        vpnMethodChannel = VpnMethodChannel(this)

        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            VpnMethodChannel.CHANNEL_NAME
        )

        channel.setMethodCallHandler(vpnMethodChannel)

        // Register for activity results
        addActivityResultListener(vpnMethodChannel)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        vpnMethodChannel.onActivityResult(requestCode, resultCode, data)
    }
}
