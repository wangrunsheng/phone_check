package wang.runsheng.phonecheck;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.AudioTrack;
import android.net.Uri;
import android.net.wifi.WifiManager;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Vibrator;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {

    private static final String PACKAGE_NAME = "wang.runsheng.phonecheck";

    private static final String CHANNEL = "wang.runsheng.test/android";
    private static final String CHARGING_CHANNEL = "wang.runsheng.test/charging";

    private RecordThread mRecordThread;

    private TestCountDownTimer mTestCountDownTimer;

    private TestReceiver mTestReceiver;

    EventChannel.EventSink mEventSink;

    private boolean isWifiOpen;

    private boolean isCharging = false;

    private boolean isMicrophoneRecording = true;

    private String TESTING = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                String method = methodCall.method;
                if (method.equals("totalInternalMemorySize")) {
                    String totalInternalMemorySize = FileUtils.getTotalInternalMemorySize(MainActivity.this);
                    result.success(totalInternalMemorySize);
                }
                if (method.equals("testCall")) {
                    TESTING = "CALL";
                    Intent intent = new Intent("android.intent.action.CALL", Uri.parse("tel:114"));
                    startActivityForResult(intent, 1001);
                }
                if (method.equals("testMicrophone")) {
                    TESTING = "MIC";
                    testMicrophone();
                }
                if (method.equals("testWifi")) {
                    TESTING = "WIFI";
                    testWifi();
                }
                if (method.equals("testCharging")) {
                    TESTING = "CHARGING";
                    testCharging();
                }
                if (method.equals("testVibrate")) {
                    TESTING = "VIBRATE";
                    testVibrate();
                }
            }
        });

        new EventChannel(getFlutterView(), CHARGING_CHANNEL).setStreamHandler(
                new EventChannel.StreamHandler() {
                    private BroadcastReceiver chargingStateChangeReceiver;

                    @Override
                    public void onListen(Object o, EventChannel.EventSink eventSink) {
                        mEventSink = eventSink;

                        chargingStateChangeReceiver = createChargingStateChangeReceiver(eventSink);

                        registerReceiver(chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
                    }

                    @Override
                    public void onCancel(Object o) {
                        Log.i("onCancel", "unregister");

                        unregisterReceiver(chargingStateChangeReceiver);
                        chargingStateChangeReceiver = null;
                    }
                }
        );

        mTestReceiver = new TestReceiver();
        IntentFilter intentFilter = createLocalIntentFilter();
        registerReceiver(mTestReceiver, intentFilter);
    }

    private BroadcastReceiver createChargingStateChangeReceiver(final EventChannel.EventSink eventSink) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                Log.i("onReceive", "receive what");

                int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

                if (status == BatteryManager.BATTERY_STATUS_UNKNOWN) {
                    isCharging = false;
                } else {
                    isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL;
                }
            }
        };
    }

    private IntentFilter createLocalIntentFilter() {
        IntentFilter localIntentFilter = new IntentFilter();
        localIntentFilter.addAction(PACKAGE_NAME + ".action");
        localIntentFilter.addAction(PACKAGE_NAME + ".shake_action");

        localIntentFilter.addAction(Intent.ACTION_BATTERY_CHANGED);

        localIntentFilter.addAction(PACKAGE_NAME + ".mic_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".loudspeaker_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".gps_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".compass_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".wifi_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".gseneor_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".GYRseneor_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".flashLight_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".frontCamera_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".receiver_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".backCamera_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".call_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".electricize_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".backCamera_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".screenSensitive_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".display_action");
        localIntentFilter.addAction(PACKAGE_NAME + ".onDestroy");
        localIntentFilter.addAction(PACKAGE_NAME + ".ps_action");
        return localIntentFilter;
    }

    private void testWifi() {
        mTestCountDownTimer = new TestCountDownTimer();
        mTestCountDownTimer.start();
        isWifiOpen = openWifi();
    }

    private boolean openWifi() {
        Log.i("wifi", "open wifi");
        WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        boolean b = true;
        if (!wifiManager.isWifiEnabled()) {
            b = wifiManager.setWifiEnabled(true);
        }
        return b;
    }

    private void testCharging() {
        mTestCountDownTimer = new TestCountDownTimer();
        mTestCountDownTimer.start();
    }

    private void testMicrophone() {
        Log.i("start", "testMicrophone");

        AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        audioManager.setMicrophoneMute(false);
        audioManager.setSpeakerphoneOn(false);
        mRecordThread = new RecordThread();
        mRecordThread.start();
        mTestCountDownTimer = new TestCountDownTimer();
        mTestCountDownTimer.start();
    }

    private void testVibrate() {
        mTestCountDownTimer = new TestCountDownTimer();
        mTestCountDownTimer.start();
        Vibrator vibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
        if (vibrator != null) {
            vibrator.vibrate(1200);
        }
    }

    public class TestCountDownTimer extends CountDownTimer {

        public TestCountDownTimer() {
            super(1500, 6);
        }

        public TestCountDownTimer(long millisInFuture, long countDownInterval) {
            super(millisInFuture, countDownInterval);
        }

        @Override
        public void onTick(long l) {
//            Log.i("tag", "tick tick tick tick");
        }

        @Override
        public void onFinish() {
            Log.i("Timer", "Countdown Finished.");

            if (isWifiOpen && TESTING.equals("WIFI")) {
                mEventSink.success("success open wifi");
            } else if (TESTING.equals("WIFI")) {
                mEventSink.error("FAIL", "fail to open wifi", null);
            }

            if (isCharging && TESTING.equals("CHARGING")) {
                mEventSink.success("charging is ok");
            } else if (TESTING.equals("CHARGING")) {
                mEventSink.error("FAIL", "charging is fail", null);
            }

            if (isMicrophoneRecording && TESTING.equals("MIC")) {
                mEventSink.success("microphone can recording");
            } else if (TESTING.equals("MIC")) {
                mEventSink.error("FAIL", "microphone recording fail", null);
            }

//            if (TESTING.equals("VIBRATE")) {
//                mEventSink.success("always vibrating");
//            }

        }
    }

    public class TestReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            Log.i("receiver", intent.getAction());
            Log.i("result", "what is" + intent.getStringExtra("action"));

            if (null != intent.getStringExtra("action")) {
                Log.i("action", "sent");

//                mEventSink.success(intent.getStringExtra("action"));

            }
        }
    }

    private class RecordThread extends Thread {
        static final int audioEncoding = 2;
        static final int channelConfiguration = 2;
        static final int frequency = 44100;

        AudioRecord audioRecord;
        AudioTrack audioTrack;
        boolean isStart = true;

        private RecordThread() {
        }

        @Override
        public void run() {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.CUPCAKE) {
                try {
                    isMicrophoneRecording = true;
                    int i = AudioRecord.getMinBufferSize(frequency, channelConfiguration, audioEncoding) * 2;
                    int j = AudioTrack.getMinBufferSize(frequency, channelConfiguration, audioEncoding);
                    audioRecord = new AudioRecord(1, frequency, channelConfiguration, audioEncoding, i);
                    audioTrack = new AudioTrack(3, frequency, channelConfiguration, audioEncoding, j * 2, 1);
                    byte[] arrayOfByte = new byte[i];
                    audioRecord.startRecording();

                } catch (Exception e) {
                    isMicrophoneRecording = false;
                    isStart = false;
                    mRecordThread = null;
                    setVolumeControlStream(0);

                    Log.i("mic", "microphone failed");

                    e.printStackTrace();
                }
            }

        }
    }

}
