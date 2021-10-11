package com.nguyenxb.crm.settings.dao;

import com.nguyenxb.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getListByCode(String code);
}
