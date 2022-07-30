package use_cases;

import android.content.Context;
import android.net.Uri;
import android.os.Build;

import java.io.File;

import javautils.GenericFileProvider;

public class GetUriFromPath {
    public Uri execute(Context context, String path) {
        File file = new File(path);

        Uri uri;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            uri = GenericFileProvider.getUriForFile(context,"com.ferreira.myprovider", file);
        } else {
            uri = Uri.fromFile(file);
        }

        return uri;
    }
}
