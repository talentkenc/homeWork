package com.biz.lesson.vo.student.student;

import java.io.Serializable;
import java.sql.Date;

public class StudentSearchVo implements Serializable {

    private static final long serialVersionUID = -5773229209604403368L;

    private String name;
    
    private String code;
    
    private Date fromDate;
    
    private Date toDate;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }
    
    
    
    

}
