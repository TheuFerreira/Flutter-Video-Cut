package use_cases;

import android.media.MediaMetadataRetriever;
import android.util.Size;

public class GetDimensionsOfVideo {
    public Size execute(String path) {
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        retriever.setDataSource(path);
        int width = Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH));
        int height = Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT));

        return new Size(width, height);
    }
}
