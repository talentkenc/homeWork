package com.biz.lesson.business.student;

import com.biz.lesson.model.student.student;
//import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.biz.lesson.dao.student.studentRepository;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.transaction.annotation.Transactional;

@Service
public class tableService {

    @Autowired
    public studentRepository studenrepository;


    public student select() {
        return studenrepository.findBystuName("kc");
    }


    public void test(){
        studenrepository.findBystuName("kc");
    }
}
