package Dao;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import redis.clients.jedis.Jedis;

public class studentDao {
	public Jedis getConnection(){
		Jedis jedis = new Jedis("39.106.182.201",6379);
		jedis.auth("kangchen.112233");
		return jedis;
	}
	@Test
	//使用junitest先向redis插一批测试数据,仅用于测试。
	public void test(){
		Jedis jedis = getConnection();
		for(int i=0;i<100;i++){
			Date date = new Date();
			jedis.hset(0000+i+"", "name", "kc"+i);
			jedis.hset(0000+i+"", "birthday", date.toString());
			jedis.hset(0000+i+"", "description", "student"+i+" is a good student");
			jedis.hset(0000+i+"", "avgscore", i+"");
		}	
	}

	public boolean login(){
		Jedis jedis = getConnection();
		if(jedis.get("admin").equals("123456")){
		return true;
		}
		return false;
	}
}
