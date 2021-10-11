package com.nguyenxb.crm.workbench.dao;

import com.nguyenxb.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkDao {

    int save(ContactsRemark contactsRemark);

    List<ContactsRemark> getRemarkListById(String cid);

    int updateRemark(ContactsRemark contactsRemark);

    int saveRemark(ContactsRemark cr);

    int deleteRemarkById(String id);

    int getCountByCIds(String[] ids);

    int deleteByCIds(String[] ids);
}
