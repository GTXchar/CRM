package com.nguyenxb.crm.workbench.dao;

import com.nguyenxb.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getListByClueId(String clueId);

    int delete(ClueRemark clueRemark);

    List<ClueRemark> getRemarkListById(String cid);

    int saveRemark(ClueRemark cr);

    int deleteRemarkById(String id);

    int updateRemark(ClueRemark updateCR);

    int getCountByCIds(String[] ids);

    int deleteByCIds(String[] ids);
}
