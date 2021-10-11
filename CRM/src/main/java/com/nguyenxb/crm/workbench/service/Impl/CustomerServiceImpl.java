package com.nguyenxb.crm.workbench.service.Impl;

import com.nguyenxb.crm.exception.ContactsException;
import com.nguyenxb.crm.exception.CustomerException;
import com.nguyenxb.crm.settings.dao.UserDao;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.util.SqlSessionUtil;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.dao.CustomerDao;
import com.nguyenxb.crm.workbench.dao.CustomerRemarkDao;
import com.nguyenxb.crm.workbench.domain.*;
import com.nguyenxb.crm.workbench.service.CustomerService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerServiceImpl implements CustomerService {
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);

    // 用户相关
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public List<String> getCustomerName(String name) {
        List<String> sList = customerDao.getCustomerName(name);
        return sList;
    }

    @Override
    public paginationVO<Customer> pageList(Map<String, Object> map) {
        //取得dataList
        List<Customer> cList = customerDao.getCustomerListByCondition(map);
        //取得total
        int total = customerDao.getTotalByCondition(map);
        //创建一个vo对象，将total和dataList封装到vo中
        paginationVO<Customer> vo = new paginationVO<>();
        vo.setDataList(cList);
        vo.setTotal(total);
        //将vo返回
        return vo;
    }

    @Override
    public boolean deleteByArray(String[] ids) throws  CustomerException {
        boolean flag = true;
        //查询出需要删除的备注的数量
        int count3 = customerRemarkDao.getCountByCIds(ids);
        //删除备注，返回受影响的条数（实际删除的数量）
        int count4 = customerRemarkDao.deleteByCIds(ids);


        if(count3 != count4){
            flag = false;
        }

        int num = customerDao.deleteByArray(ids);
        if(num < 1 ){
            flag = false;
        }
        if (!flag){
            throw new CustomerException("");
        }
        return flag;
    }

    @Override
    public List<User> getUserList() {
        List<User> userList = customerDao.getUserList();
        return userList;
    }

    @Override
    public boolean save(Customer customer) throws CustomerException {
        boolean flag = true;
        //添加客户
        int count1 = customerDao.save(customer);
        if(count1 != 1){
            flag = false;
        }
        if (!flag){
            throw new CustomerException("");
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndCustomer(String id) {
        // 获取 uList
        List<User> userList = userDao.getUserList();

        // 根据id查Clue
        Customer customer = customerDao.getByID(id);

        Map<String,Object> map = new HashMap<>();
        map.put("success",false);
        if (userList != null && customer != null){
            map.put("success",true);
            map.put("uList",userList);
            map.put("customer",customer);
        }
        return map;
    }

    @Override
    public boolean update(Customer customer) throws CustomerException {
        boolean flag = true;

        int row = customerDao.update(customer);
        if (row != 1){
            flag = false;
        }
        if (!flag){
            throw new CustomerException("");
        }
        return flag;
    }

    @Override
    public Customer getCustomerById(String id) {
        Customer customer = customerDao.getCustomerById(id);
        return customer;
    }

    @Override
    public List<CustomerRemark> getRemarkListById(String cid) {
        List<CustomerRemark> list = customerRemarkDao.getRemarkListById(cid);
        return list;
    }

    @Override
    public boolean saveRemark(CustomerRemark cr) throws CustomerException {
        boolean flag = true;
        int num =  customerRemarkDao.saveRemark(cr);
//        System.out.println(ar);
        if(num != 1){
            flag = false;
        }
        if (!flag){
            throw new CustomerException("");
        }
        return flag;
    }

    @Override
    public boolean deleteRemarkById(String id) throws CustomerException {
        boolean flag = true;
        int num = customerRemarkDao.deleteRemarkById(id);
        if(num != 1){
            flag = false;
        }
        if (!flag){
            throw new CustomerException("");
        }
        return flag;
    }

    @Override
    public boolean updateRemark(CustomerRemark customerRemark) throws CustomerException {
        boolean flag = true;
        int num = customerRemarkDao.updateRemark(customerRemark);
        if (num != 1){
            flag = false;
        }
        if (!flag){
            throw new CustomerException("");
        }
        return flag;
    }


}
