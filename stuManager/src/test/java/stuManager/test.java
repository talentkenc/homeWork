package stuManager;

import java.util.Date;
import java.util.Iterator;
import java.util.Set;
import org.junit.Test;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.ScanResult;

public class test {
	public Jedis getConnection(){
		Jedis jedis = new Jedis("39.106.182.201",6379);
		jedis.auth("kangchen.112233");
		JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
		jedisPoolConfig.setMaxTotal(10);
		JedisPool pool = new JedisPool(jedisPoolConfig, "39.106.182.201",6379);
		return jedis;
	}
	@Test
	public void test(){
		//使用junitest先向redis插一批测试数据,仅用于测试。
			Jedis jedis = getConnection();
			for(int i=0;i<100;i++){
				Date date = new Date();
				jedis.hset(0000+i+"", "name", "kc"+i);
				jedis.hset(0000+i+"", "birthday", date.toString());
				jedis.hset(0000+i+"", "description", "student"+i+" is a good student");
				jedis.hset(0000+i+"", "avgscore", i+"");
				
		}
	}
	
	
}
