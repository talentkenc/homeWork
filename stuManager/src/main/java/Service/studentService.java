package Service;

import Dao.studentDao;

public class studentService {
	studentDao stuDao = new studentDao();
	public boolean flag = stuDao.login();
	
	public boolean isFlag() {
		return flag;
	}
}
