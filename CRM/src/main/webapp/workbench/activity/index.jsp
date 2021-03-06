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
            $(".time,#search-startDate,#search-endDate").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $.ajax({
                url:"workbench/activity/getUserList.do",
                data:{

                },
                type:"GET",
                dataType:"json",
                success:function (data) {
                    /*
                    *   data [{用户1},{2},{3}]
                    *
                    */
                    var html = "<option></option>";
                    //var html = "";
                    //遍历出来的每一个n，就是每一个user对象
                    $.each(data,function (i,n) {
                        html += "<option value='"+n.id+"'>"+n.name+"</option>"

                    })
                    $("#create-marketActivityOwner").html(html);

                    //将当前登录的用户，设置为下拉框默认选中的选项
                    /*
                    * <select id = "create-marketActivityOwner">
                            <option value="">张三</option>
                            <option value="">李四</option>
                      </select>
                    * */
                    //取得当前登录用户的id
                    //在js中使用el表达式，el表达式一定要套用在字符串中
                    var id = "${user.id}";
                    $("#create-marketActivityOwner").val(id)
                }
            });
            //所有者下拉框处理完毕后，展现模态窗口
            $("#addBtn").click(function () {
                /*
                *  操作模态窗口的方式：
                *   需要操作的模态窗口的jquery对象，调用modal方法，为该方法传递参数show：打开模态窗口 hide：关闭模态窗口
                */

                $("#createActivityModal").modal("show");
            })


            //为保存按钮绑定事件，执行添加操作
            $("#saveBtn").click(function () {
                $.ajax({
                    url:"workbench/activity/save.do",
                    data:{
                        "owner" : $.trim($("#create-marketActivityOwner").val()),
                        "name" : $.trim($("#create-marketActivityName").val()),
                        "startDate" : $.trim($("#create-startDate").val()),
                        "endDate" : $.trim($("#create-endDate").val()),
                        "cost" : $.trim($("#create-cost").val()),
                        "description" : $.trim($("#create-description").val())
                    },
                    type: "POST",
                    dataType: "json",
                    success:function (data) {
                        /*
                            data
                                {"success":true/false}
                         */
                        if(data.success) {
                            //添加成功
                            //刷新市场活动信息列表（局部刷新）
                            //pageList(1,2);
                            /*
                            pageList($("#activityPage").bs_pagination('getOption','currentPage'), $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            操作后停留在当前页
                            $("#activityPage").bs_pagination('getOption','currentPage')
                            操作后维持已经设置好的每页展现的记录数
                            $("#activityPage").bs_pagination('getOption','rowsPerPage')
                            这两个参数不需要我们进行任何的修改操作，直接使用即可
                             */
                            // alert("添加成功")
                            pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            //清空添加操作模态窗口中的数据
                            $("#activityAddForm")[0].reset();
                            //关闭添加操作的模态窗口
                            $("#createActivityModal").modal("hide");

                        }else{
                            //添加失败
                            alert("添加失败")
                        }
                    }
                })
            })
            //页面加载完毕后触发一个方法
            //默认展开列表的第一页，每页展现两条记录
            pageList(1,5);

            //为查询按钮绑定事件，触发pageList方法
            $("#searchBtn").click(function () {
                /*
                点击查询按钮时，我们应该将搜索框中的信息保存起来，保存到隐藏域中
                 */
                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-startDate").val($.trim($("#search-startDate").val()));
                $("#hidden-endDate").val($.trim($("#search-endDate").val()));
                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
            })

            //为全选的复选框绑定事件，触发全选操作
            $("#selectAll").click(function () {
                $("input[name=selectOne]").prop("checked",this.checked);
            });

            /*
            因为动态生成的元素，是不能够以普通绑定事件的形式来进行操作的
            动态生成的元素，我们要以on方法的形式来触发事件
            语法：
                $(需要绑定元素的有效的外层元素).on(绑定事件的方式，需要绑定的元素的jquery对象，回调函数)
             */
            $("#activityBody").on("click",$("input[name=selectOne]"),function () {
                $("#selectAll").prop("checked",$("input[name=selectOne]").length==$("input[name=selectOne]:checked").length)
            });

            //为删除按钮绑定事件，执行市场活动删除操作
            $("#deleteBtn").click(function () {


                //找到复选框中所有挑勾的复选框的jquery对象
                var $selectOne = $("input[name=selectOne]:checked");
                //弹出删除确认提示框

                if($selectOne.length == 0){
                    alert("请选择需要删除的记录");
                }else {
                    if(confirm("您确定要删除"+$selectOne.length+"条记录吗？")){
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
                    //alert(param)
                    $.ajax({
                        url:"workbench/activity/delete.do",
                        data:param,
                        type:"post",
                        dataType:"json",
                        success :function (data) {
                            if(data.success){
                                    //pageList(1,2);
                                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            }else {
                                alert("删除市场活动失败");
                            }
                        }
                    });
                  }//if(confirm)
                }
            });



            //为修改按钮绑定事件，打开修改操作的模态窗口
            $("#editBtn").click(function () {
                var $selectOne = $("input[name=selectOne]:checked");
                if($selectOne.length == 0){

                    alert("请选择需要修改的记录");
                }else if($selectOne.length>1){
                    alert("只能选择一条记录进行修改");

                }else {
                    var id = $selectOne.val();
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
                }
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
                            //pageList(1,2);
                            pageList($("#activityPage").bs_pagination('getOption','currentPage'), $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            //关闭修改信息操作的模态窗口
                            $("#editActivityModal").modal("hide");

                        }else {
                            //修改失败
                            alert("修改市场活动失败");
                        }
                    }
                });
            });



        });

        /*
            对于所有的关系型数据库，做前端的分页相关操作的基础组件
            就是pageNumber和pageSize
            pageNumber：页码
            pageSize：每页展现的记录数
            pageList方法：就是发出ajax请求到后台，从后台取得最新的市场活动信息列表数据
            通过响应回来的数据，局部刷新市场活动信息列表
            我们都在哪些情况下，需要调用pageList()方法？（什么情况下需要刷新一下市场活动列表）
            （1）点击左侧菜单栏中的”市场活动“超链接，需要刷新市场活动列表，调用pageList方法
            （2）添加，修改，删除后，需要刷新市场活动列表，调用pageList方法
            （3）点击查询按钮的时候，需要刷新市场活动列表，调用pageList方法
            （4)点击分页组件的时候，调用pageList方法

         */
        function pageList(pageNumber,pageSize) {
            //每次刷新清除复选框
            $("#selectAll").prop("checked", false);
            //查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-startDate").val($.trim($("#hidden-startDate").val()));
            $("#search-endDate").val($.trim($("#hidden-endDate").val()));
            $.ajax({
                url: "workbench/activity/pageList.do",
                data: {
                    "pageNumber": pageNumber,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startDate").val()),
                    "endDate": $.trim($("#search-endDate").val()),

                },
                type: "POST",
                dataType: "json",
                success: function (data) {
                    var html = "";
                    //每一个n就是每一个市场活动对象
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '    <td><input type="checkbox" name="selectOne" value="' + n.id + '"/></td>';
                        html += '    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">' + n.name + '</a></td>';
                        html += '    <td>' + n.owner + '</td>';
                        html += '    <td>' + n.startDate + '</td>';
                        html += '    <td>' + n.endDate + '</td>';
                        html += '</tr>';
                    });
                    $("#activityBody").html(html);
                    //计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
                    //数据处理完毕后，结合分页查询，对前端展现分页信息
                    $("#activityPage").bs_pagination({
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
    <input type="hidden" id="hidden-name"/>
    <input type="hidden" id="hidden-owner"/>
    <input type="hidden" id="hidden-startDate"/>
    <input type="hidden" id="hidden-endDate"/>
<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="activityAddForm">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">

                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label" >名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate" readonly>
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
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




<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control" type="text" id="search-startDate" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control" type="text" id="search-endDate" readonly>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" data-toggle="modal"  id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button> <%--data-target="#editActivityModal"--%>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"  id="selectAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="activityPage"></div>
    </div>

    </div>
</div>
</body>
</html>