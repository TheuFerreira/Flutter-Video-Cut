package use_cases;

import android.content.ContentResolver;
import android.net.Uri;
import android.os.ParcelFileDescriptor;

import androidx.annotation.NonNull;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class CopyFileToPath {
    public void execute(@NonNull ContentResolver resolver, String path, Uri destiny) throws IOException {
        try {
            ParcelFileDescriptor video = resolver.openFileDescriptor(destiny, "w");

            assert video != null;
            FileOutputStream output = new FileOutputStream(video.getFileDescriptor());
            FileInputStream input = new FileInputStream(path);

            byte[] buf = new byte[8192];
            int len;
            while ((len = input.read(buf)) > 0) {
                output.write(buf, 0, len);
            }

            output.close();
            input.close();

            video.close();
        } catch (IOException e) {
            e.printStackTrace();
            throw e;
        }
    }
}
