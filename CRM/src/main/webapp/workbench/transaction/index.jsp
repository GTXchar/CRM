<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){
		pageList(1,5);
	//为查询按钮绑定事件
	$("#searchBtn").click(function () {
		//将搜索内容保存到隐藏域中
		$("#hidden-owner").val($.trim($("#search-owner").val()));
		$("#hidden-name").val($.trim($("#search-name").val()));
		$("#hidden-customerId").val($.trim($("#search-customerId").val()));
		$("#hidden-stage").val($.trim($("#search-stage").val()));
		$("#hidden-type").val($.trim($("#search-type").val()));
		$("#hidden-source").val($.trim($("#search-source").val()));
		$("#hidden-contactsId").val($.trim($("#search-contactsId").val()));
		pageList(1, $("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));
	})

		//为全选的复选框绑定事件，触发全选操作
		$("#selectAll").click(function () {
			$("input[name=selectOne]").prop("checked",this.checked);
		});

		$("#activityBody").on("click",$("input[name=selectOne]"),function () {
			$("#selectAll").prop("checked",$("input[name=selectOne]").length==$("input[name=selectOne]:checked").length)
		});

		//为删除按钮绑定事件，执行删除交易操作
		$("#deleteBtn").click(function () {
			//获得所有被选中的记录
			var $selectOne = $("input[name]:checked");
			//判断有没有记录被选中
			if($selectOne.length == 0){
				alert("请选择要删除的记录");
			}else {
				if(confirm("您确定要删除这"+$selectOne.length+"条记录吗？")){
					//拼接参数
					var param = "";
					for(var i=0;i<$selectOne.length;i++){
						//将$selectOne中的每一个dom对象遍历出来，取其value值，就相当于取得了需要删除的记录
						param += "id="+$($selectOne[i]).val();
						//如果不是最后一个参数
						if(i<$selectOne.length){
							param += "&";
						}
					}
					$.ajax({
						url : "workbench/transaction/deleteByArray.do",
						data : param,
						dataType: "json",
						type : "POST",
						success : function (data) {
							if(data.success){
								//删除成功
								pageList(1, $("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								//删除失败
								alert("删除失败");
							}

						}
					})
				}
			}
		});
		$("#editBtn").click(function () {
			//获得所有被选中的记录
			var $selectOne = $("input[name]:checked");
			if($selectOne.length == 0){
				alert("请选择要修改的记录");
			}else if($selectOne.length >1){
				alert("只能选择一条记录进行修改");
			}else {
				var id = $selectOne.val();
				window.location.href="workbench/transaction/edit.do?id="+id;
			}
		});
	});

	function pageList(pageNumber,pageSize) {
		//每次刷新清除复选框
		$("#selectAll").prop("checked", false);
		//查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-customerId").val($.trim($("#hidden-customerId").val()));
		$("#search-stage").val($.trim($("#hidden-stage").val()));
		$("#search-type").val($.trim($("#hidden-type").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-contactsId").val($.trim($("#hidden-contactsId").val()));
		$.ajax({
			url: "workbench/transaction/pageList.do",
			data: {
				"pageNumber": pageNumber,
				"pageSize": pageSize,
				"owner": $.trim($("#search-owner").val()),
				"name": $.trim($("#search-name").val()),
				"customerId": $.trim($("#search-customerId").val()),
				"stage": $.trim($("#search-stage").val()),
				"type" : $.trim($("#search-type").val()),
				"source" : $.trim($("#search-source").val()),
				"contactsId" : $.trim($("#search-contactsId").val())

			},
			type: "POST",
			dataType: "json",
			success: function (data) {
				var html = "";
				//每一个n就是每一个市场活动对象
				$.each(data.dataList, function (i, n) {


					html += '<tr>';
					html += '<td><input type="checkbox" name="selectOne" value="'+n.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.customerId+'</td>';
					html += '<td>'+n.stage+'</td>';
					html += '<td>'+n.type+'</td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.source+'</td>';
					html += '<td>'+n.contactsId+'</td>';
					html += '</tr>';
				});
				$("#transactionBody").html(html);
				//计算总页数
				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
				//数据处理完毕后，结合分页查询，对前端展现分页信息
				$("#transactionPage").bs_pagination({
					currentPage: pageNumber,//页码
					rowsPerPage: pageSize,//每页显示的记录条数
					maxRowsPerPage: 20,//每页最多显示的记录条数
					totalPages: totalPages,//总页数
					totalRows: data.total,//总记录数

					visiblePageLinks: 3, //显示几个卡片
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage: function (event, data) {
						pageList(data.currentPage, data.rowsPerPage);

					}
				});
			}
		});

	}
</script>
</head>
<body>


	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
						<input type="hidden" id="hidden-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
						<input type="hidden" id="hidden-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerId">
						<input type="hidden" id="hidden-customerId">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
						<input type="hidden" id="hidden-stage">
					  <select class="form-control" id="search-stage">
					  	<option></option>
							<c:forEach items="${stageList}" var="s">
								<option value="${s.value}">${s.text}</option>
							</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
						<input type="hidden" id="hidden-type">
					  <select class="form-control" id="search-type">
					  	<option></option>
					  	<c:forEach items="${transactionTypeList}" var="t">
							<option value="${t.value}">${t.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
						<input type="hidden" id="hidden-source">
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactsId">
						<input type="hidden" id="hidden-contactsId">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transactionBody">
<%--						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.do?id=20541bdebd504300aba2ff0f96c3a7a1';">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.do?id=8f8c5e7aaba54632b4f4d09e05244cf5';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">

				<div id="transactionPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>