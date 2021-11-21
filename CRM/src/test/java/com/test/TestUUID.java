package com.test;

import org.junit.Test;
import com.nguyenxb.crm.util.MD5Util;
public class TestUUID {

    @Test
    public void testMD5(){
        System.out.println(MD5Util.getMD5("123456"));
    }
}
