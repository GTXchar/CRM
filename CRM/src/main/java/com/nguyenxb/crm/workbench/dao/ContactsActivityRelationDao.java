package com.nguyenxb.crm.workbench.dao;

import com.nguyenxb.crm.workbench.domain.ContactsActivityRelation;

public interface ContactsActivityRelationDao {

    int save(ContactsActivityRelation contactsActivityRelation);

    int bund(ContactsActivityRelation car);

    int getCountByCIds(String[] ids);

    int deleteByCIds(String[] ids);
}
