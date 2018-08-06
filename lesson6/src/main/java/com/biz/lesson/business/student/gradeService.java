package com.biz.lesson.business.student;

import com.biz.lesson.model.student.grade;
import com.biz.lesson.dao.student.gradeCrudRepository;
import com.biz.lesson.model.student.subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.ArrayList;

@Service
public class gradeService {
    @Autowired
    public gradeCrudRepository gradeCrudRepository;
    @Transactional
    public void addGrade(String gName){
        grade grade = new grade();
        grade.setgName(gName);
        gradeCrudRepository.save(grade);
    }

    public List<grade> selectAllGrade(){
        List<grade> grades = new ArrayList<grade>();
        Iterable<grade> it = gradeCrudRepository.findAll();
        Iterator it1 = it.iterator();
        while (it1.hasNext()){
           // System.out.println(it1.next()+"88888888888888888888888888888888888888888888888");
            grades.add((grade) it1.next());
        }

        return grades;
    }
    @Transactional
    public grade findOne(int gId){
        return gradeCrudRepository.findOne(gId);
    }
    @Transactional
    public void delGrade(int gId){
        gradeCrudRepository.delete(gId);
    }


}
