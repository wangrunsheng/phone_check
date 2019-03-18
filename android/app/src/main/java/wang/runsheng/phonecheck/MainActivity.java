package wang.runsheng.phonecheck;

import android.Manifest;
import android.annotation.TargetApi;
import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.hardware.ConsumerIrManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
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

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import wang.runsheng.phonecheck.utils.DeviceUtils;
import wang.runsheng.phonecheck.utils.FileUtils;


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
    private AudioManager audioManager;

    private ConsumerIrManager consumerIrManager;

//    GpsStatus.Listener listener = new GpsStatus.Listener() {
//        @Override
//        public void onGpsStatusChanged(int i) {
//
//        }
//    };

    private LocationManager locationManager;

    private LocationListener locationListener = new LocationListener() {
        @Override
        public void onLocationChanged(Location location) {

        }

        @Override
        public void onStatusChanged(String s, int i, Bundle bundle) {

        }

        @Override
        public void onProviderEnabled(String s) {

        }

        @Override
        public void onProviderDisabled(String s) {

        }
    };

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
                    testCall();
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
                if (method.equals("testBluetooth")) {
                    TESTING = "BLUETOOTH";
                    Log.e("Bluetooth", "bluetooth");
                    testBluetooth();
                }
                if (method.equals("testGps")) {
                    TESTING = "GPS";
                    testGps();
                }
                if (method.equals("testInfraRed")) {
                    TESTING = "INFRARED";
                    testInfraRed();
                }
                if (method.equals("testReceiver")) {
                    TESTING = "RECEIVER";
                    testReceiver();
                }

                if (method.equals("switchToReceiver")) {
                    switchToReceiver();
                }
                if (method.equals("switchToSpeaker")) {
                    switchToSpeaker();
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

    @TargetApi(Build.VERSION_CODES.M)
    private void testCall() {
        int permissionCheck = checkSelfPermission(Manifest.permission.CALL_PHONE);
        if (permissionCheck == PackageManager.PERMISSION_GRANTED) {
            Intent intent = new Intent("android.intent.action.CALL", Uri.parse("tel:114"));
            startActivityForResult(intent, 1001);
        } else {
            requestPermissions(new String[]{Manifest.permission.CALL_PHONE}, 2001);
        }

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 2001) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Intent intent = new Intent("android.intent.action.CALL", Uri.parse("tel:114"));
                startActivityForResult(intent, 1001);
            } else {
                if ("CALL".equals(TESTING)) {
                    if (mEventSink != null) {
                        mEventSink.error("FAIL", "phone call denied", null);
                    }
                }
            }
        }
    }

    private void testReceiver() {


    }

    private void switchToReceiver() {
        Log.e("RECEIVER", "switch to receiver");
//        initAudioManager();
//        changeToReceiverMode();
        AudioManager manager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        manager.setMode(AudioManager.MODE_IN_CALL);
        setVolumeControlStream(AudioManager.STREAM_VOICE_CALL);


        try {
            Class audioSystemClass = Class.forName("android.media.AudioSystem");
            Method setForceUse = audioSystemClass.getMethod("setForceUse", int.class, int.class);
            manager.setSpeakerphoneOn(false);
            manager.setMode(AudioManager.MODE_NORMAL);
            setForceUse.invoke(null, 0, 0);
            manager.setMode(AudioManager.MODE_IN_COMMUNICATION);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } finally {
            Log.e("RECEIVER", "reflection exception ==========");
        }
    }

    private void switchToSpeaker() {
        Log.e("RECEIVER", "switch to speaker");
//        changeToSpeakerMode();
        AudioManager manager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        manager.setMode(AudioManager.MODE_NORMAL);

    }

    /**
     * 初始化音频管理器
     */
    private void initAudioManager() {
        audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            audioManager.setMode(AudioManager.MODE_IN_COMMUNICATION);
        } else {
            audioManager.setMode(AudioManager.MODE_IN_CALL);
        }
        audioManager.setSpeakerphoneOn(true);           //默认为扬声器播放
    }

    /**
     * 切换到听筒模式
     */
    private void changeToReceiverMode() {
        audioManager.setSpeakerphoneOn(false);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            audioManager.setStreamVolume(AudioManager.STREAM_MUSIC,
                    audioManager.getStreamMaxVolume(AudioManager.MODE_IN_COMMUNICATION), AudioManager.FX_KEY_CLICK);
        } else {
            audioManager.setStreamVolume(AudioManager.STREAM_MUSIC,
                    audioManager.getStreamMaxVolume(AudioManager.MODE_IN_CALL), AudioManager.FX_KEY_CLICK);
        }
    }

    /**
     * 切换到外放模式
     */
    public void changeToSpeakerMode() {
//        currentMode = MODE_SPEAKER;
        audioManager.setSpeakerphoneOn(true);
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

    private void testBluetooth() {
        mTestCountDownTimer = new TestCountDownTimer(4000);
        mTestCountDownTimer.start();
        startActivity(new Intent("android.bluetooth.adapter.action.REQUEST_ENABLE"));
    }

    @TargetApi(Build.VERSION_CODES.KITKAT)
    private void testInfraRed() {
        mTestCountDownTimer = new TestCountDownTimer();
        mTestCountDownTimer.start();

        consumerIrManager = (ConsumerIrManager) getSystemService(Context.CONSUMER_IR_SERVICE);

    }

    private void testGps() {
        if (!DeviceUtils.isLocationServiceBasedOnWLANEnabled(MainActivity.this)) {
            startActivityForResult(new Intent("android.settings.LOCATION_SOURCE_SETTINGS"), 1002);
        } else {
            mTestCountDownTimer = new TestCountDownTimer();
            mTestCountDownTimer.start();
        }
    }

    public class TestCountDownTimer extends CountDownTimer {

        public TestCountDownTimer() {
            super(1500, 6);
        }

        public TestCountDownTimer(long millisInFuture) {
            super(millisInFuture, 6);
        }

        public TestCountDownTimer(long millisInFuture, long countDownInterval) {
            super(millisInFuture, countDownInterval);
        }

        @Override
        public void onTick(long l) {
//            Log.i("tag", "tick tick tick tick");
        }

        @TargetApi(Build.VERSION_CODES.KITKAT)
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

            if (TESTING.equals("BLUETOOTH")) {
                BluetoothAdapter adapter = BluetoothAdapter.getDefaultAdapter();
                if (adapter != null) {
                    if (adapter.isEnabled()) {
                        mEventSink.success("bluetooth is enabled");
                        return;
                    }
                }
                mEventSink.error("FAIL", "bluetooth is not enabled", null);
            }

            if (TESTING.equals("GPS")) {
                mEventSink.success("location get");
            }

            if (TESTING.equals("INFRARED")) {

                if (consumerIrManager.hasIrEmitter()) {
                    mEventSink.success("has infrared");
                } else {
                    mEventSink.error("FAIL", "does not have  infrared", null);
                }
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

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (!DeviceUtils.isLocationServiceBasedOnWLANEnabled(MainActivity.this) && requestCode == 1002) {
            startActivityForResult(new Intent("android.settings.LOCATION_SOURCE_SETTINGS"), 1002);
        } else if (requestCode == 1002) {
            if (mEventSink != null) {
                mEventSink.success("location get");
            } else {
                Log.e("GPS", "mEventSink is null");
            }
        }
    }
}
