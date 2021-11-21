<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String path = request.getContextPath();
String basePath =request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

</head>
<body>
<h2>欢迎登陆CRM客户关系管理系统</h2>

<marquee  vspace="15px">
	<font face="宋体" size="5px" color="fuchsia" >欢迎登录,为客户服务是我们的第一宗旨!</font>
</marquee>
<%-- 显示系统当前时间--%>
<div id="datetime">
	<script>
		setInterval("document.getElementById('datetime').innerHTML=new Date().toLocaleString();", 1000);
	</script>
</div>
<div>
	<h3>介绍:</h3>
		<ul class="introduce">
			此项目为贸易行业的客户关系管理系统，主要针对企业客户，单方面的对客户做出的一些管理；
			<li>前台包括的模块有：工作台、市场活动、线索、客户、联系人、交易、统计图表；</li>
			<li>后台包括的模块有：登录、个人设置、各个模块的数据操作、数据字典表等</li>
			<li>其中具体包含了登录访问权限(包含IP地址限制),各个模块的数据分页操作,多条件查询,新建,编辑,删除,以及详情页的数据操作,
				以及不同模块之间的协同操作</li>
			<li>使用的前端技术主要有jquery,ECharts,bootstrap等</li>
		</ul>
	<style>
		.introduce{
			font-size: 20px;
		}
	</style>
</div>

</body>
</html>