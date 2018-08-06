package Dao;

import java.util.Date;

import VO.user;
import redis.clients.jedis.Jedis;

public class studentOperaDao {
	public Jedis getConnection(){
		Jedis jedis = new Jedis("39.106.182.201",6379);
		jedis.auth("kangchen.112233");
		return jedis;
	}
	public boolean insertStudent(user user){
		    
			Jedis jedis = getConnection();
			String str = user.getAvgscore()+"";
			jedis.incrBy("count", 1);
			String id = jedis.get("count");
			Date date = new Date();
			jedis.hset(id+"", "name", user.getName());
			jedis.hset(id+"", "birthday", user.getBirthday());
			jedis.hset(id+"", "description", user.getDescription());
			jedis.hset(id+"", "avgscore", str);
		return true;
	}
	public void delStudent(int id){
		Jedis jedis = getConnection();
		System.out.println(id);
		String idd=id+"";
		jedis.del(idd);
		System.out.println("É¾³ý³É¹¦");
	}
}


