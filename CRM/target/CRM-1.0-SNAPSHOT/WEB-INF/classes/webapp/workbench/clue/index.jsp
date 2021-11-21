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
		//添加日历控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});
		//为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {

			var html = "";
			$.ajax({
				url : "workbench/clue/getUserList.do",
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
					$("#createClueModal").modal("show");
				}
			})
		})
		//为创建线索保存按钮绑定事件，执行线索添加操作
		$("#saveBtn").click(function () {
			$.ajax({
				url : "workbench/clue/save.do",
				data : {
					"fullname" : $.trim($("#create-fullname").val()),	//全名（人的名字）
					"appellation" : $.trim($("#create-appellation").val()),	//称呼
					"owner" : $.trim($("#create-owner").val()),	//所有者
					"company" : $.trim($("#create-company").val()),	//公司名称
					"job" : $.trim($("#create-job").val()),	//职业
					"email" : $.trim($("#create-email").val()),	//邮箱
					"phone" : $.trim($("#create-phone").val()),	//公司电话
					"website" : $.trim($("#create-website").val()),	//公司网站
					"mphone" : $.trim($("#create-mphone").val()),	//手机
					"state" : $.trim($("#create-state").val()),	//状态
					"source" : $.trim($("#create-source").val()),	//来源
					"description" : $.trim($("#create-description").val()),	//描述
					"contactSummary" : $.trim($("#create-contactSummary").val()),	//联系纪要
					"nextContactTime" : $.trim($("#create-nextContactTime").val()),	//下次联系时间
					"address" : $.trim($("#create-address").val())	//地址
				},
				type: "POST",
				dataType: "json",
				success : function (data) {
					if(data.success){
						$("#AddForm")[0].reset();
						//刷新列表;
						//关闭模态窗口
						$("#createClueModal").modal("hide");
						pageList(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						// alert("添加成功")
					}else {
						alert("添加线索失败")
					}
				}
			});
		});

		//为全选的复选框绑定事件，触发全选操作
		$("#selectAll").click(function () {
			$("input[name=selectOne]").prop("checked",this.checked);
		});

		$("#clueBody").on("click",$("input[name=selectOne]"),function () {
			$("#selectAll").prop("checked",$("input[name=selectOne]").length==$("input[name=selectOne]:checked").length)
		});

		//为查询按钮绑定事件，将查询条件放入隐藏域
		$("#searchBtn").click(function () {
			$("#hidden-fullname").val($("#search-fullname").val());
			$("#hidden-company").val($("#search-company").val());
			$("#hidden-phone").val($("#search-phone").val());
			$("#hidden-source").val($("#search-source").val());
			$("#hidden-owner").val($("#search-owner").val());
			$("#hidden-mphone").val($("#search-mphone").val());
			$("#hidden-state").val($("#search-state").val());
			pageList(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
		})

		//为删除按钮绑定事件，执行线索删除操作
		$("#deleteBtn").click(function () {
			//找到复选框中所有挑勾的复选框jquery对象
			var $selectOne = $("input[name=selectOne]:checked");

			if($selectOne.length == 0){
				alert("请选择要删除的记录");
			}else {
				//弹出删除确认提示框
				if(confirm("您确认要删除"+$selectOne.length+"条记录吗？")){
					//拼接参数
					var param = "";
					//将$selectOne中的每一个dom对象遍历出来，取其value值，就相当于取得了需要删除的记录
					for(var i=0;i<$selectOne.length;i++){
						param += "id="+$($selectOne[i]).val();
						//如果不是最后一个元素，需要在后面追加一个&符号
						if(i<$selectOne.length-1){
							param += "&";
						}
					}
					$.ajax({
						url : "workbench/clue/delete.do",
						data : param,
						type : "POST",
						dataType : "json",
						success : function (data) {
							if(data.success){
								pageList(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("删除线索失败");
							}
						}
					})
				}
			}

		})


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
					url: "workbench/clue/getUserListAndClue.do",
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
							$("#edit-id").val(data.clue.id);
							$("#edit-company").val(data.clue.company);
							$("#edit-appellation").val(data.clue.appellation);
							$("#edit-fullname").val(data.clue.fullname);
							$("#edit-job").val(data.clue.job);
							$("#edit-email").val(data.clue.email);
							$("#edit-phone").val(data.clue.phone);
							$("#edit-mphone").val(data.clue.mphone);
							$("#edit-website").val(data.clue.website);
							$("#edit-state").val(data.clue.state);
							$("#edit-source").val(data.clue.source);
							$("#edit-description").val(data.clue.description);
							$("#edit-contactSummary").val(data.clue.contactSummary);
							$("#edit-nextContactTime").val(data.clue.nextContactTime);
							$("#edit-address").val(data.clue.address);

							$("#editClueModal").modal("show");
							// alert($.trim($("#edit-id").val()))
						}
					}
				});
			}
		});

		$("#updateBtn").click(function () {

			$.ajax({
				url: "workbench/clue/update.do",
				data: {
					"id":$.trim($("#edit-id").val()),
					"fullname": $.trim($("#edit-fullname").val()),
					"appellation": $.trim($("#edit-appellation").val()),
					"owner": $.trim($("#edit-owner").val()),
					"company": $.trim($("#edit-company").val()),
					"job": $.trim($("#edit-job").val()),
					"email": $.trim($("#edit-email").val()),
					"phone": $.trim($("#edit-phone").val()),
					"website": $.trim($("#edit-website").val()),
					"mphone": $.trim($("#edit-mphone").val()),
					"state": $.trim($("#edit-state").val()),
					"source": $.trim($("#edit-source").val()),
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
						pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
								,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						// 关闭模态窗口
						$("#editClueModal").modal("hide");
					} else {
						alert("修改线索失败");
					}

				}
			});
		});










		//分页显示操作
		function pageList(pageNumber,pageSize) {
			//pageList($("#activityPage").bs_pagination('getOption','currentPage'), $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
			//每次刷新清除复选框
			$("#selectAll").prop("checked", false);
			//查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
			$("#search-fullname").val($("#hidden-fullname").val());
			$("#search-company").val($("#hidden-company").val());
			$("#search-phone").val($("#hidden-phone").val());
			$("#search-source").val($("#hidden-source").val());
			$("#search-owner").val($("#hidden-owner").val());
			$("#search-mphone").val($("#hidden-mphone").val());
			$("#search-state").val($("#hidden-state").val());
			$.ajax({
				url: "workbench/clue/pageList.do",
				data: {
					"pageNumber": pageNumber,
					"pageSize": pageSize,
					"fullname": $.trim($("#search-fullname").val()),
					"company": $.trim($("#search-company").val()),
					"phone": $.trim($("#search-phone").val()),
					"source": $.trim($("#search-source").val()),
					"owner": $.trim($("#search-owner").val()),
					"mphone": $.trim($("#search-mphone").val()),
					"state": $.trim($("#search-state").val())
				},
				type: "POST",
				dataType: "json",
				success: function (data) {
					var html = "";
					//每一个n就是每一个市场活动对象
					$.each(data.dataList, function (i, n) {

						html += '<tr>';
						html += '<td><input type="checkbox" name="selectOne" value="'+n.id+'"/></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+n.id+'\';">'+n.fullname+'</a></td>';
						html += '<td>'+n.company+'</td>';
						html += '<td>'+n.phone+'</td>';
						html += '<td>'+n.mphone+'</td>';
						html += '<td>'+n.source+'</td>';
						html += '<td>'+n.owner+'</td>';
						html += '<td>'+n.state+'</td>';
						html += '</tr>';
					});
					$("#clueBody").html(html);
					//计算总页数
					var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
					//数据处理完毕后，结合分页查询，对前端展现分页信息
					$("#cluePage").bs_pagination({
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

	})




</script>
</head>
<body>
<input type="hidden" id="hidden-fullname"/>
<input type="hidden" id="hidden-company"/>
<input type="hidden" id="hidden-phone"/>
<input type="hidden" id="hidden-source"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-mphone"/>
<input type="hidden" id="hidden-state"/>
	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="AddForm" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${appellationList}" var="a">
									  <option value="${a.value}">${a.text}</option>
								  </c:forEach>

								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								 <c:forEach items="${clueStateList}" var="c">
									<option>${c.text}</option>
								 </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${sourceList}" var="s">
									  <option value="${s.value}">${s.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 90%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">修改线索</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<input type="hidden" id="edit-id">
					<div class="form-group">
						<label for="edit-owner" class="col-sm-2 control-label">所有者<span
								style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-owner">

							</select>
						</div>
						<label for="edit-company" class="col-sm-2 control-label">公司<span
								style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-company">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-appellation">
								<option></option>
								<c:forEach items="${appellationList}" var="a">
									<option value="${a.value}">${a.text}</option>
								</c:forEach>
							</select>
						</div>
						<label for="edit-fullname" class="col-sm-2 control-label">姓名<span
								style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-fullname" >
						</div>
					</div>

					<div class="form-group">
						<label for="edit-job" class="col-sm-2 control-label">职位</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-job" >
						</div>
						<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-email" >
						</div>
					</div>

					<div class="form-group">
						<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-phone" >
						</div>
						<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-website">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-mphone" >
						</div>
						<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-state">
								<option></option>
								<c:forEach items="${clueStateList}" var="c">
									<option value="${c.value}">${c.text}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-source">
								<option></option>
								<c:forEach items="${sourceList}" var="s">
									<option value="${s.value}">${s.text}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="edit-description" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

					<div style="position: relative;top: 15px;">
						<div class="form-group">
							<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-nextContactTime" value="2017-05-01" readonly>
							</div>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

					<div style="position: relative;top: 20px;">
						<div class="form-group">
							<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
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
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >名称</div>
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >公司</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search-source">
					  	  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >手机</div>
				      <input class="form-control" type="text" id="search-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >线索状态</div>
					  <select class="form-control" id="search-state">
					  	<option></option>
						  <c:forEach items="${clueStateList}" var="c">
							  <option>${c.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">
<%--						<tr>
							<td><input type="checkbox" name="selectOne"/></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" name="selectOne"/></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">

				<div id="cluePage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>