<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.*" %>
<%@page import="VO.user" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>学生列表</title>
<style type="text/css">
	
	div tr td{
	padding-left:30px;
	padding-right:30px;
	}
</style>
<script type="text/javascript">
	function turnPage(){
		var yy = document.getElementById("in1").value;
		if(isNaN(yy)==true){alert("请输入合法字符");return false}
		alert("是否跳转？");
		self.location="studentListAction?start="+yy;
	}
</script>

</head>
<body >
<%
	List<user> list = (List)request.getAttribute("list");
%>
	
	<div style="margin-top:200px;;">
	
 	<table align="center" cellpadding="0" cellspacing="0" border="1">
 		<tr><a href="addStudent.jsp" style="margin-left:1200px;">添加学生信息</a></tr>
 		<tr>
 			<td>用户编号</td>
 			<td>姓名</td>
 			<td>出生日期</td>
 			<td>备注</td>
 			<td>平均成绩</td>
 			<td>操作</td>
 		</tr>
 		<c:forEach var="l1" items="${list}" varStatus="status">
 			<tr>
 			<td><c:out value="${l1.id}"/></td>
 			<td><c:out value="${l1.name}"/></td>
 			<td><c:out value="${l1.birthday}"/></td>
 			<td><c:out value="${l1.description}"/></td>
 			<td><c:out value="${l1.avgscore}"/>
 			<td>
 				<a href="studentOperaAction?delid=${l1.id}">删除</a>
 				<a href="updateStudent.jsp?updateid=${l1.id}">修改</a>
 			</td>
 			</tr>
		</c:forEach>
 	</table>
 	</div>

 	<div style="margin-left:650px;">
 	<%
 	
 	//int m = Integer.parseInt(request.getParameter("end"));
	int t= Integer.parseInt((session.getAttribute("start").toString()));
	System.out.print("attribute值："+request.getAttribute("start"));
	System.out.println(t+"执行了该脚本");

	int total = Integer.parseInt((session.getAttribute("total").toString()));
	
	System.out.println(total+"*************************");
		
		//if(t==-1){
			//System.out.println("执行了1");
			//t = 0;
			//}else if(t>(total-1)&&t==(total-1)){
				//t = total;	
				//}
				%>
			
	
 		<a href="studentListAction?start=0">首页</a>
 		<a href="studentListAction?start=<%=t-1%>">上一页</a>
 		<a href="studentListAction?start=<%=t+1%>">下一页</a>
 		<a href="studentListAction?start=<%=t=total%>">尾页</a>
 		<input id="in1" type="text" value="输入页数">
 		<input type="submit" value="跳转" onclick="turnPage()"/>
 	
 	</div>
</body>
</html>