package com.biz.lesson.business.subject;

import com.biz.lesson.model.subject.subject;
import com.biz.lesson.dao.subject.subjectCrudRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import java.util.ArrayList;
import java.util.Iterator;

@Service
public class subjectService {
    @Autowired
    subjectCrudRepository subjectCrudRepository;
    @Transactional
    public void addSubject(String subName){
        subject subject = new subject();
        subject.setSubName(subName);
        subjectCrudRepository.save(subject);
    }
//修改班级信息
    @Transactional
    public void upSubject(int subId,String subName){
        subject subject = new subject();
        subject.setSubId(subId);
        System.out.println(subId+"+++++++++++++++++++++++++++++++++++");
        subject.setSubName(subName);
        subjectCrudRepository.save(subject);
    }


    public List<subject> selectAllSubject() {
        List<subject> subs= new ArrayList<subject>();
        Iterable<subject> all = subjectCrudRepository.findAll();
        Iterator it = all.iterator();
        while (it.hasNext()){
            subs.add((subject) it.next());
        }
        return subs;
    }
    public subject findOne(int subId){
        return subjectCrudRepository.findOne(subId);
    }

    @Transactional
    public void delSubject(int subId){
        subjectCrudRepository.delete(subId);
    }


}
