<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.*" %>
<%@page import="VO.user" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>

<script type="text/javascript">
	function check(){
		var name=document.getElementById("name").value;
		if(name==""){
			alert("！学生姓名不能为空");
			return false;
		}else{
			return true;
		}
	}
</script>

</head>
<body>
<div style="align:center">
<h1 align="center">录入学生信息</h1>
<hr/>
<table align="center" cellpadding="0" cellspacing="0" border="1">
<form action="studentOperaAction" method="post" onsubmit="return check()">
	<tr>
	<td>学生姓名：<input id="name" type="text" name="name"/></td>
	<td>出生日期：<input type="text" name="birthday" value="1996-02-05"/></td>
	</tr>
	<tr>
	<td>描&nbsp &nbsp  &nbsp  &nbsp述：<input type="text" name="description" value="该学生学习踏实"/></td>
	<td>平均成绩：<input type="text" name="avgscore" value="60"/></td>
	</tr>
	
	<td><input type="submit"/></td>
</form>
</table>
</div>

</body>
</html>