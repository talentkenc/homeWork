package com.biz.lesson.web.controller.grade;

import com.biz.lesson.business.grade.gradeService;
import com.biz.lesson.model.grade.grade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
public class gradeController {

    @Autowired
    public gradeService gradeService;

    //增加班级
    @RequestMapping("/addGrade")
    public String addGrade(HttpServletRequest request){
        String gName = request.getParameter("gName");
        gradeService.addGrade(gName);
        return "redirect:/gradeList.do";
    }
    //显示班级列表
    @RequestMapping("/gradeList")
    public ModelAndView selectAllGrade(){
        ModelAndView modelAndView = new ModelAndView("grade/gradeList");
        List<grade> grades = new ArrayList<grade>();
        grades =  gradeService.selectAllGrade();
        //System.out.println(grades.get(0).gName+"**********************************");
        modelAndView.addObject("grades",grades);
        return modelAndView;
    }

    //跳转到增加班级
    @RequestMapping("/jumpAdd")
    public String add(){
        return "grade/addGrade";
    }

    //修改班级信息
    @RequestMapping("/updateGrade")
    public ModelAndView updateGrade(@RequestParam("id") Integer id){
        grade grade = new grade();
        grade = gradeService.findOne(id);
        ModelAndView modelAndView = new ModelAndView("grade/updateGrade") ;
        modelAndView.addObject("grade",grade);
        return modelAndView;
    }

    //非级联删除班级
    @RequestMapping("delGrade")
    public String delGrade(@RequestParam("id") Integer id){
        gradeService.delGrade(id);
        return "redirect:/gradeList.do";
    }

}
