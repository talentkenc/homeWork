package Action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Service.studentService;

public class studentAction extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
		String username = req.getParameter("username");
		String password = req.getParameter("password");
		studentService stuServ = new studentService();
		HttpSession session  = req.getSession();
		
		boolean flag = stuServ.isFlag();
		if(flag==true){
			session.setAttribute("username", username);
			session.setAttribute("password", password);
			resp.sendRedirect("studentListAction?start=0");
		}else{
			resp.sendRedirect("login.jsp");
		}
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
	}
}
