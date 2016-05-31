package com.minfo.quanmeiservice.entity;

import java.io.Serializable;

/**
 * Created by liujing on 16/5/3.
 */
public class Picture implements Serializable {
    private String picUrl;

    public String getPicUrl() {
        return picUrl;
    }

    public void setPicUrl(String picUrl) {
        this.picUrl = picUrl;
    }
}
