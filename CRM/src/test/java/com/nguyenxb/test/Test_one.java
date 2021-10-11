package com.nguyenxb.test;

import com.nguyenxb.crm.util.DateTimeUtil;
import com.nguyenxb.crm.util.MD5Util;
import org.junit.Test;

public class Test_one {
    @Test
    public void testDate(){
        //验证失效时间
        String expireTime = "2019-10-10 10:10:10";

        //当前系统时间
        String currentTime = DateTimeUtil.getSysTime();
        int count = expireTime.compareTo(currentTime);

        String lockState = "0";
        if("0".equals(lockState)){
            System.out.println("账号已锁定");
        }

        //浏览器端的ip地址
        String ip = "192.168.1.3";

        //允许访问的ip地址群
        String allowIps = "192.168.1.1,192.168.1.2";
        if(allowIps.contains(ip)){
            System.out.println("有效的ip地址，允许访问系统");
        }else {
            System.out.println("ip地址受限，清联系管理员");
        }
    }
    @Test
    public void test3(){
        System.out.println(MD5Util.getMD5("123"));
    }

}
