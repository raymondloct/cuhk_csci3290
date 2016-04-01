package com.demo.zhouc.cardboarddemo;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.Display;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.VideoView;

import java.io.File;
import java.io.IOException;

/**
 * Created by zhouc on 14-11-4.
 */
public class VideoCardboard extends Activity {

    private static final String mStoragePath = "CardBoardDemo";

    private static String[] leftVideoList={"left_big.bang.s01e01.mp4","left_CUHK Timelapse.mp4","left_sub_big.bang.s01e01.mp4","left_sub_CUHK med.mp4","left_Unique One - CUHK.mp4"};
    private static String[] rightVideoList={"right_big.bang.s01e01.mp4","right_CUHK Timelapse.mp4","right_sub_big.bang.s01e01.mp4","right_sub_CUHK med.mp4","right_Unique One - CUHK.mp4"};
    private int vidSet=0;

    private boolean trigger1=false;
    private boolean trigger2=false;
    private boolean paused=false;

    // sensor manager
    private SensorManager mSensorManager;
    // sensor accelerometer & magnetic
    private Sensor mAccelerometer;
    private Sensor mMagnetic;
    // current sensor values
    private float[] mVal_acc = new float[3];
    private float[] mVal_mag = new float[3];
    private int mValue_cnt = 0;
    private int mNum_smooth = 20;
    private float[] mValue0 = new float[50];
    private float[] mValue1 = new float[50];
    private float[] mValue2 = new float[50];

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // remove title bar
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        // remove notification bar
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_video_cardboard);

        // initialize videoview
        initVideoView();

        // initialize SensorManager
        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        // initialize sensors
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        mMagnetic = mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        // register listener function for sensors
        mSensorManager.registerListener(myListener, mAccelerometer, SensorManager.SENSOR_DELAY_GAME);
        mSensorManager.registerListener(myListener, mMagnetic, SensorManager.SENSOR_DELAY_GAME);
    }

    private void initVideoView() {
        // get videoview
        VideoView vidViewL      = (VideoView) findViewById(R.id.vv_left);
        VideoView vidViewR    = (VideoView) findViewById(R.id.vv_right);

        // load 2 images
        String sdPath = Environment.getExternalStorageDirectory().getAbsolutePath();
        File vidL = new File(sdPath + File.separator + mStoragePath + File.separator + leftVideoList[vidSet]);//leftVideoList[vidSet]
        File vidR = new File(sdPath + File.separator + mStoragePath + File.separator + rightVideoList[vidSet]);//rightVideoList[vidSet]
        vidViewL.setVideoPath( vidL.getAbsolutePath() );
        vidViewR.setVideoPath( vidR.getAbsolutePath() );

        // set the scale and translation of the video
        float scaleL = 0.7f;
        float scaleR = 0.7f;
        float transL_x = 10, transL_y = 10;
        float transR_x = 10, transR_y = 10;

        vidViewL.setScaleX(scaleL);     vidViewL.setScaleY(scaleL);
        vidViewR.setScaleX(scaleR);     vidViewR.setScaleY(scaleR);
        vidViewL.setTranslationX(transL_x);
        vidViewL.setTranslationY(transL_y);
        vidViewR.setTranslationX(transR_x);
        vidViewR.setTranslationY(transR_y);

        // start to play the video
        vidViewL.start();
        vidViewR.start();

    }

    public void onPause(){
        mSensorManager.unregisterListener(myListener);
        super.onPause();
    }

    protected void onResume() {
        super.onResume();
        mSensorManager.registerListener(myListener, mAccelerometer, SensorManager.SENSOR_DELAY_GAME);
        mSensorManager.registerListener(myListener, mMagnetic, SensorManager.SENSOR_DELAY_GAME);
    }

    final SensorEventListener myListener = new SensorEventListener() {
        public void onSensorChanged(SensorEvent sensorEvent) {
            if (sensorEvent.sensor.getType() == Sensor.TYPE_MAGNETIC_FIELD)
                mVal_mag = sensorEvent.values;
            if (sensorEvent.sensor.getType() == Sensor.TYPE_ACCELEROMETER)
                mVal_acc = sensorEvent.values;
            calculateOrientation();
        }
        public void onAccuracyChanged(Sensor sensor, int accuracy) {}
    };

    private  void calculateOrientation() {
        // this function is to calculate orientation

        // calculate orientation from mVal_acc and mVal_mag
        float[] values = new float[3];

        // TODO: smooth neighboring sensor values to avoid vibration
        mValue_cnt = (mValue_cnt + 1) % mNum_smooth;
        mValue0[mValue_cnt] = mVal_acc[0];
        mValue1[mValue_cnt] = mVal_acc[1];
        mValue2[mValue_cnt] = mVal_acc[2];
        values[0] = 0;
        values[1] = 0;
        values[2] = 0;
        for (int i = 0; i < mNum_smooth; i++) {
            values[0] = values[0] + mValue0[i];
            values[1] = values[1] + mValue1[i];
            values[2] = values[2] + mValue2[i];
        }
        values[0] = values[0] / mNum_smooth;
        values[1] = values[1] / mNum_smooth;
        values[2] = values[2] / mNum_smooth;

        if(!trigger1){
            if(values[0]>10){
                trigger1=true;
                vidSet++;
                vidSet%=5;
                initVideoView();
            }else if(values[0]<-10){
                trigger1=true;
                vidSet+=4;
                vidSet%=5;
                initVideoView();
            }
        }else if(values[0]>-2 && values[0]<2){
            trigger1=false;
        }

        float[] magAbs={Math.abs(mVal_mag[0]),Math.abs(mVal_mag[1]),Math.abs(mVal_mag[2])};
        float magLvl=Math.max(Math.max(magAbs[0],magAbs[1]),magAbs[2]);
        if (magLvl>100 && (!trigger2)){
            trigger2=true;
            VideoView vidViewL  = (VideoView) findViewById(com.demo.zhouc.cardboarddemo.R.id.vv_left);
            VideoView vidViewR  = (VideoView) findViewById(com.demo.zhouc.cardboarddemo.R.id.vv_right);
            if (paused){
                vidViewL.resume();
                vidViewR.resume();
                paused=false;
            }else {
                if(vidViewL.isPlaying() && vidViewR.isPlaying()) {
                    vidViewL.pause();
                    vidViewR.pause();
                    paused=true;
                }
            }
        }else if(magLvl<70 && trigger2){
            trigger2=false;
        }

    }
}
