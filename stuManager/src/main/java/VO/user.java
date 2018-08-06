package VO;

import java.util.Date;

public class user {
	public Integer id;
	public String name;
	public String birthday;
	public String description;
	public Integer avgscore;
	
	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDate() {
		return birthday;
	}
	public void setDate(String date) {
		this.birthday = date;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Integer getAvgscore() {
		return avgscore;
	}
	public void setAvgscore(Integer avgscore) {
		this.avgscore = avgscore;
	}
}
