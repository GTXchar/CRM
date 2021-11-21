<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		//自动补全
		$("#edit-customerName").typeahead({
			source:function (query,process){
				$.get(
						"workbench/contacts/getCustomerName.do",
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
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		$("#remarkBody").on("mouseover", ".remarkDiv", function () {
			$(this).children("div").children("div").show();
		})

		$("#remarkBody").on("mouseout", ".remarkDiv", function () {
			$(this).children("div").children("div").hide();
		})

		//为删除按钮绑定事件，执行删除联系人操作
		$("#deleteBtn").click(function () {

				//弹出是否确认删除提示框
				if(confirm("您确定要删除当前记录吗？")){
					var param = "id=${param.id}";
					$.ajax({
						url : "workbench/contacts/deleteByArray.do",
						data : param,
						dataType: "json",
						type : "POSt",
						success : function (data) {
							if(data.success){
								window.location.href="workbench/contacts/index.jsp";
							}else {
								//删除失败
								alert("删除失败");
							}
						}
					})
				}
		});

		$("#editBtn").click(function () {
				var id =  "${contacts.id}";
				$.ajax({
					url: "workbench/contacts/getUserListAndContacts.do",
					data:{
						"id":id,
					},
					type: "post",
					dataType: "json",
					success: function (data) { // data : {"success": true/false, ""}

						if (data.success) {
							var html = "";
							$.each(data.uList, function (index, item) {
								html += "<option value='" + item.id + "'>" + item.name + "</option>";
							});
							// alert(html);
							$("#edit-owner").html(html);
							var id = "${user.id}"
							$("#edit-owner").val(id);

							// 处理单条clue
							$("#edit-id").val(data.contacts.id);
							$("#edit-appellation").val(data.contacts.appellation);
							$("#edit-fullname").val(data.contacts.fullname);
							$("#edit-job").val(data.contacts.job);
							$("#edit-email").val(data.contacts.email);
							$("#edit-mphone").val(data.contacts.mphone);
							$("#edit-birth").val(data.contacts.birth);
							$("#edit-clueSource").val(data.contacts.source);
							$("#edit-customerName").val(data.customerName)
							$("#edit-description").val(data.contacts.description);
							$("#edit-contactSummary").val(data.contacts.contactSummary);
							$("#edit-nextContactTime").val(data.contacts.nextContactTime);
							$("#edit-address").val(data.contacts.address);

							$("#editContactsModal").modal("show");
							// alert($.trim($("#edit-id").val()))
						}
					}
				});
		});

		$("#updateBtn").click(function () {

			$.ajax({
				url: "workbench/contacts/update.do",
				data: {
					"id":$.trim($("#edit-id").val()),
					"fullname": $.trim($("#edit-fullname").val()),
					"appellation": $.trim($("#edit-appellation").val()),
					"owner": $.trim($("#edit-owner").val()),
					"job": $.trim($("#edit-job").val()),
					"email": $.trim($("#edit-email").val()),
					"mphone": $.trim($("#edit-mphone").val()),
					"source": $.trim($("#edit-clueSource").val()),
					"birth" : $.trim($("#edit-birth").val()),	//生日
					"customerName" : $.trim($("#edit-customerName").val()),	//
					"description": $.trim($("#edit-description").val()),
					"contactSummary": $.trim($("#edit-contactSummary").val()),
					"nextContactTime": $.trim($("#edit-nextContactTime").val()),
					"address": $.trim($("#edit-address").val())
				},
				type: "get",
				dataType: "json",
				success: function (data) {
					// data : {"success":true/false}

					if (data.success) {
						location.reload();
						// 关闭模态窗口
						$("#editContactsModal").modal("hide");
					} else {
						alert("修改联系人失败");
					}

				}
			});
		});

		showRemarkList();


		$("#saveRemarkBtn").click(function () {
			$.ajax({
				url: "workbench/contacts/saveRemark.do",
				data: {
					"noteContent": $.trim($("#remark").val()),
					"contactsId": "${contacts.id}"
				},
				type: "POST",
				dataType: "json",
				success: function (data) {

					//data{"success":true/false,"cr":{备注}}
					if (data.success) {
						//添加成功
						//将textarea文本域中的信息清空掉
						$("#remark").val("");
						//在textarea文本域上方新增一个div
						var html = "";

						html += '<div class="remarkDiv" id="' + data.cr.id + '" style="height: 60px;">';
						html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5 id="e' + data.cr.id + '">' + data.cr.noteContent + '</h5>';
						html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${contacts.fullname}${contacts.appellation}</b> <small style="color: gray;"> ' + data.cr.createTime + ' 由' + data.cr.createBy + '</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.cr.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + data.cr.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';

						$("#remarkDiv").before(html);

					} else {
						alert("添加备注失败")
					}
				}
			});
		});

		$("#updateRemarkBtn").click(function () {
			var id = $("#remarkId").val();
			$.ajax({
				url: "workbench/contacts/editRemark.do",
				data: {
					/*
                    data{"success":true/false,"cr":{备注}}
                     */
					"id": id,
					"noteContent": $.trim($("#noteContent").val())
				},
				dataType: "json",
				type: "GET",
				success: function (data) {
					if (data.success) {
						//修改备注成功
						//更新div中相应的信息，需要更新的内容有noteContent,editTime,editBy
						$("#e" + id).html(data.updateCR.noteContent);
						$("#s" + id).html(data.updateCR.editTime + "由" + data.updateCR.editBy);
						//关闭模态窗口
						// alert("修改成功");
						$("#editRemarkModal").modal("hide");

						//修改此条备注信息的显示
					} else {
						alert("修改失败");
						//修改失败
					}
				}
			});

		});

		//为全选的复选框绑定事件，触发全选操作
		$("#selectAll").click(function () {
			$("input[name=selectOne]").prop("checked", this.checked);
		});

		$("#clueBody").on("click", $("input[name=selectOne]"), function () {
			$("#selectAll").prop("checked", $("input[name=selectOne]").length == $("input[name=selectOne]:checked").length)
		});

		showActivityList();

		//为关联按钮绑定事件，执行关联表的添加操作
		$("#bundBtn").click(function () {
			var $selectOne = $("input[name=selectOne]:checked");
			if ($selectOne.length == 0) {
				alert("请选择需要关联的市场活动");
				return false;
			} else {
				//一条或多条记录
				var param = "cid=${contacts.id}&";
				for (var i = 0; i < $selectOne.length; i++) {
					param += "aid=" + $($selectOne[i]).val();

					if (i < $selectOne.length - 1) {
						param += "&";
					}
				}

				$.ajax({
					url: "workbench/contacts/bund.do",
					data: param,
					type: "POST",
					dataType: "JSON",
					success: function (data) {
						if (data.success) {
							//关联成功
							// alert("关联成功");

							//刷新关联市场活动的列表
							showActivityList();
							//清除搜索框中的信息，取消复选框，单选框的选中状态
							$("#selectAll").prop("checked", false);
							$("#activitySearchBody").html("");
							//关闭模态窗口
							$("#bundModal").modal("hide");
						} else {
							alert("关联失败");
						}
					}
				})
			}
		});

	});

	function showRemarkList() {
		$.ajax({
			url : "workbench/contacts/getRemarkListById.do",
			data : {
				"contactsId" : "${contacts.id}"
			},
			type : "GET",
			dataType : "json",
			success : function (data) {
				var html = "";
				$.each(data,function (i,n) {

					html += '<div class="remarkDiv" id="'+n.id+'" style="height: 60px;">';
					html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
					html += '<font color="gray">联系人</font> <font color="gray">-</font> <b>${contacts.fullname}${contacts.appellation}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				});
				$("#remarkDiv").before(html);
			}

		});
	}

	function deleteRemark(id) {
		if(confirm("您确定要删除这条备注吗？")){
			$.ajax({
				url : "workbench/contacts/deleteRemark.do",
				data: {
					"id" : id
				},
				dataType: "json",
				type: "GET",
				success : function (data) {
					if(data.success){
						// alert("删除成功");
						//找到需要删除记录的div，将div移除掉
						$("#"+id).remove();
					}else {
						alert("删除失败");
					}
				}
			});
		}
	}

	function editRemark(id) {
		//找到指定的存放备注信息的h5标签
		var noteContent = $("#e"+id).html();
		//将h5中展现出来的信息，赋予到修改操作模态窗口的文本域中
		$("#noteContent").val(noteContent);
		$("#remarkId").val(id);
		$("#editRemarkModal").modal("show");
	}

	function showActivityList() {
		$.ajax({
			url: "workbench/contacts/getActivityListByContactsId.do",
			data: {
				"contactsId": "${contacts.id}"
			},
			type: "GET",
			dataType: "json",
			success: function (data) {
				var html = "";
				$.each(data, function (i, n) {
					html += '<tr>';
					html += '<td>' + n.name + '</td>';
					html += '<td>' + n.startDate + '</td>';
					html += '<td>' + n.endDate + '</td>';
					html += '<td>' + n.owner + '</td>';
					html += '<td><a href="javascript:void(0);"  style="text-decoration: none;"  onclick="unbound(\'' + n.id + '\')"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html += '</tr>';
				});
				$("#activityBody").html(html);
			}
		});

		//为关联市场活动模态窗口中的搜索框绑定事件，通过触发回车键，查询并展现所需市场活动列表
		$("#aname").keydown(function (event) {
			//如果是回车键
			if (event.keyCode == 13) {
				$.ajax({
					url: "workbench/contacts/getActivityListByNameAndNotInContactsId.do",
					data: {
						"aname": $.trim($("#aname").val()),
						"contactsId": "${contacts.id}"
					},
					type: "GET",
					dataType: "JSON",
					success: function (data) {
						var html = "";
						$.each(data, function (i, n) {
							html += '<tr>';
							html += '<td><input type="checkbox" name="selectOne" value="' + n.id + '"/></td>';
							html += '<td>' + n.name + '</td>';
							html += '<td>' + n.startDate + '</td>';
							html += '<td>' + n.endDate + '</td>';
							html += '<td>' + n.owner + '</td>';
							html += '</tr>';
						})
						$("#activitySearchBody").html(html);
					}
				});
				//展现完毕后，记得将模态窗口默认的回车行为禁用掉
				return false;
			}
		});
	}

	function unbound(id) {
		if (confirm("您确认要解除关联此条市场活动信息吗？")) {
			$.ajax({
				url: "workbench/contacts/unboundActivityById.do",
				data: {
					"id": id
				},
				type: "POST",
				dataType: "json",
				success: function (data) {
					if (data.success) {
						showActivityList();
					} else {
						//解除关联失败
						alert("解除关联失败");
					}
				}
			})
		}

	}

</script>

</head>
<body>

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="remarkId">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="noteContent" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
			</div>
		</div>
	</div>
	</div>


	<!-- 解除联系人和市场活动关联的模态窗口 -->
	<%--<div class="modal fade" id="unbundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" data-dismiss="modal">解除</button>
				</div>
			</div>
		</div>
	</div>
--%>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
							<div class="form-group has-feedback">
								<input type="text" class="form-control" id="aname" style="width: 300px;"
									   placeholder="请输入市场活动名称，支持模糊查询">
								<span class="glyphicon glyphicon-search form-control-feedback"></span>
							</div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll"/></td>
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
						</thead>
						<tbody id="activitySearchBody">
						<%--<<tr>
                            <td><input type="checkbox"/></td>
                            <td>发传单</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                            <td>zhangsan</td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"/></td>
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
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="bundBtn">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">

						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								</select>
							</div>
							<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource">
									<option></option>
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" >
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<option></option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" >
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-birth">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="1" id="edit-address"></textarea>
								</div>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${contacts.fullname}${contacts.appellation} <small> - ${contacts.customerId}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.fullname}${contacts.appellation}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.birth} &nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contacts.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contacts.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contacts.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contacts.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>${contacts.description}</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>&nbsp;${contacts.contactSummary}</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${contacts.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>${contacts.address}</b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>

	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>



		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><a href="transaction/detail.html" style="text-decoration: none;">动力节点-交易01</a></td>
							<td>5,000</td>
							<td>谈判/复审</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>新业务</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="transaction/save.html" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>

	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td>名称</td>
						<td>开始日期</td>
						<td>结束日期</td>
						<td>所有者</td>
						<td></td>
					</tr>
					</thead>
					<tbody id="activityBody">
					</tbody>
				</table>
			</div>

			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal"
				   style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>

	<div style="height: 200px;"></div>
</body>
</html>