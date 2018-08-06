package Dao;

import java.util.Date;

import redis.clients.jedis.Jedis;

public class updateStudentDao {
	public Jedis getConnection(){
		Jedis jedis = new Jedis("39.106.182.201",6379);
		jedis.auth("kangchen.112233");
		return jedis;
	}
	
	
	public void update(int id,String name,String birthday,String description,int avgscore){
		Jedis jedis = getConnection();
		
		jedis.hset(id+"", "name", name);
		jedis.hset(id+"", "birthday", birthday);
		jedis.hset(id+"", "description",description);
		jedis.hset(id+"", "avgscore", avgscore+"");
	}
}
