package com.minfo.quanmeiservice.activity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

import com.minfo.quanmeiservice.R;

import java.lang.ref.WeakReference;

public class InitActivity extends BaseActivity {

    private MyHandler handler;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_init);
    }

    @Override
    protected void findViews() {

    }

    @Override
    protected void initViews() {
        handler = new MyHandler(this);
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                startActivity(new Intent(InitActivity.this,LoginActivity.class));
                InitActivity.this.finish();
            }
        },1500);
    }

    private static class MyHandler extends Handler {
        private WeakReference<InitActivity> activityWeakReference;
        public MyHandler(InitActivity activity){
            activityWeakReference = new WeakReference<InitActivity>(activity);
        }

        @Override
        public void handleMessage(Message message){
            InitActivity activity = activityWeakReference.get();
            if(activity!=null){

            }
        }
    }
}
