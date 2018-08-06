package Dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.junit.Test;

import VO.user;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.ScanResult;

public class studentListDao {
	
	private char[][] ScanResult;
	Set<String> set;
	public Jedis getConnection(){
		
		Jedis jedis = new Jedis("39.106.182.201",6379);
		jedis.auth("kangchen.112233");
		return jedis;
	}
	//@Test
	public Set getKey(int x){
		Jedis jedis = getConnection();
		if(x==0){
			set = jedis.keys("[1-9]");
		}else if(x!=0){
			set = jedis.keys(x+"[1-9]");
		}
		
		
		return set;
	}
	//@Test
	public List selectall(int i){
		//int i = 3;111
//		Map hm = new HashMap();
//		Jedis jedis = getConnection();
//		hm.put("name", jedis.hget(i+"","name"));
//		hm.put("birthday", jedis.hget(i+"","birthday"));
//		hm.put(i+"",jedis.hget(i+"","description"));
//		hm.put(i+"",jedis.hget(i+"","avgscore"));
		System.out.println(i);
		set = getKey(i);
		List<user> list = new ArrayList<user>();
		Iterator it = set.iterator();
		while(it.hasNext()){
			int j = Integer.parseInt((String)it.next());
			Jedis jedis = getConnection();
			user u1 = new user();
			u1.setId(j);
			u1.setName(jedis.hget(j+"", "name"));
			u1.setBirthday(jedis.hget(j+"", "birthday"));
			u1.setDescription(jedis.hget(j+"", "description"));
			u1.setAvgscore(Integer.parseInt(jedis.hget(j+"", "avgscore")));		
			System.out.println(j);
			System.out.println(u1.getName());
			list.add(u1);
		}
		return list;
		
	}
	@Test
	public int selectTotal(){
		Jedis jedis = getConnection();
		Integer in = Integer.parseInt(jedis.get("count"));           //new Long(jedis.dbSize()).intValue();
		//System.out.println(in-2+"");
		return in-3;
		 //System.out.println(n);
	}
	//@Test
	public void selectcount(){
		Jedis jedis = getConnection();
		Set<String> temp = jedis.keys("0[0-9]");
		Iterator<String> it = temp.iterator();  
		while (it.hasNext()) {  
		  String str = it.next();  
		  System.out.println(str);  
		}  
	}
}
