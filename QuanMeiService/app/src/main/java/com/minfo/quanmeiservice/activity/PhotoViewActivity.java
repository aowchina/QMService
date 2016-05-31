package com.minfo.quanmeiservice.activity;

import android.app.ProgressDialog;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.View;
import android.widget.Button;
import android.widget.GridView;
import android.widget.TextView;

import com.minfo.quanmeiservice.R;
import com.minfo.quanmeiservice.adapter.PhotoGridAdapter;
import com.minfo.quanmeiservice.utils.ToastUtils;

import java.util.ArrayList;
import java.util.List;

public class PhotoViewActivity extends BaseActivity implements PhotoGridAdapter.ItemSelectedListener, View.OnClickListener {

    private PhotoGridAdapter photoGridAdapter;
    private GridView gvPhoto;
    private TextView tvCancel;
    private Button btnComplete;

    private List<String> mSelectPath = new ArrayList<>();

    private AsyncTask<Void,Void,List<String>> photoTask;
    private ProgressDialog mProgressDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_photo_view);
    }

    @Override
    protected void findViews() {
        gvPhoto = (GridView) findViewById(R.id.gv_photo);
        tvCancel = (TextView) findViewById(R.id.tv_cancel);
        btnComplete = (Button) findViewById(R.id.btn_complete);
        tvCancel.setOnClickListener(this);
        btnComplete.setOnClickListener(this);
    }

    @Override
    protected void initViews() {
        initData();

        
    }

    private void initData() {

        photoTask = new AsyncTask<Void, Void, List<String>>() {

            @Override
            protected void onPreExecute() {
                super.onPreExecute();
                mProgressDialog = ProgressDialog.show(PhotoViewActivity.this, null, "正在加载...");
            }

            @Override
            protected List<String> doInBackground(Void... params) {
                if (!Environment.getExternalStorageState().equals(
                        Environment.MEDIA_MOUNTED)) {
                    ToastUtils.show(PhotoViewActivity.this, "暂无外部存储");
                }
                List<String> imgPaths = new ArrayList<>();
                Uri mImageUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                ContentResolver mContentResolver = PhotoViewActivity.this
                        .getContentResolver();

                // 只查询jpeg和png的图片
                Cursor mCursor = mContentResolver.query(mImageUri, null,
                        MediaStore.Images.Media.MIME_TYPE + "=? or "
                                + MediaStore.Images.Media.MIME_TYPE + "=?",
                        new String[]{"image/jpeg", "image/png"},
                        MediaStore.Images.Media.DATE_MODIFIED+" DESC");

                while (mCursor.moveToNext()) {
                    // 获取图片的路径
                    String path = mCursor.getString(mCursor
                            .getColumnIndex(MediaStore.Images.Media.DATA));
                    imgPaths.add(path);
                }
                mCursor.close();
                return imgPaths;
            }

            @Override
            protected void onPostExecute(List<String> paths) {
                super.onPostExecute(paths);
                mProgressDialog.dismiss();

                if(paths.size()>0){
                    setData(paths);
                }

            }
        };
        photoTask.execute();

    }

    private void setData(List<String> paths){
        photoGridAdapter = new PhotoGridAdapter(PhotoViewActivity.this,paths,R.layout.item_photo_view,PhotoViewActivity.this,UploadActivity.strList);
        gvPhoto.setAdapter(photoGridAdapter);


    }


    @Override
    public void showSelected(List<String> selectImgUrls) {
        mSelectPath = selectImgUrls;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.tv_cancel:
                finish();
                break;
            case R.id.btn_complete:
                UploadActivity.strList = mSelectPath;
                finish();
                startActivity(new Intent(this,UploadActivity.class));
                break;
        }
    }
}
