<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>登录学籍管理系统</title>
<script type="text/javascript">
	function check(){
		var uname=document.getElementById("username").value;
		var pword=document.getElementById("password").value;
		if(uname==""){
			alert("请输入用户名");
			return false;
		}else if(pword==""){
			alert("请输入密码");
			return false;
		}else{
			return true;
		}
	}
</script>
</script>
</head>
<body>
<table align="center" cellpadding="0" cellspacing="0" border="1">
<form action="studentAction" method="post" onsubmit="return check()">
	<tr><td>用户名：<input id="username" type="text" name="username" value="admin"></td></tr>
	<tr><td>密&nbsp &nbsp码：<input id="password" type="password" name="password" value="123456"></td></tr>
	<tr><td><input type="checkbox" name="ck">一周内自动登录</td></tr>
		<td>
			<input type="submit" value="登录">
		</td>
</form>
</table>
</body>
</html>