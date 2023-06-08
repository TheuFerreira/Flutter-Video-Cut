package use_cases;

import com.example.flutter_video_cut.BuildConfig;

public class GetVersionName {

    public String execute() {
        String versionName = BuildConfig.VERSION_NAME;
        return versionName;
    }
}
