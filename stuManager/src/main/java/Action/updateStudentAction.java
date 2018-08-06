package Action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Service.studentOperaService;
import Service.updateStudentService;

public class updateStudentAction extends HttpServlet{
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		updateStudentService uss = new updateStudentService();
		System.out.println("≥…π¶¡À");
		studentOperaService sos = new studentOperaService();
		int id =Integer.parseInt(req.getParameter("id"));
		String name = req.getParameter("name");
		String birthday = req.getParameter("birthday");
		String description = req.getParameter("description");
		Integer avgscore = Integer.parseInt(req.getParameter("avgscore"));
		sos.inertStudent(name,birthday,description,avgscore);
		uss.update(id,name, birthday, description, avgscore);
		resp.sendRedirect("studentListAction?start="+id/10);
	}
}
