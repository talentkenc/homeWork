package com.biz.lesson.dao.student;

import com.biz.lesson.model.student.subject;
import org.springframework.data.repository.CrudRepository;

public interface subjectCrudRepository extends CrudRepository<subject,Integer> {
}
