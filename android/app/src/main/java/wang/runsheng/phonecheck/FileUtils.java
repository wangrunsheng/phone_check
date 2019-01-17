package wang.runsheng.phonecheck;

import android.content.Context;
import android.os.Environment;
import android.os.StatFs;

public class FileUtils {

    public static String getTotalInternalMemorySize(Context context) {
        StatFs localStatFs = new StatFs(Environment.getDataDirectory().getPath());
        long l = localStatFs.getBlockSizeLong();
        System.out.println("============" + l);
        if ((490.0f < l) && (l <= 500.0f)) {
            return "500GB";
        }
        if ((9.0f < l) && (l <= 16.0f)) {
            return "16GB";
        }
        return "Unknown";
    }
}
