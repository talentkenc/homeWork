package com.biz.lesson.model.subject;

import com.biz.lesson.model.student.student;

import javax.persistence.*;
import java.util.Set;

@Table(name = "subject")
@Entity
public class subject {
    @Id
    @GeneratedValue
    public Integer subId;
    public String subName;
    public Integer subAmount;
    public Integer subAvgScore;
    @ManyToMany(mappedBy = "subjects")
    private Set<student> students ;

    public Integer getSubId() {
        return subId;
    }

    public void setSubId(Integer subId) {
        this.subId = subId;
    }

    public String getSubName() {
        return subName;
    }

    public void setSubName(String subName) {
        this.subName = subName;
    }

    public Integer getSubAmount() {
        return subAmount;
    }

    public void setSubAmount(Integer subAmount) {
        this.subAmount = subAmount;
    }

    public Integer getSubAvgScore() {
        return subAvgScore;
    }

    public void setSubAvgScore(Integer subAvgScore) {
        this.subAvgScore = subAvgScore;
    }

    public Set<student> getStudents() {
        return students;
    }

    public void setStudents(Set<student> students) {
        this.students = students;
    }

    @Override
    public String toString() {
        return subName+"|";
    }
}
