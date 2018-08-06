package com.biz.lesson.web.controller.student;

import com.biz.lesson.business.student.gradeService;
import com.biz.lesson.model.student.grade;
import com.sun.org.apache.xpath.internal.operations.Mod;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

@Controller
public class gradeController {
//        public String addStudent(HttpServletRequest request){
//        int stuId = Integer.parseInt(request.getParameter("stuId"));
//        String stuName = request.getParameter("stuName");
//        String sutSex = request.getParameter("stuSex");
//        String stuBirthday = request.getParameter("stuBirthday");
//        stuSer.addStudent(stuId,stuName,sutSex,stuBirthday);
//        System.out.println(stuName);
//        return "index.jsp";
//    }

    @Autowired
    public gradeService gradeService;
    @RequestMapping("/addGrade")
    public String addGrade(HttpServletRequest request){
        String gName = request.getParameter("gName");
        gradeService.addGrade(gName);
        return "redirect:/gradeList.do";
    }
    @RequestMapping("/gradeList")
    public ModelAndView selectAllGrade(){
        ModelAndView modelAndView = new ModelAndView("student/gradeList");
        List<grade> grades = new ArrayList<grade>();
        grades =  gradeService.selectAllGrade();
        //System.out.println(grades.get(0).gName+"**********************************");
        modelAndView.addObject("grades",grades);
        return modelAndView;
    }
    @RequestMapping("/jumpAdd")
    public String add(){
        return "student/addGrade";
    }

    @RequestMapping("/updateGrade")
    public ModelAndView updateGrade(@RequestParam("id") Integer id){
        grade grade = new grade();
        grade = gradeService.findOne(id);
        ModelAndView modelAndView = new ModelAndView("student/updateGrade") ;
        modelAndView.addObject("grade",grade);
        return modelAndView;
    }
    @RequestMapping("delGrade")
    public String delGrade(@RequestParam("id") Integer id){
        gradeService.delGrade(id);
        return "redirect:/gradeList.do";
    }

}
