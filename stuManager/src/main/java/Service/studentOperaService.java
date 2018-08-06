package Service;

import Dao.studentOperaDao;
import VO.user;

public class studentOperaService {
	studentOperaDao sod = new studentOperaDao();
	public void inertStudent(String name,String bithday,String description,int avgscore){
		user u2 = new user();
		u2.setName(name);
		u2.setBirthday(bithday);
		u2.setDescription(description);
		u2.setAvgscore(avgscore);
		sod.insertStudent(u2);
	}
	public void delStudent(int id){
		sod.delStudent(id);
		
	}
}
