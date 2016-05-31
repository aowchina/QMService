package com.minfo.quanmeiservice.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.minfo.quanmeiservice.R;
import com.minfo.quanmeiservice.entity.Order;
import com.minfo.quanmeiservice.http.BaseResponse;
import com.minfo.quanmeiservice.http.RequestListener;
import com.minfo.quanmeiservice.utils.Constant;
import com.minfo.quanmeiservice.utils.ToastUtils;
import com.minfo.quanmeiservice.utils.UniversalImageUtils;
import com.minfo.quanmeiservice.widget.LoadingDialog;
import com.minfo.quanmeiservice.widget.SquareImage;

import java.util.Map;

import butterknife.InjectView;

public class OrderDetailActivity extends BaseActivity implements View.OnClickListener {

    String orderid;

    @InjectView(R.id.iv_product_simg)
    SquareImage ivProductImg;
    @InjectView(R.id.tv_product_name)
    TextView tvProductName;
    @InjectView(R.id.tv_hospital_name)
    TextView tvHospitalName;
    @InjectView(R.id.tv_total_price)
    TextView tvTotalPrice;
    @InjectView(R.id.tv_minus_money)
    TextView tvMinusMoney;
    @InjectView(R.id.tv_real_money)
    TextView tvRealMoney;
    @InjectView(R.id.tv_point)
    TextView tvPoint;
    @InjectView(R.id.tv_time)
    TextView tvTime;
    @InjectView(R.id.tv_orderid)
    TextView tvOrderid;
    @InjectView(R.id.tv_phone)
    TextView tvPhone;
    @InjectView(R.id.btn_upload)
    Button btnUpload;
    Order order;

    private LoadingDialog loadingDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_order_detail);
    }

    @Override
    protected void findViews() {
        loadingDialog = new LoadingDialog(this);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        reqOrderDetail();
    }

    @Override
    protected void initViews() {
        Bundle bundle = getIntent().getBundleExtra("info");
        if (bundle != null) {
            orderid = bundle.getString("orderid");
            reqOrderDetail();
        }
    }

    /**
     * 请求订单详情
     */
    private void reqOrderDetail() {
        String url = getResources().getString(R.string.api_baseurl) + "order/Detail.php";
        Map<String, String> params = utils.getParams(utils.getBasePostStr() + "*" + Constant.user.getUserid() + "*" + orderid);
        httpClient.post(url, params, R.string.loading_msg, new RequestListener() {
            @Override
            public void onPreRequest() {
                loadingDialog.show();
            }

            @Override
            public void onRequestSuccess(BaseResponse response) {
                loadingDialog.dismiss();

                order = response.getObj(Order.class);
                setOrderView();
            }

            @Override
            public void onRequestNoData(BaseResponse response) {
                loadingDialog.dismiss();
                int errorcode = response.getErrorcode();

                if (errorcode == 10 || errorcode == 12 || errorcode == 13) {
                    LoginActivity.isJumpLogin = true;
                    startActivity(new Intent(OrderDetailActivity.this, LoginActivity.class));
                } else if (errorcode == 14) {
                    ToastUtils.show(OrderDetailActivity.this, "订单不存在");
                } else if (errorcode == 15) {
                    ToastUtils.show(OrderDetailActivity.this, "订单尚未预定");
                } else if (errorcode == 16) {
                    ToastUtils.show(OrderDetailActivity.this, "您尚未绑定该订单");
                } else {
                    ToastUtils.show(OrderDetailActivity.this, "服务器繁忙");
                }

            }

            @Override
            public void onRequestError(int code, String msg) {
                loadingDialog.dismiss();
                ToastUtils.show(OrderDetailActivity.this, msg);
            }
        });
    }

    private void setOrderView() {
        UniversalImageUtils.displayImageUseDefOptions(order.getSimg(), ivProductImg);
        tvHospitalName.setText(order.getHname());
        tvOrderid.setText(orderid);
        tvProductName.setText("【" + order.getFname() + "】" + order.getName());
        tvTime.setText(order.getCtime());
        tvTotalPrice.setText(order.getNewval() + "元");
        tvRealMoney.setText("￥" + order.getTrue_pay() + "");
        tvPoint.setText(order.getGet_point());
        tvMinusMoney.setText("(积分抵" + order.getPoint_money() + "元)");
        tvPhone.setText(order.getTel());
        if (!order.getStatus().equals("5")) {
            btnUpload.setVisibility(View.INVISIBLE);
        }

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_upload:
                Constant.orderid = orderid;
                startActivity(new Intent(this, UploadActivity.class));
                break;
        }
    }
}
