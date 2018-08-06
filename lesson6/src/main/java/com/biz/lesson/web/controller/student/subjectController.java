package com.biz.lesson.web.controller.student;

import com.biz.lesson.dao.student.student_subjectCrudRepository;
import com.biz.lesson.model.student.grade;
import com.biz.lesson.model.student.student_subject;
import com.biz.lesson.model.student.subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import com.biz.lesson.business.student.subjectService;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;
import com.biz.lesson.business.student.studentService;

@Controller
public class subjectController {
    @Autowired
    public subjectService subjectService;
    @Autowired
    studentService studentService;

    @RequestMapping("/addSubject")
    public String addSubject(HttpServletRequest request){
        String subName = request.getParameter("subName");
        subjectService.addSubject(subName);
        return "redirect:/subjectList.do";
    }
//修改学科信息
    @RequestMapping("/upSubject")
    public String upSubject(HttpServletRequest request){
        String subId = request.getParameter("subId");
        System.out.println(subId);
        String subName = request.getParameter("subName");
        subjectService.upSubject(Integer.parseInt(subId),subName);
        return "redirect:/subjectList.do";
    }

    @RequestMapping("/subjectList")
    public ModelAndView selectAllSubject(){
        ModelAndView modelAndView = new ModelAndView("student/subjectList");
        List<subject> subjects = new ArrayList<subject>();
        List<student_subject> sss = new ArrayList<student_subject>();
        sss=studentService.selectScore();

        subjects = subjectService.selectAllSubject();
        modelAndView.addObject("subjects",subjects);
        modelAndView.addObject("sss",sss);
        return modelAndView;
    }

    @RequestMapping("/jumpAddSubject")
    public String add(){
        return "student/addSubject";
    }

    @RequestMapping("/updateSubject")
    public ModelAndView updateGrade(@RequestParam("id") Integer id){
        subject subject = new subject();
        subject = subjectService.findOne(id);
        ModelAndView modelAndView = new ModelAndView("student/updateSubject") ;
        modelAndView.addObject("subject",subject);
        return modelAndView;
    }

    @RequestMapping("delSubject")
    public String delGrade(@RequestParam("id") Integer id){
        subjectService.delSubject(id);
        return "redirect:/gradeList.do";
    }

}
