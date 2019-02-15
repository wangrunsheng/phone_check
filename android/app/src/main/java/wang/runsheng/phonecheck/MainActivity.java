package wang.runsheng.phonecheck;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.AudioTrack;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Bundle;
import android.os.CountDownTimer;
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
                if (methodCall.method.equals("testMicrophone")) {
                    testMicrophone();
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

                        IntentFilter localIntentFilter = createLocalIntentFilter();

                        registerReceiver(chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
//                        registerReceiver(chargingStateChangeReceiver, localIntentFilter);
                    }

                    @Override
                    public void onCancel(Object o) {
                        Log.i("onCancel","unregister");

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

//                String result = intent.getStringExtra("action");
//
//                Log.i("action", "what is the result" + result);
//
//                if (result.equals(PACKAGE_NAME + ".succeed")) {
//                    Log.i("action", "succeed");
//                } else {
//                    Log.i("action", "fail");
//                }

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
        localIntentFilter.addAction(PACKAGE_NAME + "action");
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

    public class TestCountDownTimer extends CountDownTimer {

        public TestCountDownTimer() {
            super(200, 6);
        }

        public TestCountDownTimer(long millisInFuture, long countDownInterval) {
            super(millisInFuture, countDownInterval);
        }

        @Override
        public void onTick(long l) {
            Log.i("tag", "tick tick tick tick");
        }

        @Override
        public void onFinish() {
            Log.i("Timer", "Countdown Finished.");

            Intent intent = new Intent(PACKAGE_NAME + ".action");
            intent.putExtra("action", PACKAGE_NAME + ".succeed");
            sendBroadcast(intent);
        }
    }

    public class TestReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            Log.i("receiver", intent.getAction());
            Log.i("result", "what is" + intent.getStringExtra("action"));

            if (null != intent.getStringExtra("action")) {
                Log.i("action", "sent");

                mEventSink.success(intent.getStringExtra("action"));
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
                    int i = AudioRecord.getMinBufferSize(frequency, channelConfiguration, audioEncoding) * 2;
                    int j = AudioTrack.getMinBufferSize(frequency, channelConfiguration, audioEncoding);
                    audioRecord = new AudioRecord(1, frequency, channelConfiguration, audioEncoding, i);
                    audioTrack = new AudioTrack(3, frequency, channelConfiguration, audioEncoding, j * 2, 1);
                    byte[] arrayOfByte = new byte[i];
                    audioRecord.startRecording();
                } catch (Exception e) {
                    isStart = false;
                    mRecordThread = null;
                    setVolumeControlStream(0);
                    Intent intent = new Intent(PACKAGE_NAME + ".mic_action");
                    intent.putExtra("action", PACKAGE_NAME + ".fail");
                    sendBroadcast(intent);
                    e.printStackTrace();
                }
            }

        }
    }

}
