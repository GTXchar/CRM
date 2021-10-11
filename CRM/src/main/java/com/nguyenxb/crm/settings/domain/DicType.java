package com.nguyenxb.crm.settings.domain;

public class DicType {
    private String code; //主键，类型
    private String name; //名称
    private String description; //描述

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
