package com.biz.lesson.dao.student;


import com.biz.lesson.model.student.student;
import com.biz.lesson.model.subject.subject;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.RepositoryDefinition;
import com.biz.lesson.model.student.student;
import java.util.List;
import java.util.HashSet;
import java.util.Set;

@RepositoryDefinition(domainClass = student.class, idClass = Integer.class)
public interface studentRepository {
    public student findBystuName(String name);

//    @Modifying
//    @Query(value = "update student o set o.subjects =:subjects where o.stuId= :id")
//    public void update(@Param("id")Integer id, @Param("subjects") Set<subject> subjects);


    //where name like ?% and age <?
   public List<student> findByStuNameLike(String name);


}
