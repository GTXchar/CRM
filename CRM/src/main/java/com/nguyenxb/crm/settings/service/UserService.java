package com.nguyenxb.crm.settings.service;

import com.nguyenxb.crm.exception.LoginException;
import com.nguyenxb.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();


    boolean updataPwd(String loginId, String oldPwd, String newPwd);
}
