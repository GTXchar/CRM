package com.nguyenxb.crm.workbench.dao;

import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    int save(Contacts con);

    int getTotalByCondition(Map<String, Object> map);

    List<Contacts> getContactsListByCondition(Map<String, Object> map);

    int deleteByArray(String[] ids);

    List<User> getUserList();

    Contacts getByID(String id);

    int update(Contacts contacts);

    Contacts getContactById(String id);

    int unboundActivityById(String id);

    List<Contacts> getContactsListByName(String cname);
}
