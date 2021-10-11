package com.nguyenxb.crm.workbench.service;

import com.nguyenxb.crm.exception.ClueException;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.domain.Clue;
import com.nguyenxb.crm.workbench.domain.ClueRemark;
import com.nguyenxb.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {

    List<User> getUserList();

    boolean save(Clue clue);

    paginationVO<Clue> pageList(Map<String, Object> map);

    Clue getClueById(String id);

    boolean unboundActivityById(String id) throws ClueException;

    boolean bund(String cid, String[] aids) throws ClueException;


    boolean convert(String clueId, Tran t,String createBy) throws ClueException;

    boolean deleteByArray(String[] ids) throws ClueException;

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue clue) throws ClueException;

    List<ClueRemark> getRemarkListById(String cid);

    boolean saveRemark(ClueRemark cr);

    boolean deleteRemarkById(String id) throws ClueException;

    boolean updateRemark(ClueRemark updateCR) throws ClueException;
}
