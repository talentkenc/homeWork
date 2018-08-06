package com.biz.lesson.model.student;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.biz.lesson.model.student.grade;
import javax.persistence.*;
import java.util.*;

@Entity
@Table(name="student")
public class student {
    @GeneratedValue
    @Id
    public Integer stuId;
    public String stuName;
    public String picture;
    public String stuSex;
    public String birthday;
    public String stuGrade;
    public Integer totalSubject;
    public Integer avgScore;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "student_subject",
            joinColumns = { @JoinColumn(name = "stuId", referencedColumnName = "stuId") },
            inverseJoinColumns = { @JoinColumn(name = "subId", referencedColumnName = "subId") })
            //uniqueConstraints = { @UniqueConstraint(columnNames = { "stu_id", "sub_id" }) })
    private Set<subject> subjects ;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinTable(name = "student_grade",
            joinColumns = { @JoinColumn(name = "stuId", referencedColumnName = "stuId") },
            inverseJoinColumns = { @JoinColumn(name = "gId", referencedColumnName = "gId") })
    public grade grade;


    public String getStuGrade() {
        return stuGrade;
    }

    public void setStuGrade(String stuGrade) {
        this.stuGrade = stuGrade;
    }

    public Integer getStuId() {
        return stuId;
    }

    public void setStuId(Integer stuId) {
        this.stuId = stuId;
    }

    @Column(length = 20)
    public String getStuName() {
        return stuName;
    }


    public void setStuName(String stuName) {
        this.stuName = stuName;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public String getStuSex() {
        return stuSex;
    }

    public void setStuSex(String stuSex) {
        this.stuSex = stuSex;
    }

    public Set<subject> getSubjects() {
        return subjects;
    }

    public void setSubjects(Set<subject> subjects) {
        this.subjects = subjects;
    }

    public String getBirthday() {

        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public Integer getAvgScore() {
        return avgScore;
    }

    public void setAvgScore(Integer avgScore) {
        this.avgScore = avgScore;
    }

    public Integer getTotalSubject() {
        return totalSubject;
    }

    public void setTotalSubject(Integer totalSubject) {
        this.totalSubject = totalSubject;
    }

    public com.biz.lesson.model.student.grade getGrade() {
        return grade;
    }

    public void setGrade(com.biz.lesson.model.student.grade grade) {
        this.grade = grade;
    }
}
