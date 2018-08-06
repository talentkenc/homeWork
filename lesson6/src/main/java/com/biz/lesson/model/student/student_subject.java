package com.biz.lesson.model.student;

import javax.persistence.*;

@Entity
@Table(name="studentAndSubject")
public class student_subject {

    @EmbeddedId
    public uniquekey id;
    public Integer score;

    public Integer getScore() {
        return score;
    }

    public uniquekey getId() {
        return id;
    }

    public void setId(uniquekey id) {
        this.id = id;
    }

    public void setScore(Integer score) {
        this.score = score;
    }
}


