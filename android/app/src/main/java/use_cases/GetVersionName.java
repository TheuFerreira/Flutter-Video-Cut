package use_cases;

import androidx.multidex.BuildConfig;

public class GetVersionName {

    public String execute() {
        String versionName = BuildConfig.VERSION_NAME;
        return versionName;
    }
}
