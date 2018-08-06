package Action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Service.studentOperaService;
import VO.user;

public class studentOperaAction extends HttpServlet{
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		int s = Integer.parseInt((session.getAttribute("total").toString()));
		System.out.println("成功了");
		studentOperaService sos = new studentOperaService();
		String name = req.getParameter("name");
		String birthday = req.getParameter("birthday");
		String description = req.getParameter("description");
		Integer avgscore = Integer.parseInt(req.getParameter("avgscore"));
		sos.inertStudent(name,birthday,description,avgscore);
		resp.sendRedirect("studentListAction?start="+s);
	}
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		studentOperaService sos = new studentOperaService();
		int id = Integer.parseInt(req.getParameter("delid"));
		System.out.println("执行get方法成功");
		sos.delStudent(id);
		resp.sendRedirect("studentListAction?start="+id);
		
	}
}
