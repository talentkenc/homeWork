package com.biz.lesson.web.controller.subject;

import com.biz.lesson.business.student.studentService;
import com.biz.lesson.business.subject.subjectService;
import com.biz.lesson.model.student.student_subject;
import com.biz.lesson.model.subject.subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
public class subjectController {
    @Autowired
    public subjectService subjectService;
    @Autowired
    studentService studentService;

    //增加学科
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

    //显示学科列表
    @RequestMapping("/subjectList")
    public ModelAndView selectAllSubject(){
        ModelAndView modelAndView = new ModelAndView("subject/subjectList");
        List<subject> subjects = new ArrayList<subject>();
        List<student_subject> sss = new ArrayList<student_subject>();
        sss=studentService.selectScore();

        subjects = subjectService.selectAllSubject();
        modelAndView.addObject("subjects",subjects);
        modelAndView.addObject("sss",sss);
        return modelAndView;
    }

    //跳转到增加学生的jsp
    @RequestMapping("/jumpAddSubject")
    public String add(){
        return "subject/addSubject";
    }

    //修改学生
    @RequestMapping("/updateSubject")
    public ModelAndView updateGrade(@RequestParam("id") Integer id){
        subject subject = new subject();
        subject = subjectService.findOne(id);
        ModelAndView modelAndView = new ModelAndView("subject/updateSubject") ;
        modelAndView.addObject("subject",subject);
        return modelAndView;
    }

    //删除学生
    @RequestMapping("delSubject")
    public String delGrade(@RequestParam("id") Integer id){
        subjectService.delSubject(id);
        return "redirect:/gradeList.do";
    }

}
