package use_cases;

import android.media.MediaMetadataRetriever;
import android.os.Build;
import android.util.Size;

import java.io.IOException;

public class GetDimensionsOfVideo {
    public Size execute(String path) throws IOException {
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        retriever.setDataSource(path);
        int width = Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH));
        int height = Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT));

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            retriever.close();
        }

        return new Size(width, height);
    }
}
