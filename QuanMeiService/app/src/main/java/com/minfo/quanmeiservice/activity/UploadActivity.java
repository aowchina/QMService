package com.minfo.quanmeiservice.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.GridView;
import android.widget.ImageButton;
import android.widget.TextView;

import com.minfo.quanmeiservice.R;
import com.minfo.quanmeiservice.adapter.BaseViewHolder;
import com.minfo.quanmeiservice.adapter.CommonAdapter;
import com.minfo.quanmeiservice.utils.Constant;
import com.minfo.quanmeiservice.utils.ImgUtils;
import com.minfo.quanmeiservice.utils.MyFileUpload;
import com.minfo.quanmeiservice.utils.ToastUtils;
import com.minfo.quanmeiservice.widget.LoadingDialog;
import com.minfo.quanmeiservice.widget.SelectPicDialog;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.lang.ref.WeakReference;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UploadActivity extends BaseActivity implements View.OnClickListener, SelectPicDialog.SelectPicDialogClickListener {

    private SelectPicDialog selectPicDialog;
    private GridView gvPhoto;
    private TextView tvUpload;
    private ImageButton imgAdd;
    private String cameraSavePath;
    private String takephotoname;
    private UploadAdapter uploadAdapter;
    public static  List<String> strList = new ArrayList<>();
    private List<Map<String,File>> files = new ArrayList<>();
    private ImgUtils imgUtils;
    private MyHandler myHandler;
    private LoadingDialog loadingDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_upload);
        selectPicDialog = new SelectPicDialog(this, this);
        imgUtils = new ImgUtils(this);
        myHandler = new MyHandler(this);
    }

    @Override
    protected void findViews() {
        imgAdd = (ImageButton) findViewById(R.id.btn_img_add);
        gvPhoto = (GridView) findViewById(R.id.gv_photo);
        tvUpload = (TextView) findViewById(R.id.tv_right);
        tvUpload.setOnClickListener(this);
        imgAdd.setOnClickListener(this);
        loadingDialog = new LoadingDialog(this);
    }

    @Override
    protected void initViews() {
        uploadAdapter = new UploadAdapter(this,strList,R.layout.photo_upload_item);
        gvPhoto.setAdapter(uploadAdapter);

    }

    private void reqUpload(){
        for(int i = 0;i<strList.size();i++){
            Map<String,File> map = new HashMap<>();
            String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
            String imgName = getFilesDir()+File.separator+"IMG_"+timeStamp + i+1+".jpg";
            imgUtils.createNewFile(imgName,strList.get(i));
            map.put(imgName,new File(imgName));
            files.add(map);
        }


        final String url = getString(R.string.api_baseurl)+"order/Upload.php";
        String str = utils.getBasePostStr() + "*" + Constant.user.getUserid() + "*" + Constant.orderid;

        final Map<String, String> params = utils.getParams(str);

        loadingDialog.show();
        new Thread(new Runnable() {
            @Override
            public void run() {
                MyFileUpload fileUpload = new MyFileUpload();
                try {
                    String msg = fileUpload.postForm(url, params, files);
                    Log.e(TAG,msg);

                    if (myHandler != null) {
                        Message message = myHandler.obtainMessage(1, msg);
                        myHandler.sendMessage(message);
                    }

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private static class MyHandler extends Handler {
        private WeakReference<UploadActivity> activityWeakReference;

        public MyHandler(UploadActivity activity) {
            activityWeakReference = new WeakReference<>(activity);
        }

        @Override
        public void handleMessage(Message msg) {
            UploadActivity activity = activityWeakReference.get();
            if (activity != null) {
                activity.loadingDialog.dismiss();
                strList.clear();
                if (msg.what == 1) {
                    if (msg.obj != null) {
                        try {
                            JSONObject jsonObject = new JSONObject(msg.obj.toString());
                            int errorcode = jsonObject.getInt("errorcode");
                            switch (errorcode) {
                                case 0:
                                    ToastUtils.show(activity, "上传成功");
                                    activity.startActivity(new Intent(activity,OrderDetailActivity.class));
                                    break;
                                case 10:
                                case 12:
                                case 13:
                                    ToastUtils.show(activity, "用户未登录,请先登录");
                                    break;
                                case 14:
                                    ToastUtils.show(activity, "订单不存在");
                                    break;
                                case 15:
                                    ToastUtils.show(activity, "只有待服务的订单能够传图");
                                    break;
                                case 16:
                                    ToastUtils.show(activity, "您尚未绑定该订单");
                                    break;
                                case 17:
                                    ToastUtils.show(activity, "图片数量异常");
                                    break;
                                default:
                                    ToastUtils.show(activity,"服务器繁忙");
                            }
                        } catch (JSONException e) {
                            ToastUtils.show(activity, "服务器繁忙");
                            e.printStackTrace();
                        }
                    } else {
                        ToastUtils.show(activity, "服务器繁忙");
                    }
                }
            }
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_img_add:
                if(strList.size()>=9){
                    ToastUtils.show(this,"图片数量不能超过9张");
                }else {
                    selectPicDialog.show();
                }
                break;
            case R.id.tv_right:
                reqUpload();
                break;
        }
    }

    @Override
    public void selectClick(SelectPicDialog.Type type) {
        switch (type) {
            case CAMERA:
                callCamera();
                break;
            case ALBUM:
                callAlbum();
                break;
        }
    }

    private void callAlbum() {
        startActivity(new Intent(this,PhotoViewActivity.class));
    }

    /**
     * 调用相机
     */
    public void callCamera() {

        boolean IsSDcardExist = Environment.getExternalStorageState().equals(
                android.os.Environment.MEDIA_MOUNTED);
        if (IsSDcardExist) {
            if (!makeImgPath()) {
                ToastUtils.show(this, "请检查您的SD卡");
                return;
            }
        } else {
            ToastUtils.show(this, "路径创建失败");
            return;
        }

        Intent it_zx = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        takephotoname = "IMG_" + timeStamp + ".jpg";
        File f = new File(cameraSavePath, takephotoname);
        Uri u = Uri.fromFile(f);
        it_zx.putExtra(MediaStore.Images.Media.ORIENTATION, 0);
        it_zx.putExtra(MediaStore.EXTRA_OUTPUT, u);
        startActivityForResult(it_zx, 1);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        uploadAdapter.notifyDataSetChanged();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1) {
            if (resultCode == Activity.RESULT_OK) {
                strList.add(cameraSavePath + File.separator + takephotoname);
                uploadAdapter.notifyDataSetChanged();
            }
        } else {
            ToastUtils.show(UploadActivity.this, "拍照失败");
        }
    }

    /**
     * 创建照片保存路径
     */
    private boolean makeImgPath() {
        cameraSavePath = Environment.getExternalStorageDirectory().getPath() + File.separator + "quanmei_service";
        File filePath = new File(cameraSavePath);
        if (!filePath.exists()) {
            filePath.mkdirs();
        }
        if (!filePath.exists()) {
            return false;
        }
        return true;
    }

    class UploadAdapter extends CommonAdapter<String> {

        public UploadAdapter(Context context, List<String> datas, int layoutItemId) {
            super(context, datas, layoutItemId);
        }

        @Override
        public void convert(BaseViewHolder helper, final String item, int position) {
            helper.setImageByUrl(R.id.id_item_image,item);
            helper.getView(R.id.id_item_select).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    UploadActivity.strList.remove(item);
                    uploadAdapter.notifyDataSetChanged();
                }
            });

        }
    }
}
