package Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import Dao.studentListDao;
import VO.user;

public class studentListService
{	
	List<user> list = new ArrayList<user>();
	studentListDao sld = new studentListDao();
	public List<user> selectAllUser(int start){
		list = sld.selectall(start);
		return list ;	
	}
	public int selectTotal(){
		System.out.println(sld.selectTotal()+"service");
		return sld.selectTotal();
		
	}
}

