package com.biz.lesson.web.controller.student;


import com.aliyun.oss.model.PutObjectResult;
import com.biz.lesson.business.grade.gradeService;
//import com.biz.lesson.business.student.student_subjectService;
import com.biz.lesson.business.subject.subjectService;
//import com.biz.lesson.dao.student.student_subjectCrudRepository;
import com.biz.lesson.model.grade.grade;
import com.biz.lesson.model.student.student;
import com.biz.lesson.business.student.studentService;
import com.biz.lesson.model.student.student_subject;
import com.biz.lesson.model.subject.subject;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.biz.lesson.util.AliOssClient;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Array;
import java.util.*;
import java.util.concurrent.locks.ReentrantLock;

@Controller
public class studentContorller {

    @Autowired
    public studentService stuSer;
    @Autowired
    public gradeService gradeService;
    @Autowired
    public subjectService subjectService;

    //更新学生信息
    @RequestMapping("/upStudent")
    public String upStudent(HttpServletRequest request){

        int stuId = Integer.parseInt(request.getParameter("stuId"));
        String stuName = request.getParameter("stuName");
        String sutSex = request.getParameter("stuSex");
        String stuBirthday = request.getParameter("stuBirthday");
        String stuSex = request.getParameter("stuSex");
        String stuGrade = request.getParameter("stuGrade");
        grade grade = new grade();
        grade.setgId(Integer.parseInt(stuGrade));
        System.out.println("学生性别："+stuSex);
        stuSer.addStudent(stuId,stuName,sutSex,stuBirthday,stuGrade, grade);
        System.out.println(stuName);
        return "redirect:/studentList.do?page=0";
    }


    @RequestMapping("/addStudent")
    public String addStudent(HttpServletRequest request){
//        int stuId = Integer.parseInt(request.getParameter("stuId"));
        int stuId=99999;
        String stuName = request.getParameter("stuName");
        String sutSex = request.getParameter("stuSex");
        String stuBirthday = request.getParameter("stuBirthday");
        String stuSex = request.getParameter("stuSex");
        String stuGrade = request.getParameter("stuGrade");
        grade grade = new grade();
        grade.setgId(Integer.parseInt(stuGrade));
        System.out.println("学生性别："+stuSex);
        stuSer.addStudent(stuId,stuName,sutSex,stuBirthday,stuGrade, grade);
        System.out.println(stuName);

//        stuName//文件上传到servlet在上传到OSS
//
//        DiskFileItemFactory factory = new DiskFileItemFactory();
//        ServletFileUpload upload = new ServletFileUpload(factory);
//        upload.setHeaderEncoding("UTF-8");
        //上传到oss服务器
//        AliOssClient client = new AliOssClient();
//        client.setAccessKeyId("aliyun oss的鉴权id");
//        client.setAccessKeySecret("aliyun oss的鉴权秘钥");
//        client.setEndpoint("aliyun oss地址");
//        InputStream inputStream = null;
//        PutObjectResult result = client.putObject("http://www.aliyun.com/ad", "/qwew/qwe1/1.pdf", inputStream, "application/pdf");
//        System.out.println("下载url是"+"http://www.aliyun.com/ad/qwew/qwe1/1.pdf");
//        try {
//            InputStream in = client.getObject("http://www.aliyun.com/ad", "/qwew/qwe1/1.pdf");
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
        return "redirect:/studentList.do?page=0";
    }

    @RequestMapping("/studentList")
    public ModelAndView selectAllStudent(HttpServletRequest request){
        int page = Integer.parseInt(request.getParameter("page"));
        if(page<0){
            page=0;
        }else if(page>stuSer.selectTotal()/8){

            page = stuSer.selectTotal()/8;
            System.out.println(page+"++++++++++++++++++++++++++++++++++++++++++++++++++===");
        }

        List<student> students = stuSer.selectAllSTudent(page,8);
        List<student_subject> sss = new ArrayList<student_subject>();
        sss=stuSer.selectScore();
//        System.out.println("查询到第一个学生的姓名："+students.get(1).getStuName()+"第0个学生姓名为："+students.get(0).getStuName());
//        System.out.println("跳转到学生列表成功");
        ModelAndView modelAndView = new ModelAndView("student/studentList");
        modelAndView.addObject("students",students);
        modelAndView.addObject("page",page);
        modelAndView.addObject("sss",sss);

        return modelAndView;
    }

    //按名称搜索学生
    @RequestMapping("/search")
    public ModelAndView search(HttpServletRequest request){
        String name = request.getParameter("searchName");
        List<student> students = stuSer.search(name);
        List<student_subject> sss = new ArrayList<student_subject>();
        sss=stuSer.selectScore();
//        System.out.println("查询到第一个学生的姓名："+students.get(1).getStuName()+"第0个学生姓名为："+students.get(0).getStuName());
//        System.out.println("跳转到学生列表成功");
        ModelAndView modelAndView = new ModelAndView("student/studentList");
        modelAndView.addObject("students",students);
        modelAndView.addObject("sss",sss);
        return modelAndView;
    }


    @RequestMapping("/add")
    public ModelAndView add(){
        List<grade> grades = gradeService.selectAllGrade();
        ModelAndView modelAndView = new ModelAndView("student/addStudent");
        modelAndView.addObject("grades",grades);
        return modelAndView;
    }

    @RequestMapping("/delStudent")
    public String delStudent(@RequestParam("id") Integer id) {
        System.out.println(id);
       //System.out.println( stuId+"22222222222222222222222222222");
        stuSer.deleteStudent(id);
        return "redirect:/studentList.do?page=0";
    }
    //修改学生信息
    @RequestMapping("/updateStudent")
    public ModelAndView updateStudent(@RequestParam("id") Integer id){
        List<grade> grades = gradeService.selectAllGrade();
        student student = new student();
        student = stuSer.findOne(id);
        ModelAndView modelAndView = new ModelAndView("student/updateStudent");
        modelAndView.addObject("student",student);
        modelAndView.addObject("grades",grades);
        return modelAndView;
    }


    //从课程表中查询出课程列表，显示到选课页面
    //并且查出选了课的学生id
    @RequestMapping("/chooseSubject")
    public ModelAndView chooseSubject(@RequestParam("id") Integer id){
        List<subject> subjects = new ArrayList<subject>();
        subjects = subjectService.selectAllSubject();
        ModelAndView modelAndView = new ModelAndView("subject/chooseSubject");
        modelAndView.addObject("stuId",id);
        student  student= stuSer.findOne(id);
        modelAndView.addObject("student",student);
        System.out.println();
        //modelAndView.addObject(stuList);
        modelAndView.addObject("subjects",subjects);
        return modelAndView;
    }

    //获取学生id和课程id，存储到关联表中。
    @RequestMapping("/joinSubject")
    public String joinSubject(HttpServletRequest request){
        //Object arr[];
        String val2 = request.getParameter("temp");
        System.out.println(val2);
        if(val2.equals("null")){
            System.out.println("执行了return");
            return "redirect:/studentList.do?page=0";
        }
        int  stuid = Integer.parseInt(request.getParameter("stuId"));
        String[] arr = val2.split("\\,");
        //student_subjectService.save(stuid, arr);
        Set<subject> set = new HashSet<subject>();
        student  student= stuSer.findOne(stuid);
        for (String i:arr) {
            subject subject = new subject();
            subject.setSubId(Integer.parseInt(i));
            set.add(subject);
            stuSer.saveScore(stuid,subject.subId,0);
        }
        //System.out.println(stuid);
        //System.out.println(arr[0]+"000000000000000000000000000");
        //System.out.println(student.birthday);
        student.setSubjects(set);
        student.setTotalSubject(arr.length);
        stuSer.save(student);
        return "redirect:/studentList.do?page=0";

    }
    //跳转到录入分数界面，传递学生选择的课程和学生过去
    @RequestMapping("/addScore")
    public ModelAndView addScpre(@RequestParam("id") Integer id){
        List<subject> subjects = new ArrayList<subject>();
        subjects = subjectService.selectAllSubject();
        ModelAndView modelAndView = new ModelAndView("student/addScore");
        modelAndView.addObject("stuId",id);
        student  student= stuSer.findOne(id);
        modelAndView.addObject("student",student);
        System.out.println();
        //modelAndView.addObject(stuList);
        modelAndView.addObject("subjects",subjects);
        return modelAndView;
    }
    //存储学生的分数
    @RequestMapping("/saveScore")
    public String saveScore(HttpServletRequest request){
        final ReentrantLock lock = new ReentrantLock();
        student student = new student();
        request.getParameterNames();
        Map<String, String> parameters = new HashMap<>();
        int totalScore=0;
        int totalSubject=0;
        Enumeration<String> parameterNames = request.getParameterNames();
        while(parameterNames.hasMoreElements()) {
            String parameterName = parameterNames.nextElement();
            lock.lock();
            if(parameterName.equals("stuId")){
                student= stuSer.findOne(Integer.parseInt(request.getParameter((parameterName))));
               // System.out.println("成功获取到了学生id"+request.getParameter(parameterName));
            }else {
            //subject.;
                System.out.println("--------------------------------------------------++++++++++++");
                System.out.println(parameterName);
                totalScore+=Integer.parseInt(request.getParameter(parameterName));
                //parameters.put(parameterName, request.getParameter(parameterName));
                totalSubject++;
                //存储每科的成绩
                //stuSer.delSubject(student.stuId);
                stuSer.saveScore(student.stuId,Integer.parseInt(parameterName),Integer.parseInt(request.getParameter(parameterName)));
            }
            lock.unlock();
        }
        student.setAvgScore(totalScore/totalSubject);
        stuSer.save(student);
        System.out.println(parameters.size()+"map的长度");
        return "redirect:/studentList.do?page=0";
    }









}
