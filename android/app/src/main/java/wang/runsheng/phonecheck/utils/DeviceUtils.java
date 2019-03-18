package wang.runsheng.phonecheck.utils;

import android.content.Context;
import android.location.LocationManager;

public class DeviceUtils {

    public static boolean isLocationServiceBasedOnWLANEnabled(Context context)
    {
        LocationManager localLocationManager = (LocationManager)context.getSystemService(Context.LOCATION_SERVICE);
        return (localLocationManager != null) && (localLocationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER));
    }

    public static boolean isLocationServiceBasedOnGPSEnabled(Context context)
    {
        LocationManager localLocationManager = (LocationManager)context.getSystemService(Context.LOCATION_SERVICE);
        return (localLocationManager != null) && (localLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER));
    }
}
