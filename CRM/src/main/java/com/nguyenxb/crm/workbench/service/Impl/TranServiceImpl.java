package com.nguyenxb.crm.workbench.service.Impl;

import com.nguyenxb.crm.exception.ContactsException;
import com.nguyenxb.crm.exception.TranException;
import com.nguyenxb.crm.settings.dao.UserDao;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.util.DateTimeUtil;
import com.nguyenxb.crm.util.SqlSessionUtil;
import com.nguyenxb.crm.util.UUIDUtil;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.dao.*;
import com.nguyenxb.crm.workbench.domain.*;
import com.nguyenxb.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranServiceImpl implements TranService {
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);

    @Override
    public boolean save(Tran t, String customerName) throws TranException {
        boolean flag = true;
        /*
            交易添加业务：
            在做添加之前，参数t里面就少了一项信息，就是客户的主键，customerId
            先处理客户相关的需求
                （1）判断customerName，根据客户名称在客户表进行精确查询
                    如果有这个客户，则取出这个客户的id，封装到t对象中
                    如果没有这个客户，则在客户表新建一条客户信息，然后将新建的客户id取出，封装到t对象中
                （2）经过以上操作后，t对象中的信息就全了，需要执行添加交易的操作
                （3）添加交易完毕后，需要创建一条交易历史
         */
        Customer cus = customerDao.getCustomerByName(customerName);
        //如果cus为null，需要创建客户
        if(cus == null){
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(t.getCreateTime());
            cus.setContactSummary(t.getContactSummary());
            cus.setNextContactTime(t.getNextContactTime());
            cus.setOwner(t.getOwner());
            //添加客户
            int count1 = customerDao.save(cus);
            if(count1 != 1){
                flag = false;
            }
        }
        //通过以上对于客户的处理，不论是查询出来已有的客户，还是以前没有我们新增的客户，总之客户已经有了，客户的id就有了
        //将客户的id封装到t对象中
        t.setCustomerId(cus.getId());
        //添加交易
        int count2 = tranDao.save(t);
        if(count2 != 1){
            flag = false;
        }
        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(t.getCreateTime());
        th.setCreateBy(t.getCreateBy());

        int count3 = tranHistoryDao.save(th);
        if(count3 != 1){
            flag = false;
        }
        if (!flag){
            throw new TranException("");
        }
        return flag;
    }

    @Override
    public Tran detail(String id) {
        Tran t = tranDao.detail(id);
        return t;
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {
        List<TranHistory> thList = tranHistoryDao.getHistoryListByTranId(tranId);
        return thList;
    }

    @Override
    public boolean changeStage(Tran t) throws TranException {
        boolean flag = true;
        //改变交易阶段
        int count1 =    tranDao.changeStage(t);
        if(count1 != 1){
            flag = false;
        }
        //交易阶段改变后，生成一条交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setPossibility(t.getPossibility());
        //添加交易历史
        int num = tranHistoryDao.save(th);
        if(num != 1){
            flag = false;
        }
        if (!flag){
            throw new TranException("");
        }
        return flag;
    }

    @Override
    public Map<String, Object> getCharts() {
        //取得total
        int total = tranDao.getTotal();
        //取得dataList
        List<Map<String,Object>> dataList = tranDao.getCharts();
        //将total和dataList保存到map中
        Map<String ,Object> map = new HashMap<String ,Object>();
        map.put("total",total);
        map.put("dataList",dataList);
        //返回map

        return map;
    }

    @Override
    public paginationVO<Tran> pageList(Map<String, Object> map) {
        //取得total
        int total = tranDao.getTotalByCondition();
        //取得dataList
        List<Tran> tList = tranDao.getTranListByCondition(map);
        //创建一个vo对象，将total和dataList封装到vo中
        paginationVO<Tran> vo = new paginationVO<>();
        vo.setTotal(total);
        vo.setDataList(tList);

        //将vo返回
        return vo;
    }

    @Override
    public boolean deleteByArray(String[] ids) throws TranException {
        boolean flag = true;
        int num = tranDao.deleteByArray(ids);
        if(num < 1){
            flag = false;
        }
        if (!flag){
            throw new TranException("");
        }
        return flag;
    }

    @Override
    public boolean update(Tran t, String customerName) {
        boolean flag = true;
        /*
            交易添加业务：
            在做添加之前，参数t里面就少了一项信息，就是客户的主键，customerId
            先处理客户相关的需求
                （1）判断customerName，根据客户名称在客户表进行精确查询
                    如果有这个客户，则取出这个客户的id，封装到t对象中
                    如果没有这个客户，则在客户表新建一条客户信息，然后将新建的客户id取出，封装到t对象中
                （2）经过以上操作后，t对象中的信息就全了，需要执行添加交易的操作
                （3）添加交易完毕后，需要创建一条交易历史
         */
        Customer cus = customerDao.getCustomerByName(customerName);
        //如果cus为null，需要创建客户
        if(cus == null){
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(t.getCreateTime());
            cus.setContactSummary(t.getContactSummary());
            cus.setNextContactTime(t.getNextContactTime());
            cus.setOwner(t.getOwner());
            //添加客户
            int count1 = customerDao.save(cus);
            if(count1 != 1){
                flag = false;
            }
        }
        //通过以上对于客户的处理，不论是查询出来已有的客户，还是以前没有我们新增的客户，总之客户已经有了，客户的id就有了
        //将客户的id封装到t对象中
        t.setCustomerId(cus.getId());
        //添加交易
        int count2 = tranDao.update(t);
        if(count2 != 1){
            flag = false;
        }
        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(t.getCreateTime());
        th.setCreateBy(t.getCreateBy());

        int count3 = tranHistoryDao.save(th);
        if(count3 != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public Map<String, Object> edit(String id) throws TranException {
        boolean flag = true;
        Map<String,Object> map = new HashMap<>();

        List<User> uList = userDao.getUserList();
        if (uList==null){
            flag = false;
        }

        Tran tran =  tranDao.getTranById(id);
        if (tran==null){
            flag = false;
        }else {
            if (tran.getActivityId()!=null){
                Activity activity = activityDao.getById(tran.getActivityId());
                map.put("activity",activity);
            }
            if (tran.getContactsId()!=null){
                Contacts contacts = contactsDao.getByID(tran.getContactsId());
                map.put("contacts",contacts);
            }
            if (tran.getCustomerId()!=null){
                Customer customer = customerDao.getByID(tran.getCustomerId());
                map.put("customer",customer);
            }
        }
        map.put("success",flag);
        if (flag){
            map.put("uList",uList);
            map.put("tran",tran);
        }
        if (!flag){
            throw new TranException("");
        }
        return map;
    }
}
