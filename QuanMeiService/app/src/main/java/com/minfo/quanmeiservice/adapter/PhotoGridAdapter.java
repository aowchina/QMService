package com.minfo.quanmeiservice.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.ImageView;

import com.minfo.quanmeiservice.R;
import com.minfo.quanmeiservice.utils.ToastUtils;

import java.util.List;

/**
 * Created by liujing on 15/10/7.
 */
public class PhotoGridAdapter extends CommonAdapter<String> {

    /**
     * 用户选择的图片，存储为图片的完整路径
     */
    public List<String> mSelectedImage ;
    private ItemSelectedListener itemSelectedListener;

    public PhotoGridAdapter(Context context, List<String> mDatas, int itemLayoutId,ItemSelectedListener itemSelectedListener, List<String> mSelectedImage)
    {
        super(context, mDatas, itemLayoutId);
        this.itemSelectedListener = itemSelectedListener;
        this.mSelectedImage = mSelectedImage;
    }

    @Override
    public void convert(final BaseViewHolder helper, final String item,int position)
    {
        //设置no_selected
        helper.setImageResource(R.id.id_item_select,
                R.mipmap.album_photo_select_normal);
        //设置图片
        helper.setImageByUrl(R.id.id_item_image, item);

        final ImageView mImageView = helper.getView(R.id.id_item_image);
        final ImageView mSelect = helper.getView(R.id.id_item_select);

        mImageView.setColorFilter(null);
        //设置ImageView的点击事件
        mSelect.setOnClickListener(new View.OnClickListener()
        {
            //选择，则将图片变暗，反之则反之
            @Override
            public void onClick(View v)
            {
                if (mSelectedImage.contains(item))//选择过
                {
                    mSelectedImage.remove(item);
                    mSelect.setImageResource(R.mipmap.album_photo_select_normal);
                    mImageView.setColorFilter(null);
                } else//未选择
                {
                    if(mSelectedImage.size()==9){
                        ToastUtils.show(context, "图片不能超过9张");
                    }else {
                        mSelectedImage.add(item);
                        mSelect.setImageResource(R.mipmap.album_photo_select_choose);
                        mImageView.setColorFilter(Color.parseColor("#77000000"));
                    }
                }
                itemSelectedListener.showSelected(mSelectedImage);

            }
        });
        itemSelectedListener.showSelected(mSelectedImage);

        /**
         * 已经选择过的图片，显示出选择过的效果
         */
        if(mSelectedImage!=null) {
            if (mSelectedImage.contains(item)) {
                mSelect.setImageResource(R.mipmap.album_photo_select_choose);
                mImageView.setColorFilter(Color.parseColor("#77000000"));
            }
        }

    }
    public interface ItemSelectedListener{
        void showSelected(List<String> selectImgUrls);
    }
}
