package com.nguyenxb.crm.workbench.service;

import com.nguyenxb.crm.exception.TranException;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.domain.Tran;
import com.nguyenxb.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    boolean save(Tran t, String customerName) throws TranException;

    Tran detail(String id);

    List<TranHistory> getHistoryListByTranId(String tranId);

    boolean changeStage(Tran t) throws TranException;

    Map<String, Object> getCharts();

    paginationVO<Tran> pageList(Map<String, Object> map);

    boolean deleteByArray(String[] ids) throws TranException;

    boolean update(Tran t, String customerName);

    Map<String, Object> edit(String id) throws TranException;
}
