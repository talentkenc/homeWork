package com.biz.lesson.dao.student;

import com.biz.lesson.model.student.student;
import org.springframework.data.repository.PagingAndSortingRepository;

public interface studentPagingAndSortingRepository extends PagingAndSortingRepository<student,Integer> {

}
