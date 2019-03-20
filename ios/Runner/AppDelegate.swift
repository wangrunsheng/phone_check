import UIKit
import Flutter
import AVFoundation

enum ChannelName {
    static let method = "phonecheck.runsheng.wang/method"
    static let event = "phonecheck.runsheng.wang/event"
}

enum BatteryState {
    static let charging = "charging"
    static let discharging = "discharging"
}

enum MyFlutterErrorCode {
    static let unavailable = "UNAVAILABLE"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    
    private var countdownTimer: Timer = Timer()
    
    private var secondInFuture = 2
    
    private var secondCount = 0
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        
        UIDevice.current.isBatteryMonitoringEnabled = true
//        sendBatteryStateEvent()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(AppDelegate.onBatteryStateDidChange),
            name: NSNotification.Name.UIDeviceBatteryStateDidChange,
            object: nil)
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }
    
    @objc private func onBatteryStateDidChange(notification: NSNotification) {
//        sendBatteryStateEvent()
    }
    
    private func sendBatteryStateEvent() {
        guard let eventSink = eventSink else {
            return
        }
        
        switch UIDevice.current.batteryState {
        case .full:
            eventSink(BatteryState.charging)
        case .charging:
            eventSink(BatteryState.charging)
        case .unplugged:
//            eventSink(BatteryState.discharging)
            eventSink(FlutterError(code: BatteryState.discharging, message: BatteryState.discharging, details: nil))
        default:
            eventSink(FlutterError(code: MyFlutterErrorCode.unavailable,
                                   message: "Charging status unavailable",
                                   details: nil))
        }
    }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self);
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
        let batteryChannel = FlutterMethodChannel.init(name: ChannelName.method,
                                                       binaryMessenger: controller);
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if ("getBatteryLevel" == call.method) {
                self.receiveBatteryLevel(result: result);
            } else if ("testVibrate" == call.method) {
                self.testVibrate()
            } else if ("testCall" == call.method) {
                self.testCall()
            } else if ("testCharging" == call.method) {
                self.testCharging()
            }  else if ("switchToReceiver" == call.method) {
                self.switchToReceiver()
            } else if ("switchToSpeaker" == call.method) {
                self.switchToSpeaker()
            }else {
                result(FlutterMethodNotImplemented);
            }
        })
        
        let eventChannel = FlutterEventChannel(name: ChannelName.event, binaryMessenger: controller)
        
        eventChannel.setStreamHandler(self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current;
        device.isBatteryMonitoringEnabled = true;
        if (device.batteryState == UIDeviceBatteryState.unknown) {
            result(FlutterError.init(code: "UNAVAILABLE",
                                     message: "Battery info unavailable",
                                     details: nil));
        } else {
            result(Int(device.batteryLevel * 100));
        }
    }
    
    private func testVibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    private func testCall() {
        UIApplication.shared.openURL(URL(string: "tel://114")!)
    }
    
    private func testCharging() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopCountdownTimer), userInfo: nil, repeats: true)
    }
    
    private func switchToReceiver() {
        print("try to switch to Receiver")
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            print("'switch to receiver success'")
            // AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.none)
        } catch  {
            print("switch to Receiver fail")
        }
    }
    
    private func switchToSpeaker() {
        print("try to switch to Speaker")
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch  {
            print("switch to Speaker fail")
        }
    }
    
    @objc func stopCountdownTimer() {
        secondCount = secondCount + 1
        
        if secondCount == 2 {
            countdownTimer.invalidate()
            secondCount = 0
            sendBatteryStateEvent()
        }
        
    }
}
