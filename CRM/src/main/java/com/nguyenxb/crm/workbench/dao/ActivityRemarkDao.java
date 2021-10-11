package com.nguyenxb.crm.workbench.dao;

import com.nguyenxb.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    int delete(String[] ids);

    List<ActivityRemark> getRemarkListByAid(String aid);

    int deleteRemarkById(String id);

    int saveRemark(ActivityRemark ar);

    int updateRemark(ActivityRemark updateAR);
}
