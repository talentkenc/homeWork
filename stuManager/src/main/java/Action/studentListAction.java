package Action;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Service.studentListService;

public class studentListAction extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session=req.getSession();
		resp.setContentType("text/html;charset=UTF-8");
		req.setCharacterEncoding("UTF-8");
		List list ;
		studentListService sds = new studentListService();
		int start = Integer.parseInt(req.getParameter("start"));
			
		//int end = Integer.parseInt(req.getParameter("end")); 
		
		//req.setAttribute("end", end)
		
		//System.out.println(sds.selectTotal()+"action");
		int total = sds.selectTotal();
		if(start<0)start=0;
		if(start>(total/10))start=total/10;
		session.setAttribute("start", start);
		System.out.println(total);
		list = (List) sds.selectAllUser(start);
		req.setAttribute("list", list);
		session.setAttribute("total", (total/10));
		//System.out.println("total÷µ «£∫"+total/10);
		req.getRequestDispatcher("studentList.jsp").forward(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req,resp);
	}
	
}
