package wang.runsheng.phonecheck;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {

    private static final String PACKAGE_NAME = "wang.runsheng.phonecheck";

    private static final String CHANNEL = "wang.runsheng.test/android";
    private static final String CHARGING_CHANNEL = "wang.runsheng.test/charging";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.equals("totalInternalMemorySize")) {
                    String totalInternalMemorySize = FileUtils.getTotalInternalMemorySize(MainActivity.this);
                    result.success(totalInternalMemorySize);
                }
                if (methodCall.method.equals("testCall")) {
                    Intent intent = new Intent("android.intent.action.CALL", Uri.parse("tel:114"));
                    startActivityForResult(intent, 1001);
                }
            }
        });

        new EventChannel(getFlutterView(), CHARGING_CHANNEL).setStreamHandler(
                new EventChannel.StreamHandler() {
                    private BroadcastReceiver chargingStateChangeReceiver;

                    @Override
                    public void onListen(Object o, EventChannel.EventSink eventSink) {
                        chargingStateChangeReceiver = createChargingStateChangeReceiver(eventSink);

                        registerReceiver(chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
                    }

                    @Override
                    public void onCancel(Object o) {
                        unregisterReceiver(chargingStateChangeReceiver);
                        chargingStateChangeReceiver = null;
                    }
                }
        );
    }

    private BroadcastReceiver createChargingStateChangeReceiver(final EventChannel.EventSink eventSink) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

                if (status == BatteryManager.BATTERY_STATUS_UNKNOWN) {
                    eventSink.error("UNAVAILABLE", "Charging status unavailable", null);
                } else {
                    boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL;
                    eventSink.success(isCharging ? "charging" : "discharging");
                }
            }
        };
    }

    private IntentFilter createLocalIntentFilter() {
        IntentFilter localIntentFilter = new IntentFilter();
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.shake_action");

        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.mic_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.loudspeaker_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.gps_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.compass_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.wifi_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.gseneor_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.GYRseneor_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.flashLight_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.frontCamera_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.receiver_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.backCamera_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.call_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.electricize_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.backCamera_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.screenSensitive_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.display_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.onDestroy");
        localIntentFilter.addAction(PACKAGE_NAME + ".AppContext.ps_action");
        return localIntentFilter;
    }

}
