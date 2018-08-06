package com.biz.lesson.model.student;
import java.util.List;
import java.util.Set;
import javax.persistence.*;

@Entity
@Table(name = "grade")
public class grade {
    @GeneratedValue
    @Id
    public Integer gId;
    public String gName;
    public Integer gAmount;
    public Integer gAvgScore;
    public Integer stuId;
    @OneToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "student_grade",
            joinColumns = { @JoinColumn(name = "gId", referencedColumnName = "gId") },
            inverseJoinColumns = { @JoinColumn(name = "stuId", referencedColumnName = "stuId") })
    public Set<student> studentSet;

    public Integer getStuId() {
        return stuId;
    }

    public void setStuId(Integer stuId) {
        this.stuId = stuId;
    }


    public Integer getgId() {
        return gId;
    }

    public void setgId(Integer gId) {
        this.gId = gId;
    }

    public String getgName() {
        return gName;
    }

    public void setgName(String gName) {
        this.gName = gName;
    }

    public Integer getgAmount() {
        return gAmount;
    }

    public void setgAmount(Integer gAmount) {
        this.gAmount = gAmount;
    }

    public Integer getgAvgScore() {
        return gAvgScore;
    }

    public void setgAvgScore(Integer gAvgScore) {
        this.gAvgScore = gAvgScore;
    }

    public Set<student> getStudentSet() {
        return studentSet;
    }

    public void setStudentSet(Set<student> studentSet) {
        this.studentSet = studentSet;
    }
}
