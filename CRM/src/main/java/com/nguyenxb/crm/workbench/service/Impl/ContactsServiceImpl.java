package com.nguyenxb.crm.workbench.service.Impl;

import com.nguyenxb.crm.exception.ClueException;
import com.nguyenxb.crm.exception.ContactsException;
import com.nguyenxb.crm.settings.dao.UserDao;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.util.SqlSessionUtil;
import com.nguyenxb.crm.util.UUIDUtil;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.dao.ContactsActivityRelationDao;
import com.nguyenxb.crm.workbench.dao.ContactsDao;
import com.nguyenxb.crm.workbench.dao.ContactsRemarkDao;
import com.nguyenxb.crm.workbench.dao.CustomerDao;
import com.nguyenxb.crm.workbench.domain.*;
import com.nguyenxb.crm.workbench.service.ContactsService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ContactsServiceImpl implements ContactsService {
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);

    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    // 用户相关
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    @Override
    public paginationVO<Contacts> pageList(Map<String, Object> map) {
        //获取total总页数
        int total = contactsDao.getTotalByCondition(map);
        //获取ContactsList
        List<Contacts> cList = contactsDao.getContactsListByCondition(map);
        //将total和ContactsList封装到vo中
        paginationVO<Contacts> vo = new paginationVO<>();
        vo.setTotal(total);
        vo.setDataList(cList);
        //将vo返回

        return vo;
    }

    @Override
    public boolean deleteByArray(String[] ids) throws ContactsException {
        boolean flag = true;

        //查询出需要删除的备注的数量
        int count1 = contactsActivityRelationDao.getCountByCIds(ids);
        //删除备注，返回受影响的条数（实际删除的数量）
        int count2 = contactsActivityRelationDao.deleteByCIds(ids);

        if(count1 != count2){
            flag = false;
        }
        //查询出需要删除的备注的数量
        int count3 = contactsRemarkDao.getCountByCIds(ids);
        //删除备注，返回受影响的条数（实际删除的数量）
        int count4 = contactsRemarkDao.deleteByCIds(ids);


        if(count3 != count4){
            flag = false;
        }
        int num = contactsDao.deleteByArray(ids);
        if(num < 1){
            flag = false;
        }
        if (!flag){
            throw new ContactsException("");
        }
        return flag;
    }

    @Override
    public List<User> getUserList() {
        List<User> userList = contactsDao.getUserList();
        return userList;
    }

    @Override
    public boolean save(Contacts contacts, String customerName) throws ContactsException {
        boolean flag = true;
        Customer cus = customerDao.getCustomerByName(customerName);
        //如果cus为null，需要创建客户
        if(cus == null){
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(contacts.getCreateBy());
            cus.setCreateTime(contacts.getCreateTime());
            cus.setContactSummary(contacts.getContactSummary());
            cus.setNextContactTime(contacts.getNextContactTime());
            cus.setOwner(contacts.getOwner());
            //添加客户
            int count1 = customerDao.save(cus);
            if(count1 != 1){
                flag = false;
            }
        }

        contacts.setCustomerId(cus.getId());

        //添加交易
        int count2 = contactsDao.save(contacts);
        if(count2 != 1){
            flag = false;
        }
        if (!flag){
            throw new ContactsException("");
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndContacts(String id) {
        // 获取 uList
        List<User> userList = userDao.getUserList();

        // 根据id查Clue
         Contacts contacts = contactsDao.getByID(id);

         Customer customer = customerDao.getByID(contacts.getCustomerId());
        Map<String,Object> map = new HashMap<>();
        map.put("success",false);
        if (userList != null && contacts != null){
            map.put("success",true);
            map.put("uList",userList);
            map.put("contacts",contacts);
            map.put("customerName",customer.getName());
        }
        return map;
    }

    @Override
    public boolean update(Contacts contacts, String customerName) {

        boolean flag = false;

        Customer cus = customerDao.getCustomerByName(customerName);
        //如果cus为null，需要创建客户
        if(cus == null){
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(contacts.getEditBy());
            cus.setCreateTime(contacts.getEditTime());
            cus.setContactSummary(contacts.getContactSummary());
            cus.setNextContactTime(contacts.getNextContactTime());
            cus.setOwner(contacts.getOwner());
            //添加客户
            int count1 = customerDao.save(cus);
            if(count1 != 1){
                flag = false;
            }
        }
        contacts.setCustomerId(cus.getId());

        int rows = contactsDao.update(contacts);

        if (rows == 1){
            flag = true;
        }
        return flag;

    }

    @Override
    public Contacts getContactsById(String id) {
        Contacts contacts = contactsDao.getContactById(id);
        return contacts;
    }

    @Override
    public List<ContactsRemark> getRemarkListById(String cid) {
        List<ContactsRemark> list = contactsRemarkDao.getRemarkListById(cid);
        return list;
    }

    @Override
    public boolean updateRemark(ContactsRemark contactsRemark) throws ContactsException {
        boolean flag = true;
        int num = contactsRemarkDao.updateRemark(contactsRemark);
        if (num != 1){
            flag = false;
        }
        if (!flag){
            throw new ContactsException("");
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ContactsRemark cr) throws ContactsException {
        boolean flag = true;
        int num =  contactsRemarkDao.saveRemark(cr);
//        System.out.println(ar);
        if(num != 1){
            flag = false;
        }
        if (!flag){
            throw new ContactsException("");
        }
        return flag;
    }

    @Override
    public boolean deleteRemarkById(String id) throws ContactsException {

        boolean flag = true;
        int num = contactsRemarkDao.deleteRemarkById(id);
        if(num != 1){
            flag = false;
        }
        if (!flag){
            throw new ContactsException("");
        }
        return flag;

    }

    @Override
    public boolean unboundActivityById(String id) throws ContactsException {
        boolean flag = true;
        int num = contactsDao.unboundActivityById(id);
        if (num != 1) {
            flag = false;
        }
        if (!flag){
            throw new ContactsException("");
        }
        return flag;
    }

    @Override
    public boolean bund(String cid, String[] aids) throws ContactsException {
        boolean flag = true;
        for (String aid : aids) {
            //取得每一个aid和cid做关联
            ContactsActivityRelation car = new ContactsActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setContactsId(cid);
            car.setActivityId(aid);
            //添加关联关系表中的记录
            int count = contactsActivityRelationDao.bund(car);

            if (count != 1) {
                flag = false;
            }
        }
        if (!flag){
            throw new ContactsException("");
        }
        return flag;
    }

    @Override
    public List<Contacts> getContactsListByName(String cname) {
        List<Contacts> aList = contactsDao.getContactsListByName(cname);
        return aList;
    }
}
