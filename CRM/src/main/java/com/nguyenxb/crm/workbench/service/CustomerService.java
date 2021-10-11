package com.nguyenxb.crm.workbench.service;

import com.nguyenxb.crm.exception.ContactsException;
import com.nguyenxb.crm.exception.CustomerException;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.domain.Customer;
import com.nguyenxb.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    List<String> getCustomerName(String name);


    paginationVO<Customer> pageList(Map<String, Object> map);

    boolean deleteByArray(String[] ids) throws ContactsException, CustomerException;

    List<User> getUserList();

    boolean save(Customer customer) throws ContactsException, CustomerException;

    Map<String, Object> getUserListAndCustomer(String id);

    boolean update(Customer customer) throws ContactsException, CustomerException;

    Customer getCustomerById(String id);

    List<CustomerRemark> getRemarkListById(String cid);

    boolean saveRemark(CustomerRemark cr) throws ContactsException, CustomerException;

    boolean deleteRemarkById(String id) throws ContactsException, CustomerException;

    boolean updateRemark(CustomerRemark customerRemark) throws ContactsException, CustomerException;
}
