package com.example.patternlistener;

import android.app.Activity;
import android.os.Environment;
import android.widget.Toast;

import com.example.androidclient.ImageUpload;

import java.io.File;

public class UploadUtil {
    //    // 申请权限的集合，同时要在AndroidManifest.xml中申请，Android 6以上需要动态申请权限
//    String[] permissions = new String[]{
//            Manifest.permission.WRITE_EXTERNAL_STORAGE,
//            Manifest.permission.READ_EXTERNAL_STORAGE,
//            Manifest.permission.INTERNET
//    };
//    // 声明一个集合，在后面的代码中用来存储用户拒绝授权的权
//    List<String> mPermissionList = new ArrayList<>();
    //文件路径
    private static String path;
    static File f;

    public static void upload(Activity context) {
        path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/test.wav";
        boolean fileExist = fileIsExists(path);
        if(fileExist){
            Toast.makeText(context, "开始上传" + f.getAbsolutePath(), Toast.LENGTH_LONG).show();
            try {
                //上传文件
                ImageUpload.run(f);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    public static boolean fileIsExists(String strFile) {
        try {
            f = new File(strFile);
            if (!f.exists()) {
                return false;
            }
        } catch (Exception e) {
            return false;
        }
        return true;
    }
}