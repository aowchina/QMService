package com.minfo.quanmeiservice.activity;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Window;
import android.view.WindowManager;

import com.minfo.quanmeiservice.http.VolleyHttpClient;
import com.minfo.quanmeiservice.utils.Utils;

import butterknife.ButterKnife;


/**
 * liujing
 */
public abstract class BaseActivity extends AppCompatActivity {

    protected VolleyHttpClient httpClient;
    protected Utils utils;
    protected String TAG = "";

    static {
        System.loadLibrary("QUANMEISERVICE");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        httpClient = new VolleyHttpClient(this);
        TAG = getClass().getSimpleName();
        utils = new Utils(this);
    }

    @Override
    public void setContentView(int layoutResID) {
//        requestWindowFeature(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        super.setContentView(layoutResID);
        /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            setTranslucentStatus(true);
            SystemBarTintManager tintManager = new SystemBarTintManager(this);
            tintManager.setStatusBarTintEnabled(true);
            tintManager.setStatusBarTintResource(R.color.start_title_color);//通知栏所需颜色

        }*/
        ButterKnife.inject(this);
        findViews();
        initViews();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    public void setTranslucentStatus(boolean on) {
        Window win = getWindow();
        WindowManager.LayoutParams winParams = win.getAttributes();
        final int bits = WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS;
        if (on) {
            winParams.flags |= bits;
        } else {
            winParams.flags &= ~bits;
        }
        win.setAttributes(winParams);
    }

    /**
     * 获取布局控件
     */
     protected abstract void findViews();

    /**
     * 初始化view的一些数据
     */
     protected abstract void initViews();

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }
}
