package com.nguyenxb.crm.workbench.dao;

import com.nguyenxb.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran t);

    Tran detail(String id);

    int changeStage(Tran t);

    int getTotal();

    List<Map<String, Object>> getCharts();

    List<Tran> getTranListByCondition(Map<String, Object> map);

    int getTotalByCondition();

    int deleteByArray(String[] ids);

    int update(Tran t);

    Tran getTranById(String id);

}
