package com.nguyenxb.crm.workbench.service;

import com.nguyenxb.crm.exception.ActivityException;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.domain.Activity;
import com.nguyenxb.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    boolean save(Activity activity) throws ActivityException;

    paginationVO<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] ids) throws ActivityException;

    Map<String, Object> getUserListAndActivity(String id);

    boolean updateActivityRemark(Activity activity) throws ActivityException;

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByAid(String aid);

    boolean deleteRemarkById(String id);

    boolean saveRemark(ActivityRemark ar) throws ActivityException;

    boolean updateRemark(ActivityRemark updateAR) throws ActivityException;

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);

    List<Activity> getActivityListByContactsId(String contactsId);

    List<Activity> getActivityListByNameAndNotByContactsId(Map<String, String> map);
}
