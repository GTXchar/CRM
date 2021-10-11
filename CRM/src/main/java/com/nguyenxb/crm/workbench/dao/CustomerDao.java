package com.nguyenxb.crm.workbench.dao;

import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer cus);

    List<String> getCustomerName(String name);

    List<Customer> getCustomerListByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    int deleteByArray(String[] ids);

    Customer getByID(String customerId);

    List<User> getUserList();

    int update(Customer customer);

    Customer getCustomerById(String id);
}
