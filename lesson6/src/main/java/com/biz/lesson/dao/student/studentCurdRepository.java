package com.biz.lesson.dao.student;

import com.biz.lesson.model.student.student;
import org.springframework.data.repository.CrudRepository;

public interface studentCurdRepository extends CrudRepository<student,Integer> {
    /**
     * 插入学生信息
     */
}
