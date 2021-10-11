package com.nguyenxb.crm.settings.service;

import com.nguyenxb.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicService {
    Map<String, List<DicValue>> getAll();
}
