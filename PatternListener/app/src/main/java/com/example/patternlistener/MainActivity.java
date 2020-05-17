package com.example.patternlistener;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;


import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.os.Environment;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;


import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Locale;

//加包以后申请的权限
import java.io.File;
import java.util.ArrayList;
import java.util.List;



public class MainActivity extends AppCompatActivity implements View.OnClickListener {


    public static final String TAG = "MainActivity";
    public static final int SAMPLE_RATE_INHZ = 44100;
    public static final int CHANNEL_CONFIG = AudioFormat.CHANNEL_IN_MONO;
    public static final int AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;
//    private static final int REQUEST_RECORD_AUDIO = 1;


    private MediaPlayer mediaPlayer = new MediaPlayer();
    private MediaRecorder mediaRecorder = new MediaRecorder();
    private AudioRecord audioRecord;
    private boolean isRecording;


    private File soundFile;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

//        audioManager = (AudioManager) this.getSystemService(Context.AUDIO_SERVICE);
//        audioManager.setSpeakerphoneOn(true);
//        audioManager.setMode(AudioManager.STREAM_MUSIC);

        Button play = (Button) findViewById(R.id.play);
        Button stop = (Button) findViewById(R.id.stop);
        Button start = (Button) findViewById(R.id.start);
        Button over = (Button) findViewById(R.id.over);
        Button set = (Button) findViewById(R.id.set);
        Button convert = findViewById(R.id.convert);

        play.setOnClickListener(this);
        stop.setOnClickListener(this);
        start.setOnClickListener(this);
        over.setOnClickListener(this);
        set.setOnClickListener(this);
        convert.setOnClickListener(this);

        if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
        } else {
            initMediaPlayer();    //初始化mediaplayer
        }


        if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.RECORD_AUDIO}, 1);
        }

        Log.d(TAG, "onCreate finish");
    }


    private void initMediaPlayer() {
        try {


            File file = new File(Environment.getExternalStorageDirectory(), "20kHz.wav");   // 播放声音文件名
            mediaPlayer.setDataSource(file.getPath());
//            mediaPlayer.setAudioStreamType();
            mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
            mediaPlayer.prepare();
            mediaPlayer.setLooping(true);
            Toast.makeText(getApplicationContext(), "Create successful", Toast.LENGTH_SHORT).show();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    @Override
    public void onClick(View v) {
        // 改动的部分
        // 申请权限的集合，同时要在AndroidManifest.xml中申请，Android 6以上需要动态申请权限
        String[] permissions = new String[]{
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.INTERNET
        };
        // 声明一个集合，在后面的代码中用来存储用户拒绝授权的权
        List<String> mPermissionList = new ArrayList<>();
        //改动部分结束
        switch (v.getId()) {
            case R.id.play:
                if (!mediaPlayer.isPlaying()) {
                    mediaPlayer.start();
                }
                break;
            case R.id.stop:
                if (mediaPlayer.isPlaying()) {
                    mediaPlayer.reset();
                    initMediaPlayer();
                }
                break;
            case R.id.set:
                initMediaPlayer();
                Toast.makeText(getApplicationContext(), "Ready", Toast.LENGTH_SHORT).show();
                break;

            case R.id.start:
                startRecord();
                break;

            case R.id.over:
                stopRecord();
                break;

            case R.id.convert:
                PcmToWavUtil pcmToWavUtil = new PcmToWavUtil(SAMPLE_RATE_INHZ, CHANNEL_CONFIG, AUDIO_FORMAT);
                File pcmFile = new File(getExternalFilesDir(Environment.DIRECTORY_MUSIC), "test.pcm");
                File wavFile = new File(Environment.getExternalStorageDirectory() + "/test.wav");
                if (!wavFile.mkdirs()) {
                    Log.e(TAG, "wavFile Directory not created");
                }
                if (wavFile.exists()) {
                    wavFile.delete();
                }
                pcmToWavUtil.pcmToWav(soundFile.getAbsolutePath(), wavFile.getAbsolutePath());
                //开始传文件
                //6.0获取多个权限
                mPermissionList.clear();
                for (int i = 0; i < permissions.length; i++) {
                    if (ContextCompat.checkSelfPermission(MainActivity.this, permissions[i]) != PackageManager.PERMISSION_GRANTED) {
                        mPermissionList.add(permissions[i]);
                    }
                }
                UploadUtil.upload(MainActivity.this);
                break;

            default:
                break;
        }
    }

    private void stopRecord() {

        isRecording = false;
        if (null != audioRecord) {
            audioRecord.stop();
            audioRecord.release();
            audioRecord = null;
        }
    }
//        if (soundFile != null && soundFile.exists())  {
//            mediaRecorder.stop();
//            mediaRecorder.release();
//            mediaRecorder = null;
//        }
//    }

    private void startRecord() {

        final int minBufferSize = AudioRecord.getMinBufferSize(SAMPLE_RATE_INHZ, CHANNEL_CONFIG, AUDIO_FORMAT);
        audioRecord = new AudioRecord(MediaRecorder.AudioSource.MIC, SAMPLE_RATE_INHZ, CHANNEL_CONFIG, AUDIO_FORMAT, minBufferSize);

        final byte data[] = new byte[minBufferSize];
        soundFile = new File(Environment.getExternalStorageDirectory() + "/test.pcm");

        audioRecord.startRecording();
        isRecording = true;

        new Thread(new Runnable() {
            @Override
            public void run() {

                FileOutputStream os = null;
                try {
                    os = new FileOutputStream(soundFile);
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                }

                if (null != os) {
                    while (isRecording) {
                        int read = audioRecord.read(data, 0, minBufferSize);
                        if (AudioRecord.ERROR_INVALID_OPERATION != read) {
                            try {
                                os.write(data);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                    try {
                        Log.i(TAG, "run: close file output stream !");
                        os.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();


    }
//        mediaRecorder = new MediaRecorder();
//        try {
//            soundFile = new File(Environment.getExternalStorageDirectory().getCanonicalFile() + "/sound.m4a");
//
//
//
//            mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
//            mediaRecorder.setAudioSamplingRate(44100);
//            mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.RAW_AMR);
//            mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
//
//            mediaRecorder.setOutputFile(soundFile.getAbsolutePath());
//            mediaRecorder.prepare();
//            mediaRecorder.start();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mediaPlayer != null) {
            mediaPlayer.stop();
            mediaPlayer.release();
        }
        if (soundFile != null && soundFile.exists()) {
            mediaRecorder.stop();
            mediaRecorder.release();
            mediaRecorder = null;
        }

    }


    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case 1:
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    initMediaPlayer();
                } else {
                    Toast.makeText(this, "拒绝权限将无法使用程序", Toast.LENGTH_SHORT).show();
                    finish();
                }

//                for (int i = 0; i < grantResults.length; i++) {
//                    if (grantResults[i] != PackageManager.PERMISSION_GRANTED) {
//                        //判断是否勾选禁止后不再询问
//                        boolean showRequestPermission = ActivityCompat.shouldShowRequestPermissionRationale(MainActivity.this, permissions[i]);
//                        if (showRequestPermission) {
//                            Toast.makeText(MainActivity.this, "权限未申请", Toast.LENGTH_SHORT).show();
//                        }
//                    }
//                }

                break;
            default:
                break;
        }
    }
}