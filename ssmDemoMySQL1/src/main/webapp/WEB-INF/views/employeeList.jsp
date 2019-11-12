<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8"></meta>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"></meta>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>
    <meta name="renderer" content="webkit" />
    <link rel="icon" href="<%=basePath%>static/favicon.ico" type="image/x-icon" />
    <title>雇员管理</title>
    <link rel="stylesheet" href="<%=basePath%>webjars/layui/css/layui.css" />
    <link rel="stylesheet" href="<%=basePath%>static/css/zadmin.css">
    <link rel="stylesheet" href="<%=basePath%>static/css/common.css">
    <link rel="stylesheet" href="<%=basePath%>static/css/animate.min.css">
</head>
<body class="animated fadeIn timo-layout-page">
    <div class="page-loading">
        <div class="rubik-loader"></div>
    </div>
    <div class="animated fadeIn layui-card">
        <div class="layui-card-header timo-card-header">
            <span><i class="fa fa-bars"></i> 用户管理</span>
        </div>
        <div class="layui-card-body">
            <div class="layui-row timo-card-screen put-row">
                <div class="pull-right screen-btn-group">
                    <div class="btn-group-right">
                        <button class="layui-btn open-popup" id="add_btn"><i class="fa fa-plus"></i> 添加</button>
                        <button class="layui-btn open-popup" data-type="getCheckData" id="del_btn"><i class="fa fa-trash"></i> 删除</button>
                    </div>
                </div>
            </div>
            <div class="timo-table-wrap">
                <table class="layui-hide timo-table" id="user-table" lay-filter="allAttr"></table>
            </div>
        </div>
    </div>

    <script type="text/html" id="column-toolbar">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a>
    </script>

    <script src="<%=basePath%>webjars/jquery/jquery.min.js"></script>
    <script src="<%=basePath%>webjars/layui/layui.all.js"></script>
    <script src="<%=basePath%>static/js/common.js"></script>

    <script>
    layui.use(['table', 'element', 'form'], function () {
        var table = layui.table
        , $ = layui.$
        , form = layui.form;

        table.render({
            elem: '#user-table'
            , url: '<%=basePath%>api/employee/list'
            , page: true
            , id: 'userTable'
            , limits:[10,20,50]
            , cols: [
                [
                    {checkbox: true}
                    , {field: 'id', title: 'ID', width: "10%", hide: true}
                    , {field: 'name', title: '用户名', width: "15%"}
                    , {field: 'department', title: '部门', width: "15%"}
                    , {field: 'address', title: '地址', width: "15%"}
                    , {field: 'age', title: '年龄', width: "10%"}
                    , {field: 'tel', title: '手机', width: "14%"}
                    , {field: 'salary', title: '工资'}
                    , {title: '操作', fixed: 'right', align: 'center', toolbar: '#column-toolbar', width: "15%"}
                ]
            ]
        });
            
        $("#add_btn").on("click",function(){
            layer.open({
                content: "employeeChange",
                title: "新增用户",
                area: ['500px', '500px'],
                type: 2,
                maxmin: true,
                shadeClose: true,
                end: function () {
                    table.reload('userTable');
                }
            });
        });
            
        $("#del_btn").on("click",function(){
            var checkStatus = table.checkStatus('userTable')
            ,checkData = checkStatus.data;
            if (checkData.length === 0) {
                return layer.msg('请选择数据');
            }
            layer.confirm('确定删除吗?', function (index) {
                var reqBody = checkData.reduce(function(acc, cur) {
                    acc.push(cur.id);
                    return acc;
                }, []);
                ajaxJsonRequest("POST", '<%=basePath%>api/employee/delete',  JSON.stringify(reqBody), function (data) {
                    layer.close(index);
                    handlerResult(data, deleteDone)
                });
            });
        });

        // 行点击事件
        table.on('tool', function (obj) {
            var data = obj.data;
            var event = obj.event;
            if (event === 'edit') {
                edit(data.id);
            } else if (event === 'del') {
                del(obj);
            }
        });

        function edit(id) {
            layer.open({
                content: '<%=basePath%>employeeChange/' + id,
                title: "编辑",
                area: ['500px', '500px'],
                type: 2,
                maxmin: true,
                shadeClose: true,
                end: function () {
                    table.reload('userTable');
                }
            });
        }

        function del(obj) {
            layer.confirm("确定删除用户吗?", {icon: 3, title: '提示'}, function (index) {//确定回调
                var id = obj.data.id;
                ajaxJsonRequest("DELETE", '<%=basePath%>api/employee/' + id, null, function (data) {
                    layer.close(index);
                    handlerResult(data, deleteDone)
                });
            }, function (index) {//取消回调
                layer.close(index);
            });
        }

        function deleteDone(data) {
            parent.layer.msg("删除成功", {icon: 6});
            table.reload('userTable', {});
        }
    });
    </script>
</body>
</html>