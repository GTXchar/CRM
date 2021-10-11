package com.nguyenxb.crm.workbench.dao;

import com.nguyenxb.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {


    int bund(ClueActivityRelation car);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int delete(ClueActivityRelation clueActivityRelation);


    int getCountByCIds(String[] ids);

    int deleteByCIds(String[] ids);
}
