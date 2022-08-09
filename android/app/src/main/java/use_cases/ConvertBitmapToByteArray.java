package use_cases;

import android.graphics.Bitmap;

import java.io.ByteArrayOutputStream;

public class ConvertBitmapToByteArray {
    public byte[] execute(Bitmap bitmap) {
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream);
        byte[] byteArray = stream.toByteArray();
        bitmap.recycle();

        return byteArray;
    }
}
