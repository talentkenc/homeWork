package com.biz.lesson.vo.user;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;

public class UserVo implements java.io.Serializable{

    private static final long serialVersionUID = -8509869494012142361L;

    @NotBlank
    @Length(max=20)
    private String userId;

    @NotBlank
    @Length(max=50)
    private String name;

    @NotBlank
    @Length(max=50)
    private String nameEn;

    private String gender;

    @Length(max=50)
    private String tel;

    @Length(max=50)
    private String fax;

    @Length(max=50)
    private String mobile;

    @Length(max=240)
    private String address;

    @Length(max=20)
    private String postcode;

    @Length(max=100)
    private String permitIP;

    @Length(max=50)
    private String email;

    @Length(max=50)
    private String emailPassword;

    @Length(max=100)
    private String smtpServer;

    private Integer seePolicy;

   
    private List<Long> roles;


    private String logo;

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }


    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNameEn() {
        return nameEn;
    }

    public void setNameEn(String nameEn) {
        this.nameEn = nameEn;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getPermitIP() {
        return permitIP;
    }

    public void setPermitIP(String permitIP) {
        this.permitIP = permitIP;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmailPassword() {
        return emailPassword;
    }

    public void setEmailPassword(String emailPassword) {
        this.emailPassword = emailPassword;
    }

    public String getSmtpServer() {
        return smtpServer;
    }

    public void setSmtpServer(String smtpServer) {
        this.smtpServer = smtpServer;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Integer getSeePolicy() {
		return seePolicy;
	}

	public void setSeePolicy(Integer seePolicy) {
		this.seePolicy = seePolicy;
	}

    public List<Long> getRoles() {
        return roles;
    }

    public void setRoles(List<Long> roles) {
        this.roles = roles;
    }
}
