package com.minfo.quanmeiservice.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.minfo.quanmeiservice.R;
import com.minfo.quanmeiservice.entity.User;
import com.minfo.quanmeiservice.http.BaseResponse;
import com.minfo.quanmeiservice.http.RequestListener;
import com.minfo.quanmeiservice.utils.Constant;
import com.minfo.quanmeiservice.utils.ToastUtils;
import com.minfo.quanmeiservice.widget.LoadingDialog;

import java.util.Map;

import butterknife.InjectView;
import butterknife.OnClick;

public class LoginActivity extends BaseActivity {

    @InjectView(R.id.btn_login_normal)
    Button btnLogin;
    @InjectView(R.id.et_user_name)
    EditText etUserName;
    @InjectView(R.id.et_password)
    EditText etPwd;

    String username;
    String password;

    LoadingDialog loadingDialog;

    public static boolean isJumpLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        loadingDialog = new LoadingDialog(this);
    }

    @Override
    protected void findViews() {

    }

    @Override
    protected void initViews() {

        etUserName.setText(utils.getUsername());
        etPwd.setText(utils.getPassword());

    }

    @OnClick({R.id.btn_login_normal})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_login_normal:
                if (check()) {
                    reqLogin();
                }
                break;
        }
    }

    private boolean check() {
        username = etUserName.getText().toString();
        password = etPwd.getText().toString();
        return !username.isEmpty();
    }

    /**
     * 请求登录接口
     */
    private void reqLogin() {
        String url = getString(R.string.api_baseurl) + "public/Login.php";

        Map<String, String> params = utils.getParams(utils.getBasePostStr() + "*" + username + "*" + password);
        httpClient.post(url, params, R.string.loading_msg, new RequestListener() {
            @Override
            public void onPreRequest() {
                loadingDialog.show();
            }

            @Override
            public void onRequestSuccess(BaseResponse response) {
                loadingDialog.dismiss();
                User user = response.getObj(User.class);

                utils.setUsername(username);
                utils.setPassword(password);

                Constant.user = user;
                if(!isJumpLogin) {
                    startActivity(new Intent(LoginActivity.this, OrderListActivity.class));
                }
                LoginActivity.this.finish();

            }

            @Override
            public void onRequestNoData(BaseResponse response) {
                loadingDialog.dismiss();
                ToastUtils.show(LoginActivity.this, "服务器繁忙"+response.getErrorcode());
            }

            @Override
            public void onRequestError(int code, String msg) {
                loadingDialog.dismiss();
                ToastUtils.show(LoginActivity.this, msg);
            }
        });
    }
}
