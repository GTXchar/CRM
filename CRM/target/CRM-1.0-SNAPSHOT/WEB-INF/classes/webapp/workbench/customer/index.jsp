<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">

        $(function () {
            pageList(1, 5);

            //添加日历控件
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });


            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            //为查询按钮绑定事件，将查询条件放入隐藏域
            $("#searchBtn").click(function () {

                $("#hidden-name").val($("#search-name").val());
                $("#hidden-owner").val($("#search-owner").val());
                $("#hidden-phone").val($("#search-phone").val());
                $("#hidden-website").val($("#search-website").val());
                pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
            })

            //为删除按钮绑定事件
            $("#deleteBtn").click(function () {
                //找到所有被选中的记录
                var $selectOne = $("input[name=selectOne]:checked");
                //如果没有被选中的记录
                if ($selectOne.length == 0) {
                    alert("请选择需要删除的记录");
                } else {
                    //弹出删除确认提示框
                    if (confirm("您确定要删除这" + $selectOne.length + "条记录吗？")) {
                        //用户确认删除，拼接参数传回后台
                        var param = "";
                        //取出$selectOne中的每个jquery对象，得到其中的value值
                        for (var i = 0; i < $selectOne.length; i++) {
                            param += "id=" + $($selectOne[i]).val();
                            //如果不是最后一个，则在其后加&
                            if (i < $selectOne.length - 1) {
                                param += "&";
                            }
                        }
                        $.ajax({
                            url: "workbench/customer/deleteByArray.do",
                            data: param,
                            dataType: "json",
                            type: "POST",
                            success: function (data) {
                                if (data.success) {
                                    pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                                } else {
                                    alert("删除失败");
                                }
                            }
                        })
                    }
                }
            })

            //为创建按钮绑定事件，打开添加操作的模态窗口
            $("#addBtn").click(function () {

                var html = "";
                $.ajax({
                    url: "workbench/customer/getUserList.do",
                    dataType: "json",
                    type: "GET",
                    success: function (data) {
                        $.each(data, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>";
                        });
                        $("#create-owner").html(html);
                        var id = "${user.id}";
                        $("#create-owner").val(id);
                        //打开创建线索的模态窗口
                        $("#createCustomerModal").modal("show");
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
                        url: "workbench/customer/getUserListAndCustomer.do",
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

                                // 处理单条customer
                                $("#edit-id").val(data.customer.id);
                                $("#edit-owner").val(data.customer.owner);
                                $("#edit-customerName").val(data.customer.name);
                                $("#edit-website").val(data.customer.website);
                                $("#edit-phone").val(data.customer.phone);
                                $("#edit-contactSummary").val(data.customer.contactSummary);
                                $("#edit-nextContactTime").val(data.customer.nextContactTime);
                                $("#edit-description").val(data.customer.description);
                                $("#edit-address").val(data.customer.address);



                                $("#editCustomerModal").modal("show");
                                // alert($.trim($("#edit-id").val()))
                            }
                        }
                    });
                }
            });

            $("#updateBtn").click(function () {

                $.ajax({
                    url: "workbench/customer/update.do",
                    data: {
                        "id":$.trim($("#edit-id").val()),
                        "owner":$.trim($("#edit-owner").val()),
                        "name":$.trim($("#edit-customerName").val()),
                        "website":$.trim($("#edit-website").val()),
                        "phone":$.trim($("#edit-phone").val()),
                        "contactSummary":$.trim($("#edit-contactSummary").val()),
                        "nextContactTime":$.trim($("#edit-nextContactTime").val()),
                        "description":$.trim($("#edit-description").val()),
                        "address":$.trim($("#edit-address").val())

                    },
                    type: "get",
                    dataType: "json",
                    success: function (data) {
                        // data : {"success":true/false}

                        if (data.success) {
                            pageList($("#customerPage").bs_pagination('getOption', 'currentPage')
                                ,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            // 关闭模态窗口
                            $("#editCustomerModal").modal("hide");
                        } else {
                            alert("修改客户失败");
                        }

                    }
                });
            });


            //为创建线索保存按钮绑定事件，执行线索添加操作
            $("#saveBtn").click(function () {
                $.ajax({
                    url : "workbench/customer/save.do",
                    data : {
                        "owner" : $.trim($("#create-owner").val()),
                        "customerName" : $.trim($("#create-customerName").val()),
                        "website" : $.trim($("#create-website").val()),
                        "phone" : $.trim($("#create-phone").val()),
                        "description" : $.trim($("#create-description").val()),
                        "contactSummary" : $.trim($("#create-contactSummary").val()),
                        "nextContactTime" : $.trim($("#create-nextContactTime").val()),
                        "address" : $.trim($("#create-address").val()),
                    },
                    type: "POST",
                    dataType: "json",
                    success : function (data) {
                        if(data.success){
                            $("#AddForm")[0].reset();
                            //刷新列表;
                            //关闭模态窗口
                            $("#createCustomerModal").modal("hide");
                            pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            // alert("添加成功")
                        }else {
                            alert("添加联系人失败")
                        }
                    }
                });
            });
        });

        //分页显示操作
        function pageList(pageNumber, pageSize) {
            //pageList($("#activityPage").bs_pagination('getOption','currentPage'), $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
            //每次刷新清除复选框
            $("#selectAll").prop("checked", false);
            //查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-name").val($("#hidden-name").val());
            $("#search-owner").val($("#hidden-owner").val());
            $("#search-phone").val($("#hidden-phone").val());
            $("#search-website").val($("#hidden-website").val());
            $.ajax({
                url: "workbench/customer/pageList.do",
                data: {
                    "pageNumber": pageNumber,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "phone": $.trim($("#search-phone").val()),
                    "website": $.trim($("#search-website").val()),
                },
                type: "POST",
                dataType: "json",
                success: function (data) {
                    var html = "";
                    //每一个n就是每一个市场活动对象
                    $.each(data.dataList, function (i, n) {

                        html += '<tr>';
                        html += '<td><input type="checkbox" name="selectOne" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.phone + '</td>';
                        html += '<td>' + n.website + '</td>';
                        html += '</tr>';
                    });


                    $("#customerBody").html(html);
                    //计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
                    //数据处理完毕后，结合分页查询，对前端展现分页信息
                    $("#customerPage").bs_pagination({
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

            //为全选的复选框绑定事件，触发全选操作
            $("#selectAll").click(function () {
                $("input[name=selectOne]").prop("checked", this.checked);
            });

            /*
            因为动态生成的元素，是不能够以普通绑定事件的形式来进行操作的
            动态生成的元素，我们要以on方法的形式来触发事件
            语法：
                $(需要绑定元素的有效的外层元素).on(绑定事件的方式，需要绑定的元素的jquery对象，回调函数)
             */
            $("#customerBody").on("click", $("input[name=selectOne]"), function () {
                $("#selectAll").prop("checked", $("input[name=selectOne]").length == $("input[name=selectOne]:checked").length)
            });


        }
    </script>
</head>
<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="AddForm">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                            </select>
                        </div>
                        <label for="create-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
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
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
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
                        <label for="edit-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone">
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
                                <input type="text" class="form-control" id="edit-nextContactTime">
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
            <h3>客户列表</h3>
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
                        <input class="form-control" type="hidden" id="hidden-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                        <input class="form-control" type="hidden" id="hidden-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="search-phone">
                        <input class="form-control" type="hidden" id="hidden-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="search-website">
                        <input class="form-control" type="hidden" id="hidden-website">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>
                    创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="selectAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="customerBody">
                <%--<tr>
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="customerPage"></div>
        </div>

    </div>

</div>
</body>
</html>