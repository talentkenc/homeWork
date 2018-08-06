package com.biz.lesson.model.student;

import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class uniquekey implements Serializable {
    public Integer stu_Id;
    public Integer sub_Id;

    public Integer getStu_Id() {
        return stu_Id;
    }

    public void setStu_Id(Integer stu_Id) {
        this.stu_Id = stu_Id;
    }

    public Integer getSub_Id() {
        return sub_Id;
    }

    public void setSub_Id(Integer sub_Id) {
        this.sub_Id = sub_Id;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof uniquekey)) return false;
        uniquekey uniquekey = (uniquekey) o;
        return Objects.equals(getStu_Id(), uniquekey.getStu_Id()) &&
                Objects.equals(getSub_Id(), uniquekey.getSub_Id());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getStu_Id(), getSub_Id());
    }
}
