package use_cases;

import android.content.Context;
import android.net.Uri;
import android.os.Build;

import java.io.File;
import java.util.ArrayList;

import javautils.GenericFileProvider;

public class GetURIsFromFiles {
    public ArrayList<Uri> execute(Context context, ArrayList<String> paths) {
        ArrayList<Uri> uris = new ArrayList<>();
        for (String path : paths) {
            File file = new File(path);
            Uri uri;

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                uri = GenericFileProvider.getUriForFile(context,"com.ferreira.myprovider", file);
            } else {
                uri = Uri.fromFile(file);
            }

            uris.add(uri);
        }

        return uris;
    }
}
