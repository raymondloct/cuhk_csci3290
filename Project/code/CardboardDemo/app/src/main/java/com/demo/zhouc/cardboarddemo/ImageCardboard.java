package com.demo.zhouc.cardboarddemo;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Point;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.Display;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;

import java.io.File;

/**
 * Created by zhouc & xtao on 14-11-4.
 */
public class ImageCardboard extends Activity {

    private static final String mStoragePath = "CardBoardDemo";

    private static String[] leftImageList={"1_left.jpg","2_left.jpg","3_left.jpg","4_left.jpg","5_left.jpg"};
    private static String[] rightImageList={"1_right.jpg","2_right.jpg","3_right.jpg","4_right.jpg","5_right.jpg"};
    private int picSet=0;

    private boolean trigger1=false;
    private boolean trigger2=false;
    private boolean zoomed=false;

    private float oScaleL,oScaleR;
    private float[] dimImg=new float[4];
    private float[] dimImgView=new float[4];

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

        // set content view
        setContentView(R.layout.activity_image_cardboard);
        // TODO: initialize imageview
        initImageView();

        // initialize SensorManager
        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        // initialize sensors
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        mMagnetic = mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        // register listener function for sensors
        mSensorManager.registerListener(myListener, mAccelerometer, SensorManager.SENSOR_DELAY_GAME);
        mSensorManager.registerListener(myListener, mMagnetic, SensorManager.SENSOR_DELAY_GAME);

    }

    private void initImageView() {

        // load 2 images
        String sdPath   = Environment.getExternalStorageDirectory().getAbsolutePath(); // SD card location
        File imgL    = new File( sdPath + File.separator + mStoragePath + File.separator + leftImageList[picSet] );
        File imgR   = new File( sdPath + File.separator + mStoragePath + File.separator + rightImageList[picSet] );

        // save 2 images into bitmap
        Bitmap bmL  = BitmapFactory.decodeFile( imgL.getAbsolutePath() );
        Bitmap bmR  = BitmapFactory.decodeFile( imgR.getAbsolutePath() );

        // get imageview
        final ImageView imgViewL   = (ImageView) findViewById(R.id.iv_left);
        final ImageView imgViewR  = (ImageView) findViewById(R.id.iv_right);

        // get height and width of images
        float imgL_h = bmL.getHeight();
        float imgL_w = bmL.getWidth();
        float imgR_h = bmR.getHeight();
        float imgR_w = bmR.getWidth();
        dimImg[0]=imgL_h;
        dimImg[1]=imgL_w;
        dimImg[2]=imgR_h;
        dimImg[3]=imgR_w;

        // get height and width of ImageView
        Display d = getWindowManager().getDefaultDisplay();
        Point szScreen = new Point();       d.getSize(szScreen);
        float imgViewL_h = szScreen.y;
        float imgViewL_w = szScreen.x / 2;
        float imgViewR_h = szScreen.y;
        float imgViewR_w = szScreen.x / 2;
        dimImgView[0]=imgViewL_h;
        dimImgView[1]=imgViewL_w;
        dimImgView[2]=imgViewR_h;
        dimImgView[3]=imgViewR_w;

        // TODO: set scale and translation of 2 images
        Matrix matrixL=new Matrix();
        Matrix matrixR=new Matrix();

        // TODO: set scale of curent image
        float scaleL = 0.7f*Math.min( 1.0f*imgViewL_h/imgL_h, 1.0f*imgViewL_w/imgL_w ); // TODO: change this value
        float scaleR = 0.7f*Math.min( 1.0f*imgViewR_h/imgR_h, 1.0f*imgViewR_w/imgR_w ); // TODO: change this value
        oScaleL=scaleL;
        oScaleR=scaleR;
        matrixL.postScale(scaleL, scaleL);
        matrixR.postScale(scaleR, scaleR);

        // TODO: set translation of curent image
        matrixL.postTranslate((imgViewL_w - scaleL * imgL_w) / 2, (imgViewL_h - scaleL*imgL_h)/2);// TODO: change this value
        matrixR.postTranslate((imgViewR_w - scaleR * imgR_w) / 2, (imgViewR_h - scaleR*imgR_h) / 2);// TODO: change this value

        // display images inside the ImageView
        imgViewL.setImageBitmap(bmL);
        imgViewR.setImageBitmap(bmR);

        // using matrix to control scale and translation of images
        imgViewL.setImageMatrix(matrixL);
        imgViewR.setImageMatrix(matrixR);
        imgViewL.setScaleType(ImageView.ScaleType.MATRIX);
        imgViewR.setScaleType(ImageView.ScaleType.MATRIX);

        // set imageview background color
        imgViewL.setBackgroundColor(Color.rgb(255,0,0));
        imgViewR.setBackgroundColor(Color.rgb(0,255,0));
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
                picSet++;
                picSet %=5;
                initImageView();
            }else if(values[0]<-10){
                trigger1=true;
                picSet+=4;
                picSet %=5;
                initImageView();
            }
        }else if(values[0]>-2 && values[0]<2){
            trigger1=false;
        }
        float[] magAbs={Math.abs(mVal_mag[0]),Math.abs(mVal_mag[1]),Math.abs(mVal_mag[2])};
        float magLvl=Math.max(Math.max(magAbs[0],magAbs[1]),magAbs[2]);
        if (magLvl>100 && (!trigger2)){
            trigger2=true;
            if (zoomed){
                zoom(false);
            }else {
                zoom(true);
            }
            zoomed=!zoomed;
        }else if(magLvl<70 && trigger2){
            trigger2=false;
        }
    }

    private void zoom(boolean enlarge){
        final ImageView imgViewL   = (ImageView) findViewById(R.id.iv_left);
        final ImageView imgViewR  = (ImageView) findViewById(R.id.iv_right);
        Matrix matrixL=new Matrix();
        Matrix matrixR=new Matrix();
        if(enlarge){
            matrixL.postScale(2*oScaleL, 2*oScaleL);
            matrixR.postScale(2*oScaleR, 2*oScaleR);
            matrixL.postTranslate((dimImgView[1]-2*oScaleL*dimImg[1])/2 + 75, (dimImgView[0]-2*oScaleL*dimImg[0])/2);
            matrixR.postTranslate((dimImgView[3]-2*oScaleR*dimImg[3])/2 - 75, (dimImgView[2]-2*oScaleL*dimImg[2])/2);
        }else{
            matrixL.postScale(oScaleL, oScaleL);
            matrixR.postScale(oScaleR, oScaleR);
            matrixL.postTranslate((dimImgView[1]-oScaleL*dimImg[1])/2, (dimImgView[0]-oScaleL*dimImg[0])/2);
            matrixR.postTranslate((dimImgView[3]-oScaleR*dimImg[3])/2, (dimImgView[2]-oScaleL*dimImg[2])/2);
        }
        imgViewL.setImageMatrix(matrixL);
        imgViewR.setImageMatrix(matrixR);
        imgViewL.setScaleType(ImageView.ScaleType.MATRIX);
        imgViewR.setScaleType(ImageView.ScaleType.MATRIX);
    }
}
