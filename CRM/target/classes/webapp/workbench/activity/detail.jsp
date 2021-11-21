<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    //Basepath其实就是提供了一个默认的绝对路径，相当于：localhost:8080/项目名/，让我们在写路径的时候不再为路径错误导致的404烦恼。
// request.getSchema()可以返回当前页面使用的协议，http或者是https；
// request.getServerName()可以返回当前页面所在的服务器的名字；
// request.getServerPort()可以返回当前页所在的服务器使用的端口，就是8080；
// request.getContextPath()可以返回当前页面所在的应用的名字
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

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function(){
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

            $("#remarkBody").on("mouseover",".remarkDiv",function () {
                $(this).children("div").children("div").show();
            })

            $("#remarkBody").on("mouseout",".remarkDiv",function () {
                $(this).children("div").children("div").hide();
            })
            showRemarkList();

            $("#saveRemarkBtn").click(function () {
                $.ajax({
                    url : "workbench/activity/saveRemark.do",
                    data : {
                        "noteContent" : $.trim($("#remark").val()),
                        "activityId" : "${a.id}"
                    },
                    type : "POST",
                    dataType : "json",
                    success : function (data) {

                        //data{"success":true/false,"ar":{备注}}
                        if(data.success){
                            //添加成功
                            //将textarea文本域中的信息清空掉
                            $("#remark").val("");
                            //在textarea文本域上方新增一个div
                            var html = "";

                            html += '<div class="remarkDiv" id="'+data.ar.id+'" style="height: 60px;">';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id="e'+data.ar.id+'">'+data.ar.noteContent+'</h5>';
                            html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;"> '+data.ar.createTime+' 由'+data.ar.createBy+'</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+data.ar.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.ar.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';

                        $("#remarkDiv").before(html);

                        }else {
                            alert("添加备注失败")
                        }
                    }
                });
            });

            $("#updateRemarkBtn").click(function () {
                    var id = $("#remarkId").val();
                $.ajax({
                    url : "workbench/activity/editRemark.do",
                    data : {
                        /*
                        data{"success":true/false,"ar":{备注}}
                         */
                        "id" : id,
                        "noteContent" : $.trim($("#noteContent").val())
                    },
                    dataType : "json",
                    type : "GET",
                    success : function (data) {
                        if(data.success){
                            //修改备注成功
                            //更新div中相应的信息，需要更新的内容有noteContent,editTime,editBy
                            $("#e"+id).html(data.updateAR.noteContent);
                            $("#s"+id).html(data.updateAR.editTime+"由"+data.updateAR.editBy);
                            //关闭模态窗口
                            // alert("修改成功");
                            $("#editRemarkModal").modal("hide");

                            //修改此条备注信息的显示
                        }else {
                            alert("修改失败");
                            //修改失败
                        }
                    }
                });

            });


            //为修改按钮绑定事件，打开修改操作的模态窗口
            $("#editBtn").click(function () {
                var id = "${a.id}"
                    $.ajax({
                        url : "workbench/activity/getUserListAndActivity.do",
                        data : {
                            "id" : id
                        },
                        type:"GET",
                        dataType : "json",
                        success : function (data) {

                            //处理所有者下拉框
                            var html = "<option></option>";
                            $.each(data.uList,function (i,n) {
                                html += "<option value='"+n.id+"'>"+n.name+"</option>"
                            })
                            $("#edit-marketActivityOwner").html(html);

                            //处理单条acitivity
                            $("#edit-id").val(data.a.id);
                            $("#edit-marketActivityName").val(data.a.name);
                            $("#edit-marketActivityOwner").val(data.a.owner);
                            $("#edit-startTime").val(data.a.startDate);
                            $("#edit-endTime").val(data.a.endDate);
                            $("#edit-cost").val(data.a.cost);
                            $("#edit-describe").val(data.a.description);

                            //所有的值都填写完之后，打开修改市场活动模态窗口
                            $("#editActivityModal").modal("show");
                        }
                    });

            });
            /*
            为更新按钮绑定事件，执行市场活动的修改操作
             */
            $("#updateBtn").click(function () {
                $.ajax({
                    url : "workbench/activity/update.do",
                    data: {
                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-marketActivityOwner").val()),
                        "name": $.trim($("#edit-marketActivityName").val()),
                        "startDate" : $.trim($("#edit-startTime").val()),
                        "endDate" : $.trim($("#edit-endTime").val()),
                        "cost" : $.trim($("#edit-cost").val()),
                        "description" : $.trim($("#edit-describe").val()),
                    },
                    type : "POST",
                    dataType : "json",
                    success : function (data){
                        if(data.success){
                            //修改成功后
                            alert("修改成功")
                            //刷新市场活动信息列表（局部刷新）
                            location.reload();
                            //关闭修改信息操作的模态窗口
                            $("#editActivityModal").modal("hide");

                        }else {
                            //修改失败
                            alert("修改市场活动失败");
                        }
                    }
                });
            });

            //为删除按钮绑定事件，执行市场活动删除操作
            $("#deleteBtn").click(function () {
                    if(confirm("您确定要删除当前记录吗？")){
                       var param = "id=${a.id}";
                        $.ajax({
                            url:"workbench/activity/delete.do",
                            data:param,
                            type:"post",
                            dataType:"json",
                            success :function (data) {
                                if(data.success){
                                   window.location.href="workbench/activity/index.jsp";
                                }else {
                                    alert("删除市场活动失败");
                                }
                            }
                        });
                    }//if(confirm)
            });

        });

        function showRemarkList() {
            $.ajax({
                url : "workbench/activity/getRemarkListByAid.do",
                data : {
                    "activityId" : "${a.id}"
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
                      html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
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

            })
        }

        function deleteRemark(id) {
            if(confirm("您确定要删除这条备注吗？")){
                $.ajax({
                    url : "workbench/activity/deleteRemark.do",
                    data: {
                        "id" : id
                    },
                    dataType: "json",
                    type: "GET",
                    success : function (data) {
                        if(data.success){
                            alert("删除成功");
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
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
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

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id"/>
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">

                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startTime">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endTime">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="updateBtn">更新</button>
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
        <h3>${a.name} <small>${a.startDate} ~ ${a.endDate}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" data-toggle="modal" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>${a.description}</b>
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
<div style="height: 200px;"></div>
</body>
</html>