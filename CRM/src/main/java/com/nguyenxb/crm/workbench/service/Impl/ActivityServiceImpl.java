package com.nguyenxb.crm.workbench.service.Impl;

import com.nguyenxb.crm.exception.ActivityException;
import com.nguyenxb.crm.settings.dao.UserDao;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.util.SqlSessionUtil;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.dao.ActivityDao;
import com.nguyenxb.crm.workbench.dao.ActivityRemarkDao;
import com.nguyenxb.crm.workbench.domain.Activity;
import com.nguyenxb.crm.workbench.domain.ActivityRemark;
import com.nguyenxb.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    @Override
    public boolean save(Activity activity) throws ActivityException {
        boolean flag = true;
        int count = activityDao.save(activity);
        if(count != 1){
            flag = false;
        }
        if (!flag){
            throw new ActivityException("");
        }
        return true;
    }

    @Override
    public paginationVO<Activity> pageList(Map<String, Object> map) {
        //取得total
        int total = activityDao.getTotalByCondition(map);
        //取得dataList
        List<Activity> dataList = activityDao.getActivityListByCondition(map);
        //创建一个vo对象，将total和dataList封装到vo中
        paginationVO<Activity> vo = new paginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //将vo返回


        return vo;
    }

    @Override
    public boolean delete(String[] ids) throws ActivityException {
        boolean flag = true;
        //查询出需要删除的备注的数量
        int count_one = activityRemarkDao.getCountByAids(ids);
        //删除备注，返回受影响的条数（实际删除的数量）
        int count_two = activityRemarkDao.deleteByAids(ids);

        if(count_one != count_two){
            flag = false;
        }

        //删除市场活动
        int count_three = activityRemarkDao.delete(ids);
        if(count_three != ids.length){
            flag = false;
        }
        if (!flag){
            throw new ActivityException("");
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {
        //取uList
        List<User> uList = userDao.getUserList();
        //取 a
        Activity a = activityDao.getById(id);
        //将uList和a打包到map中
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("uList",uList);
        map.put("a",a);
        //返回map
        return map;
    }

    @Override
    public boolean updateActivityRemark(Activity activity) throws ActivityException {
        boolean flag = true;
        int num = activityDao.update(activity);
        if(num != 1){
            //更新失败
            flag = false;
        }
        if (!flag){
            throw new ActivityException("");
        }
        return flag;
    }

    @Override
    public Activity detail(String id) {
        Activity activity = activityDao.detail(id);
        return activity;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String Aid) {
        List<ActivityRemark> list = activityRemarkDao.getRemarkListByAid(Aid);
        return list;
    }

    @Override
    public boolean deleteRemarkById(String id) {
        boolean result = true;
        int num = activityRemarkDao.deleteRemarkById(id);
        if(num != 1){
            result = false;
        }
        return result;
    }

    @Override
    public boolean saveRemark(ActivityRemark ar) throws ActivityException {
        boolean flag = true;
        int num =  activityRemarkDao.saveRemark(ar);
        System.out.println(ar);
        if(num != 1){
            flag = false;
        }
        if (!flag){
            throw new ActivityException("");
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark updateAR) throws ActivityException {
        boolean flag = true;
        int num = activityRemarkDao.updateRemark(updateAR);
        if (num != 1){
            flag = false;
        }
        if (!flag){
            throw new ActivityException("");
        }
        return flag;
    }

    @Override
    public List<Activity> getActivityListByClueId(String clueId) {
       List<Activity> aList =  activityDao.getActivityListByClueId(clueId);

        return aList;
    }

    @Override
    public List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map) {
        List<Activity> aList = activityDao.getActivityListByNameAndNotByClueId(map);
        return aList;
    }

    @Override
    public List<Activity> getActivityListByName(String aname) {
        List<Activity> aList = activityDao.getActivityListByName(aname);
        return aList;
    }

    @Override
    public List<Activity> getActivityListByContactsId(String contactsId) {
        List<Activity> aList =  activityDao.getActivityListByContactsId(contactsId);

        return aList;
    }

    @Override
    public List<Activity> getActivityListByNameAndNotByContactsId(Map<String, String> map) {
        List<Activity> aList = activityDao.getActivityListByNameAndNotByContactsId(map);
        return aList;

    }
}

