package com.nguyenxb.crm.workbench.service;

import com.nguyenxb.crm.exception.ContactsException;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.domain.Contacts;
import com.nguyenxb.crm.workbench.domain.ContactsRemark;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    paginationVO<Contacts> pageList(Map<String, Object> map);

    boolean deleteByArray(String[] ids) throws ContactsException;

    List<User> getUserList();

    boolean save(Contacts contacts, String customerName) throws ContactsException;

    Map<String, Object> getUserListAndContacts(String id);

    boolean update(Contacts contacts, String customerName);

    Contacts getContactsById(String id);

    List<ContactsRemark> getRemarkListById(String cid);

    boolean updateRemark(ContactsRemark contactsRemark) throws ContactsException;

    boolean saveRemark(ContactsRemark cr) throws ContactsException;

    boolean deleteRemarkById(String id) throws ContactsException;

    boolean unboundActivityById(String id) throws ContactsException;

    boolean bund(String cid, String[] aids) throws ContactsException;

    List<Contacts> getContactsListByName(String cname);
}
