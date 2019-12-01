<%@page isELIgnored="false" contentType="text/html; utf-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="app" value="${pageContext.request.contextPath}"></c:set>
<script>
    $(function () {
        $("#article_table").jqGrid({
            url: "${app}/article/findByPage",
            styleUI: "Bootstrap",
            autowidth: true,
            datatype: "json",
            height: "100%",
            multiselect: true,
            rowNum: 2,
            viewrecords: true,
            rowList: [2, 4, 8],
            pager: "#article_div",
            colNames: ["id", "标题", "作者", "content", "状态", "上传时间", "发布时间", "操作",],
            colModel: [
                {name: "id", hidden: true},
                {name: "title", align: "center"},
                {name: "author", hidden: true},
                {name: "content", hidden: true},
                {
                    name: "status", align: "center", edittype: "select", editable: true,
                    editoptions: {value: "y:展示;n:不展示"},
                    formatter: function (a, b, c) {
                        if (a == "y") {
                            return "展示";
                        } else {
                            return "不展示";
                        }
                    }

                },
                {name: "uploadtime", align: "center", editable: true, edittype: "date"},
                {name: "publishtime", align: "center", editable: true, edittype: "date"},
                {
                    name: "", align: "center",
                    formatter: function (a, b, c) {
                        return "<button onclick=\"lookArticle('" + c.id + "')\" class=\"glyphicon glyphicon-th-list btn-primary\"></button>           <button class=\"glyphicon glyphicon-pencil btn-primary\"></button>"
                    }
                }
            ]
        }).jqGrid("navGrid", "#article_div",
            {},
            {},
            {},
            {}
        )
    })

    function lookArticle(id) {
        $("#myModal").modal("show");
        $("#addArticleFrom")[0].reset();


        var value = $("#article_table").getRowData(id);
        $("#title").val(value.title);
        $("#author").val(value.author);
        var s = value.status;
        if (s == "展示") {
            $("#status").val("y");
        } else {
            $("#status").val("n");
        }

        $("#author").prop("disabled", true);
        $("#modal_footer").html(" <button type=\"button\" onclick=\"updateArticle('" + id + "')\" class=\"btn btn-primary\">修改</button>\n" +
            "                <button type=\"button\" class=\"btn btn-danger\" data-dismiss=\"modal\">取消</button>");
        KindEditor.create('#editor', {
            uploadJson: "${app}/kindeditor/upload",
            filePostName: "image",
            fileManagerJson: "${app}/kindeditor/getAllImg",
            allowFileManager: true,
            afterBlur: function () {
                this.sync();
            }
        })
        KindEditor.html("#editor", "");
        KindEditor.appendHtml("#editor", value.content);
    }

    function updateArticle(id) {
        $.ajax({
            url: "${app}/article/update?id=" + id,
            datatype: "json",
            type: "post",
            data: $("#addArticleFrom").serialize(),
            success: function (data) {
                $("#myModal").modal("toggle");
                $("#article_table").trigger("reloadGrid")
            }
        })
    }


    function showArticle() {
        $("#myModal").modal("show");
        $("#addArticleFrom")[0].reset();
        KindEditor.html("#editor", "");
        $("#modal_footer").html(" <button type=\"button\" onclick='addArticle()' class=\"btn btn-primary\">保存</button>\n" +
            "                <button type=\"button\" class=\"btn btn-danger\" data-dismiss=\"modal\">取消</button>");
        KindEditor.create('#editor', {
            uploadJson: "${app}/kindeditor/upload",
            filePostName: "image",
            fileManagerJson: "${app}/kindeditor/getAllImg",
            allowFileManager: true,
            afterBlur: function () {
                this.sync();
            }
        })
    }

    function addArticle() {
        $.ajax({
            url: "${app}/article/add",
            datatype: "json",
            type: "post",
            data: $("#addArticleFrom").serialize(),
            success: function (data) {
                $("#myModal").modal("toggle");
                $("#article_table").trigger("reloadGrid")
            }
        })
    }
</script>
<div>

    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" class="active"><a href="#home" aria-controls="home" role="tab"
                                                  data-toggle="tab">文章列表</a></li>
        <li role="presentation"><a href="#profile" onclick="showArticle()" aria-controls="profile" role="tab"
                                   data-toggle="tab">添加文章</a></li>
    </ul>


</div>


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
                <h4 class="modal-title">编辑用户信息</h4>
            </div>

            <!--模态框内容体-->
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/article/editArticle" class="form-horizontal"
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
                        <label class="col-sm-1 control-label">状态</label>
                        <div class="col-sm-5">
                            <select class="form-control" name="status" id="status">
                                <option value="y">展示</option>
                                <option value="n">不展示</option>
                            </select>
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
                <%--<button type="button" class="btn btn-primary">保存</button>--%>
                <%--<button type="button" class="btn btn-danger" data-dismiss="modal">取消</button>--%>
            </div>
        </div>
    </div>
</div>


<table id="article_table"></table>
<div id="article_div"></div>
