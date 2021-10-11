package com.nguyenxb.crm.settings.dao;

import com.nguyenxb.crm.settings.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface UserDao {

    User login(Map<String, String> map);

    List<User> getUserList();

    int getUserBypassword(@Param("loginId") String loginId, @Param("oldPwd") String oldPwd);

    int updatePassword(@Param("loginId")String loginId, @Param("newPwd") String newPwd);
}
