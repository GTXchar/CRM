package com.nguyenxb.crm.workbench.dao;

import com.nguyenxb.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {

    int save(CustomerRemark customerRemark);

    List<CustomerRemark> getRemarkListById(String cid);

    int saveRemark(CustomerRemark cr);

    int deleteRemarkById(String id);

    int updateRemark(CustomerRemark customerRemark);

    int getCountByCIds(String[] ids);

    int deleteByCIds(String[] ids);
}
