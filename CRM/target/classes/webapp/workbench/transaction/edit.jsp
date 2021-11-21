<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath =request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

	Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");
	Set<String> set = pMap.keySet();
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
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<script type="text/javascript">
		var json = {
			<%
			for(String key:set){
				String value = pMap.get(key);
			%>
			"<%=key%>" : <%=value%>,
			<%
			}
			%>
		};
		$(function () {
			//自动补全
			$("#edit-customerName").typeahead({
				source:function (query,process){
					$.get(
							"workbench/transaction/getCustomerName.do",
							{"name" : query},/*给后台传入的名称*/
							function (data) {
								/*
								data:[{客户1},{2},{3}]
								 */
								process(data);
							},
							"json"
					)
				},
				delay: 1000
			});

			//添加日历控件
			$(".time1").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			//添加日历控件
			$(".time2").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});
			//为阶段的下拉框，绑定选中下拉框的事件，根据选中的阶段填写可能性
			$("#edit-transactionStage").change(function () {
				//取得选中的阶段
				var stage = $("#edit-transactionStage").val();
				//取可能性
				var possibility = json[stage];
				//为可能性的文本框赋值
				$("#edit-possibility").val(possibility);
			})
			
			//为保存按钮绑定事件，执行交易添加操作
			$("#updateBtn").click(function () {
				//发出传统请求提交表单
				$("#tranForm").submit();
			});

			//为放大镜图标绑定事件，打开搜索市场活动的模态窗口
			$("#openSearchActivityModalBtn").click(function (){
				$("#searchActivityModal").modal("show");
			})
			//为放大镜图标绑定事件，打开搜索联系人的模态窗口
			$("#openSearchContactsModalBtn").click(function (){
				$("#searchContactsModal").modal("show");
			})

			//为搜索操作模态窗口的搜索框绑定事件，执行搜索并展示市场活动列表的操作
			$("#aname").keydown(function (event){

				if(event.keyCode==13){
					$.ajax({
						url : "workbench/clue/getActivityListByName.do",
						data : {
							"aname" : $.trim($("#aname").val())
						},
						type : "GET",
						dataType : "json",
						success : function (data){
							/*data:[{市场活动1},{2},{3}]*/
							var html = "";
							$.each(data,function (i,n) {
								html += '<tr>';
								html += '<td><input type="radio" name="selectOne" value="'+n.id+'"/></td>';
								html += '<td id="'+n.id+'">'+n.name+'</td>';
								html += '<td>'+n.startDate+'</td>';
								html += '<td>'+n.endDate+'</td>';
								html += '<td>'+n.owner+'</td>';
								html += '</tr>';
							})
							$("#activityBody").html(html);
						}
					})

					return false;
				}
			})
			//为提交（市场活动）按钮绑定事件，填充市场活动源（填写两项信息：名字+id）
			$("#submitActivityBtn").click(function () {
				//取得选中的id
				var $selected = $("input[name=selectOne]:checked");
				var id = $selected.val();

				//取得选中市场活动的名字
				var name = $("#"+id).html();
				//将以上两项信息填写到交易表单的市场活动源中
				$("#activityName").val(name);
				$("#activityId").val(id);
				//将模态窗口关闭
				$("#searchActivityModal").modal("hide");

			});

			//为搜索操作模态窗口的搜索框绑定事件，执行搜索并展示联系人列表的操作
			$("#cname").keydown(function (event){

				if(event.keyCode==13){
					$.ajax({
						url : "workbench/contacts/getContactsListByName.do",
						data : {
							"cname" : $.trim($("#cname").val())
						},
						type : "GET",
						dataType : "json",
						success : function (data){
							/*data:[{市场活动1},{2},{3}]*/
							var html = "";
							$.each(data,function (i,n) {

								html+='<tr>';
								html+='<td><input type="radio" name="selectOne" value="'+n.id+'"/></td>';
								html+='<td id="'+n.id+'">'+n.customerId+'-'+n.fullname+n.appellation+'</td>';
								html+='<td>'+n.email+'</td>';
								html+='<td>'+n.mphone+'</td>';
								html+='</tr>';

							})
							$("#contactsBody").html(html);
						}
					})

					return false;
				}
			})
			//为提交（市场活动）按钮绑定事件，填充联系人（填写两项信息：名字+id）
			$("#submitContactsBtn").click(function () {
				//取得选中的id
				var $selected = $("input[name=selectOne]:checked");
				var id = $selected.val();

				//取得选中市场活动的名字
				var name = $("#"+id).html();
				//将以上两项信息填写到交易表单的市场活动源中
				$("#contactsName").val(name);
				$("#contactsId").val(id);
				//将模态窗口关闭
				$("#searchContactsModal").modal("hide");

			});

			load();


		})//$(function(){})

		function load() {

			$("#edit-id").val("${data.tran.id}");
			$("#edit-amountOfMoney").val("${data.tran.money}");
			$("#edit-transactionName").val("${data.tran.name}");
			$("#edit-expectedClosingDate").val("${data.tran.expectedDate}");
			$("#edit-customerName").val("${data.customer.name}");
			$("#edit-transactionStage").val("${data.tran.stage}");
			$("#edit-transactionType").val("${data.tran.type}");
			$("#edit-clueSource").val("${data.tran.source}");
			$("#activityId").val("${data.tran.activityId}");
			$("#activityName").val("${data.activity.name}");
			$("#contactsId").val("${data.tran.contactsId}");
			$("#contactsName").val("${data.contacts.fullname}");
			$("#edit-description").val("${data.tran.description}");
			$("#edit-contactSummary").val("${data.tran.contactSummary}");
			$("#edit-nextContactTime").val("${data.tran.nextContactTime}");

			//取得选中的阶段
			var stage = $("#edit-transactionStage").val();
			//取可能性
			var possibility = json[stage];
			//为可能性的文本框赋值
			$("#edit-possibility").val(possibility);


		}
	</script>
</head>
<body>

	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
							<div class="form-group has-feedback">
								<input type="text" class="form-control" id="aname" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
								<span class="glyphicon glyphicon-search form-control-feedback"></span>
							</div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
						<tr style="color: #B3B3B3;">
							<td></td>
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
						</thead>
						<tbody id="activityBody">
						<%--							<tr>
														<td><input type="radio" name="activity"/></td>
														<td>发传单</td>
														<td>2020-10-10</td>
														<td>2020-10-20</td>
														<td>zhangsan</td>
													</tr>--%>
						<%--							<tr>
														<td><input type="radio" name="activity"/></td>
														<td>发传单</td>
														<td>2020-10-10</td>
														<td>2020-10-20</td>
														<td>zhangsan</td>
													</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitActivityBtn">确定</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 查找联系人 -->
	<div class="modal fade" id="searchContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="cname" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="contactsTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsBody">
							<%--<tr>
								<td><input type="radio" name="contacts"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitContactsBtn">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form action="workbench/transaction/update.do" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;" id="tranForm" >
		<input type="hidden" name="id" id="edit-id">
		<div class="form-group">
			<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionOwner" name="owner">
				  <option></option>
					<c:forEach items="${data.uList}" var="u">
						<option value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-transactionName" name="name">
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="edit-expectedClosingDate" name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-customerName" name="customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-transactionStage" name="stage">
			  	<option></option>
				  <c:forEach items="${stageList}" var="s">
					  <option value="${s.value}">${s.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionType" name="type">
				  <option></option>
				  <c:forEach items="${transactionTypeList}" var="t">
					  <option value="${t.value}">${t.text}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-clueSource" name="source">
				  <option></option>
				  <c:forEach items="${sourceList}" var="s">
					  <option value="${s.value}">${s.text}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="edit-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchActivityModalBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="activityName" placeholder="点击图标搜索" readonly>
				<input type="hidden" id="activityId" name="activityId">
			</div>

		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchContactsModalBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="contactsName" placeholder="点击图标搜索" readonly>
				<input type="hidden" id="contactsId" name="contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time2" id="edit-nextContactTime" name="nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>