package com.biz.lesson.web.controller.student;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller

public class jump {
    @RequestMapping("/jump")
    public String jump(){
        return "redirect:/studentList.do?page=0";
    }
}
