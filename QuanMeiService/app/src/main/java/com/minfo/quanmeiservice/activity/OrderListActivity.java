package com.minfo.quanmeiservice.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.minfo.quanmeiservice.R;
import com.minfo.quanmeiservice.adapter.BaseViewHolder;
import com.minfo.quanmeiservice.adapter.CommonAdapter;
import com.minfo.quanmeiservice.entity.Order;
import com.minfo.quanmeiservice.http.BaseResponse;
import com.minfo.quanmeiservice.http.RequestListener;
import com.minfo.quanmeiservice.utils.Constant;
import com.minfo.quanmeiservice.utils.ToastUtils;
import com.minfo.quanmeiservice.utils.UniversalImageUtils;
import com.minfo.quanmeiservice.widget.LoadingDialog;
import com.minfo.quanmeiservice.widget.RefreshListView;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class OrderListActivity extends BaseActivity implements View.OnClickListener {

    private OrderPayAdapter orderPayAdapter;
    private List<Order> orderList = new ArrayList<>();

    private RefreshListView lvOrderPay;

    private LinearLayout llScan;
    private boolean isRefresh;
    private boolean isLoad;
    private LoadingDialog loadingDialog;
    private List<Order> tempList = new ArrayList<>();
    private int page = 1;
    //quanmei20160515144313

    private EditText etSearch;
    private String content;

    public static MyHandler myHandler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_order_list);
        myHandler = new MyHandler(this);
    }

    @Override
    protected void findViews() {
        lvOrderPay = (RefreshListView) findViewById(R.id.lv_order);
        llScan = (LinearLayout) findViewById(R.id.ll_scan);
        llScan.setOnClickListener(this);
        loadingDialog = new LoadingDialog(this);
        etSearch = (EditText) findViewById(R.id.ed_search);
    }

    @Override
    protected void initViews() {

        orderPayAdapter = new OrderPayAdapter(this, orderList, R.layout.item_order_layout);
        lvOrderPay.setAdapter(orderPayAdapter);

        lvOrderPay.setRefreshListener(new RefreshListView.IrefreshListener() {
            @Override
            public void onRefresh() {
                page = 1;
                isRefresh = true;
                reqMyOrdeList();
            }
        });
        lvOrderPay.setLoadListener(new RefreshListView.ILoadListener() {
            @Override
            public void onLoad() {
                page++;
                isLoad = true;
                reqMyOrdeList();
            }
        });
        lvOrderPay.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Bundle bundle = new Bundle();
                bundle.putString("orderid", orderList.get(position - 1).getOrderid());
                utils.jumpAty(OrderListActivity.this, OrderDetailActivity.class, bundle);
            }
        });

        etSearch.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_SEARCH) {
                    content = etSearch.getText().toString();
                    if (content == null || content.equals("")) {
                        ToastUtils.show(OrderListActivity.this, "请输入内容！");
                    } else {
                        etSearch.setText(content);
                        reqBind(content);
                    }
                }
                return false;
            }
        });

        reqMyOrdeList();
    }

    /**
     * 绑定接口
     *
     * @param content
     */
    private void reqBind(String content) {
        String url = getResources().getString(R.string.api_baseurl) + "order/Band.php";
        Map<String, String> params = utils.getParams(utils.getBasePostStr() + "*" + Constant.user.getUserid() + "*" + content);
        httpClient.post(url, params, R.string.loading_msg, new RequestListener() {
            @Override
            public void onPreRequest() {

            }

            @Override
            public void onRequestSuccess(BaseResponse response) {
                String orderid = "";
                try {
                    JSONObject jsonObject = new JSONObject(response.toString());
                    orderid = jsonObject.getString("orderid");

                } catch (JSONException e) {
                    e.printStackTrace();
                }
                Bundle bundle = new Bundle();
                bundle.putString("orderid", orderid);
                utils.jumpAty(OrderListActivity.this, OrderDetailActivity.class, bundle);
            }

            @Override
            public void onRequestNoData(BaseResponse response) {
                int errorcode = response.getErrorcode();
                if (errorcode == 10 || errorcode == 12 || errorcode == 13) {
                    startActivity(new Intent(OrderListActivity.this, LoginActivity.class));
                } else if (errorcode == 14) {
                    ToastUtils.show(OrderListActivity.this, "订单不存在");
                } else if (errorcode == 15) {
                    ToastUtils.show(OrderListActivity.this, "订单尚未支付全款");
                } else if (errorcode == 16) {
                    ToastUtils.show(OrderListActivity.this, "订单已绑定其他服务人员");
                } else {
                    ToastUtils.show(OrderListActivity.this, "服务器繁忙");
                }
            }

            @Override
            public void onRequestError(int code, String msg) {
                ToastUtils.show(OrderListActivity.this, msg);
            }
        });
    }

    private static class MyHandler extends Handler {
        private WeakReference<OrderListActivity> activityWeakReference;
        public MyHandler(OrderListActivity activity){
            activityWeakReference = new WeakReference<>(activity);
        }

        @Override
        public void handleMessage(Message message){
            OrderListActivity activity = activityWeakReference.get();
            if(activity!=null){
                if(message.what==1&&message.obj!=null){
                    activity.reqBind(message.obj.toString());
                }
            }
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ll_scan:
                Intent intent = new Intent(this, CaptureActivity.class);
                startActivity(intent);
                break;
        }
    }


    /**
     * 请求我的订单接口
     */
    private void reqMyOrdeList() {
        String url = getResources().getString(R.string.api_baseurl) + "order/List.php";
        Map<String, String> params = utils.getParams(utils.getBasePostStr() + "*" + Constant.user.getUserid() + "*" + page);
        httpClient.post(url, params, R.string.loading_msg, new RequestListener() {
            @Override
            public void onPreRequest() {
                if (!isRefresh && !isLoad) {
                    loadingDialog.show();
                }
            }

            @Override
            public void onRequestSuccess(BaseResponse response) {
                loadingDialog.dismiss();
                tempList = response.getList(Order.class);
                if (isRefresh) {
                    isRefresh = false;
                    lvOrderPay.refreshComplete();
                    orderList.clear();
                }
                if (isLoad) {
                    isLoad = false;
                    lvOrderPay.loadComplete();
                }
                orderList.addAll(tempList);
                orderPayAdapter.notifyDataSetChanged();
            }

            @Override
            public void onRequestNoData(BaseResponse response) {
                loadingDialog.dismiss();
                lvOrderPay.refreshComplete();
                lvOrderPay.loadComplete();
                ToastUtils.show(OrderListActivity.this, "服务器繁忙"+response.getErrorcode());
            }

            @Override
            public void onRequestError(int code, String msg) {
                lvOrderPay.refreshComplete();
                lvOrderPay.loadComplete();
                ToastUtils.show(OrderListActivity.this, msg);

            }
        });
    }

    class OrderPayAdapter extends CommonAdapter<Order> {

        public OrderPayAdapter(Context context, List<Order> datas, int layoutItemId) {
            super(context, datas, layoutItemId);
        }

        @Override
        public void convert(BaseViewHolder helper, Order item, int position) {
            helper.setText(R.id.tv_date, item.getCreate_time());
            helper.setText(R.id.tv_orderid, item.getOrderid());
            helper.setText(R.id.tv_name, "【" + item.getFname() + "】" + item.getName());
            helper.setText(R.id.tv_price, "￥" + item.getNewval());
            helper.setText(R.id.tv_hospital_name, item.getHname());

            UniversalImageUtils.displayImageUseDefOptions(item.getSimg(), (ImageView) helper.getView(R.id.iv_product_simg));
        }
    }
}
