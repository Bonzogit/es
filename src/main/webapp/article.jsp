<%@page isELIgnored="false" contentType="text/html; utf-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="app" value="${pageContext.request.contextPath}"></c:set>
<head>

    <link rel="stylesheet" href="${app}/boot/css/bootstrap.css">
    <link rel="stylesheet" href="${app}/jqgrid/css/jquery-ui.css">
    <link rel="stylesheet" href="${app}/jqgrid/css/trirand/ui.jqgrid-bootstrap.css">
    <script src="${app}/boot/js/jquery-2.2.1.min.js"></script>
    <script src="${app}/boot/js/bootstrap.js"></script>
    <script src="${app}/jqgrid/js/trirand/i18n/grid.locale-cn.js"></script>
    <script src="${app}/jqgrid/js/trirand/jquery.jqGrid.min.js"></script>
    <script src="${app}/boot/js/ajaxfileupload.js"></script>
    <script src="${app}/kindeditor/kindeditor-all-min.js"></script>
    <script src="${app}/kindeditor/lang/zh-CN.js"></script>
    <script>
        function add() {
            $("#myModal").modal("show");
        }

        function find() {
            var ip = $("#ip").val();
            $.ajax({
                url: "${app}/article/search",
                datatype: "json",
                data: {"param": ip},
                success: function (data) {
                    console.log(data);
                    $("#di").empty()
                    $.each(data, function (index, article) {
                        var br = $("<hr>");
                        var title = $("<p style='text-align: center'>").html(article.title);
                        var hr = $("<center> <a href='javascript:ck()'>点击查看更多</a></center> ")
                        var aa = $("<div class='head1'  style='text-align: center;display: none'>");
                        var author = $("<p style='text-align: center'>").html(article.author);
                        var time = $("<p style='text-align: center'>").html(article.time);
                        var content = $("<p style='text-align: center'>").html(article.content);
                        var ii = new Date().getTime();

                        aa.append(author).append(time).append(content);
                        $("#di").append(title).append(hr).append(aa).append(br);
                    })
                }
            })
        }

        function ck() {
            alert()
            $(this).next(".head1").prop("display", "block");
        }

        function save() {
            $.ajax({
                url: "${app}/article/add",
                datatype: "json",
                data: $("#addArticleFrom").serialize(),
                success: function (data) {
                    $("#myModal").modal("toggle");
                }
            })
        }
    </script>
</head>
<center>
    <button onclick="add()">添加文章</button>
</center>

<center><input style="text-align: center" id="ip" type="text" placeholder="请输入关键字"/>
    <button onclick="find()">搜索</button>
</center>
<div id="di"></div>
<%--模态框--%>
<div class="modal fade" id="myModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="width:750px">
            <!--模态框标题-->
            <div class="modal-header">
                <!--
                    用来关闭模态框的属性:data-dismiss="modal"
                -->
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">编辑文章</h4>
            </div>

            <!--模态框内容体-->
            <div class="modal-body">
                <form action="" class="form-horizontal"
                      id="addArticleFrom">
                    <div class="form-group">
                        <label class="col-sm-1 control-label">标题</label>
                        <div class="col-sm-5">
                            <input type="text" name="title" id="title" placeholder="请输入标题" class="form-control">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-1 control-label">作者</label>
                        <div class="col-sm-5">
                            <input type="text" name="author" id="author" placeholder="请输入作者" class="form-control">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-sm-12">
                            <textarea id="editor" name="content" style="width:700px;height:300px;"></textarea>
                        </div>
                    </div>
                    <input id="addInsertImg" name="insertImg" hidden>
                </form>
            </div>
            <!--模态页脚-->
            <div class="modal-footer" id="modal_footer">
                <button type="button" class="btn btn-primary" onclick="save()">保存</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
