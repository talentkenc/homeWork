package com.biz.lesson.business.student;

import com.biz.lesson.dao.student.*;
import com.biz.lesson.model.student.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.security.access.method.P;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.biz.lesson.dao.student.*;

import java.util.*;

@Service
public class studentService {
    @Autowired
    public student_subjectCrudRepository student_subjectCrudRepository;
    @Autowired
    public studentCurdRepository studentCurdRepository;
    @Autowired
    public studentPagingAndSortingRepository studentPagingAndSortingRepository;
    @Autowired
    studentRepository studentRepository;


    public int selectTotal(){
        Sort.Order order = new Sort.Order(Sort.Direction.ASC,"stuId");
        Sort sort = new Sort(order);
        Pageable pageable = new PageRequest(0,5,sort);
        Long total = studentPagingAndSortingRepository.findAll(pageable).getTotalElements();
        return total.intValue();
    }

    @Transactional
    public void addStudent(int stuId, String stuName, String stuSex, String stuBirthday, String stuGrage, grade grade){
        student stu = new student();
        stu.setStuId(stuId);
        stu.setStuName(stuName);
        stu.setStuGrade(stuGrage);
        stu.setStuSex(stuSex);
        stu.setGrade(grade);
//        if(stuSex=="male"){
//            stu.setStuSex("男");
//            System.out.println("设置学生性别为男");
//        }else if(stuSex=="female") {
//            stu.setStuSex("女");
//        }
        stu.setBirthday(stuBirthday);
       studentCurdRepository.save(stu);
    }
    @Transactional
    public void save(student stu){
        studentCurdRepository.save(stu);
    }
    public student findOne(Integer id){
        return studentCurdRepository.findOne(id);
    }



    public List<student> selectAllSTudent(int page,int size){
        List<student> list = new ArrayList<student>();
        Sort.Order order = new Sort.Order(Sort.Direction.ASC,"stuId");
        Sort sort = new Sort(order);
        Pageable pageable = new PageRequest(page,size,sort);

        Page<student> students= studentPagingAndSortingRepository.findAll(pageable);
        Iterator it = students.iterator();
        while(it.hasNext()){
            list.add((student) it.next());
        }
        return list;
    }

    //根据id删除学生
    @Transactional
    public void deleteStudent(int id){
        studentCurdRepository.delete(id);
    }

    //存储学生成绩到表studentAdndsubject

    public void saveScore(int stu_id,int sub_id,int score){
        student_subject student_subject = new student_subject();
        uniquekey uniquekey = new uniquekey();
        uniquekey.setStu_Id(stu_id);
        uniquekey.setSub_Id(sub_id);
        student_subject.setId(uniquekey);
//        student_subject.setStu_Id(stu_id);
//        student_subject.setSub_Id(sub_id);
        student_subject.setScore(score);
        student_subjectCrudRepository.save(student_subject);

    }

//    @Transactional
//    public void chooseSubject(Integer id, Set<subject> subjects){
//        System.out.println("执行了修改方法");
//        System.out.println(subjects.size());
//        studentRepository.update(id,subjects);
//
//
//
//    }
    //删除学生选择的科目
    public void delSubject(int stuId){
        student_subjectCrudRepository.delete(stuId);
    }

    //查询成绩表
    public List<student_subject> selectScore(){
        List<student_subject> sss = new ArrayList<student_subject>();
        Iterator<student_subject> it = student_subjectCrudRepository.findAll().iterator();
        while (it.hasNext()){
            sss.add(it.next());
        }
        return sss;
    }
    public List<student> search(String name){
        return  studentRepository.findByStuNameLike("%"+name+"%");
    }
}
