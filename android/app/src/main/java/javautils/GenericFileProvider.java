package javautils;

import androidx.core.content.FileProvider;

import com.example.flutter_video_cut.R;

public class GenericFileProvider extends FileProvider {
    public GenericFileProvider() {
        super(R.xml.provider_paths);
    }
}
