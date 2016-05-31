package com.minfo.quanmeiservice.entity;

import java.io.Serializable;

/**
 * Created by liujing on 16/5/15.
 */
public class User implements Serializable {

    private String userid;

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }
}
