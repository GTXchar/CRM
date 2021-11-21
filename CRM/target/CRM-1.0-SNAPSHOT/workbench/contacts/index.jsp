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

	$(function () {
		pageList(1, 5);

		//自动补全
		$("#create-customerName").typeahead({
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
			pickerPosition: "bottom-left"
		});

		//定制字段
		$("#definedColumns > li").click(function (e) {
			//防止下拉菜单消失
			e.stopPropagation();
		});

		//为查询按钮保存事件
		$("#searchBtn").click(function () {
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-customerId").val($.trim($("#search-customerId").val()));
			$("#hidden-fullname").val($.trim($("#search-fullname").val()));
			$("#hidden-birth").val($.trim($("#search-birth").val()));
			pageList(1, $("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
		})

		//为全选的复选框绑定事件，触发全选操作
		$("#selectAll").click(function () {
			$("input[name=selectOne]").prop("checked", this.checked);
		});

		$("#contactsBody").on("click", $("input[name=selectOne]"), function () {
			$("#selectAll").prop("checked", $("input[name=selectOne]").length == $("input[name=selectOne]:checked").length)
		});

		//为删除按钮绑定事件，执行删除联系人操作
		$("#deleteBtn").click(function () {
			//获取所有被选中的记录
			var $selectOne = $("input[name=selectOne]:checked");
			//判断有没有记录被选中
			if($selectOne.length == 0){
				alert("请选择要删除的记录");
			}else {
				//弹出是否确认删除提示框
				if(confirm("您确定要删除这"+$selectOne.length+"条记录吗？")){
					//拼接参数
					var param = "";
					for (var i=0;i<$selectOne.length;i++){
						param += "id="+$($selectOne[i]).val();
						//如果不是最后一个，给结尾加上&
						if(i<$selectOne.length-1){
							param += "&";
						}
					}
					$.ajax({
						url : "workbench/contacts/deleteByArray.do",
						data : param,
						dataType: "json",
						type : "POSt",
						success : function (data) {
							if(data.success){
								//删除成功，刷新页面
								pageList(1, $("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								//删除失败
								alert("删除失败");
							}
						}
					})
				}
			}
		});

        //为创建按钮绑定事件，打开添加操作的模态窗口
        $("#addBtn").click(function () {

            var html = "";
            $.ajax({
                url : "workbench/contacts/getUserList.do",
                dataType : "json",
                type : "GET",
                success : function (data) {
                    $.each(data,function (i,n){
                        html += "<option value='"+n.id+"'>"+n.name+"</option>";
                    });
                    $("#create-owner").html(html);
                    var id = "${user.id}";
                    $("#create-owner").val(id);
                    //打开创建线索的模态窗口
                    $("#createContactsModal").modal("show");
                }
            })
        });

		$("#editBtn").click(function () {
			//找到复选框中所有挑勾的复选框jquery对象
			var $selectOne = $("input[name=selectOne]:checked");

			if($selectOne.length == 0){
				alert("请选择要修改的记录");
			}else if($selectOne.length >1){
				alert("只能选择一条记录进行修改");
			}else {
				var id =  $selectOne.val();
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
			}
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
						pageList($("#contactsPage").bs_pagination('getOption', 'currentPage')
								,$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
						// 关闭模态窗口
						$("#editContactsModal").modal("hide");
					} else {
						alert("修改联系人失败");
					}

				}
			});
		});


		//为创建线索保存按钮绑定事件，执行线索添加操作
		$("#saveBtn").click(function () {
			$.ajax({
				url : "workbench/contacts/save.do",
				data : {
					"source" : $.trim($("#create-clueSource").val()),	//来源
					"fullname" : $.trim($("#create-fullname").val()),	//
					"appellation" : $.trim($("#create-appellation").val()),	//称呼
					"owner" : $.trim($("#create-owner").val()),	//所有者
					"job" : $.trim($("#create-job").val()),	//职业
					"email" : $.trim($("#create-email").val()),	//邮箱
					"mphone" : $.trim($("#create-mphone").val()),	//手机
					"birth" : $.trim($("#create-birth").val()),	//生日
					"customerName" : $.trim($("#create-customerName").val()),	//
					"description" : $.trim($("#create-description").val()),	//描述
					"contactSummary" : $.trim($("#create-contactSummary1").val()),	//联系纪要
					"nextContactTime" : $.trim($("#create-nextContactTime1").val()),	//下次联系时间
					"address" : $.trim($("#create-address1").val())	//地址
				},
				type: "POST",
				dataType: "json",
				success : function (data) {
					if(data.success){
						$("#AddForm")[0].reset();
						//刷新列表;
						//关闭模态窗口
						$("#createContactsModal").modal("hide");
						pageList(1, $("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
						// alert("添加成功")
					}else {
						alert("添加联系人失败")
					}
				}
			});
		});




	});



	function pageList(pageNumber,pageSize) {
		//每次刷新清除复选框
		$("#selectAll").prop("checked", false);
		//查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-customerId").val($.trim($("#hidden-customerId").val()));
		$("#search-fullname").val($.trim($("#hidden-fullname").val()));
		$("#search-birth").val($.trim($("#hidden-birth").val()));
		$.ajax({
			url: "workbench/contacts/pageList.do",
			data: {
				"pageNumber": pageNumber,
				"pageSize": pageSize,
				"fullname": $.trim($("#search-fullname").val()),
				"owner": $.trim($("#search-owner").val()),
				"customerId": $.trim($("#search-customerId").val()),
				"source": $.trim($("#search-source").val()),
				"birth": $.trim($("#search-birth").val())
			},
			type: "POST",
			dataType: "json",
			success: function (data) {
				var html = "";
				//每一个n就是每一个市场活动对象
				$.each(data.dataList, function (i, n) {

						html += '<tr>';
						html += '<td><input type="checkbox" name="selectOne" value="'+n.id+'"/></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detail.do?id='+n.id+'\';">'+n.fullname+'</a></td>';
						html += '<td>'+n.customerId+'</td>';
						html += '<td>'+n.owner+'</td>';
						html += '<td>'+n.source+'</td>';
						html += '<td>'+n.birth+'</td>';
						html += '</tr>';
				});
				$("#contactsBody").html(html);
				//计算总页数
				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
				//数据处理完毕后，结合分页查询，对前端展现分页信息
				$("#contactsPage").bs_pagination({
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

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="AddForm">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
                                    <c:forEach items="${sourceList}" var="s">
                                        <option value="${s.value}">${s.text}</option>
                                    </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
                                    <c:forEach items="${appellationList}" var="a">
                                        <option value="${a.value}">${a.text}</option>
                                    </c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime1">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
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
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
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
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="search-fullname">
						<input type="hidden" id="hidden-fullname">
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
				      <div class="input-group-addon">生日</div>
				      <input class="form-control time" type="text" id="search-birth">
						<input type="hidden" id="hidden-birth">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll"/></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactsBody">
<%--						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
                            <td>动力节点</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>2000-10-10</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 10px;">

			<div id="contactsPage"></div>

			</div>
			
		</div>
		
	</div>
</body>
</html>