package Service;

import Dao.updateStudentDao;

public class updateStudentService {
	updateStudentDao usd = new updateStudentDao();
	public void update(int id,String name,String birthday,String description,int avgscore){
		usd.update(id,name, birthday, description, avgscore);
	}
}
