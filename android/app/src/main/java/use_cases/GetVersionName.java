package use_cases;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

public class GetVersionName {

    public String execute(Context context) throws PackageManager.NameNotFoundException {
        PackageInfo info = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
        String versionName = info.versionName;
        return versionName;
    }
}
