package com.biz.lesson.web.controller.student;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.biz.lesson.model.student.student;
import com.biz.lesson.business.student.tableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

@Controller
public class tableController {


    @Autowired
     tableService ts;

    @RequestMapping("/table.do")
    public String table(HttpServletRequest request){
        student s1= ts.select();
        System.out.println("kc的id："+s1.getStuId());
        System.out.println("table页面");
        request.setAttribute("list","a");
        return "table";
    }
}
