package com.nguyenxb.crm.workbench.dao;

import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    List<User> getUserList();

    int save(Clue clue);

    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    Clue getClueById(String id);

    int unboundActivityById(String id);

    Clue getById(String clueId);

    int delete(String clueId);

    int deleteByArray(String[] ids);

    Clue getByID(String id);

    int update(Clue clue);
}
