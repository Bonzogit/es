<%@page isELIgnored="false" contentType="text/html; utf-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="app" value="${pageContext.request.contextPath}"></c:set>
<script>
    $(function () {
        $("#tb").jqGrid({
            url: "${app}/album/findByPage",
            editurl: "${app}/album/edit",
            datatype: "json",
            pager: "#album_div",
            rowNum: 2,
            multiselect: true,
            viewrecords: true,
            rowList: [2, 4, 8],
            styleUI: "Bootstrap",
            autowidth: true,
            height: "60%",
            colNames: ["标题", "分数", "作者", "播音员", "章节数", "专辑简介", "状态", "发行时间", "上传时间", "插图"],
            colModel: [
                {name: "title", editable: true},
                {name: "score", editable: true},
                {name: "author", editable: true},
                {name: "announcer", editable: true},
                {name: "chaptersize", editable: true},
                {name: "message", editable: true},
                {
                    name: "status", editable: true, edittype: "select",
                    editoptions: {value: "y:展示;n:不展示"},
                    formatter: function (a, b, c) {
                        if (a == 'y') {
                            return "展示";
                        } else {
                            return "不展示";
                        }
                    },
                },
                {name: "publishtime"},
                {name: "uploadtime"},
                {
                    name: "src", editable: true, edittype: "file",
                    formatter: function (a, b, c) {
                        return "<img style='width:100px;height:70px' src = '${app}/img/" + a + "'>"
                    }
                }
            ],
            subGrid: true,
            subGridRowExpanded: function (subgrid_id, row_id) {
                var subgrid_table_id, pager_id;
                subgrid_table_id = subgrid_id + "_t";
                pager_id = "p_" + subgrid_table_id;
                $("#" + subgrid_id).html(
                    "<table id='" + subgrid_table_id
                    + "' class='scroll'></table><div id='"
                    + pager_id + "' class='scroll'></div>");
                jQuery("#" + subgrid_table_id).jqGrid(
                    {
                        url: "${app}/chapter/findByPage?id=" + row_id,
                        editurl: "${app}/chapter/edit?albumid=" + row_id,
                        multiselect: true,
                        viewrecords: true,
                        styleUI: "Bootstrap",
                        autowidth: true,
                        datatype: "json",
                        colNames: ['标题', '大小', '时长', '上传时间', '音频', '操作'],
                        colModel: [
                            {name: "title", width: 80, editable: true},
                            {name: "size", width: 80},
                            {name: "length", width: 80},
                            {name: "publishtime"},
                            {
                                name: "src", editable: true, edittype: "file",

                            },
                            {
                                name: "xxx",
                                formatter: function (a, b, c) {
                                    var s = c.src;
                                    return "<audio src='${app}/img/" + s + "' controls  autoplay></audio>"
                                }
                            }
                        ],
                        rowNum: 2,
                        pager: pager_id,

                        height: '100%'
                    }).jqGrid("navGrid", "#" + pager_id,
                    {},
                    {
                        closeAfterEdit: true,
                        beforeShowForm: function (obj) {
                            obj.find("#src").attr("disabled", true)
                            obj.find("#size").attr("readonly", true)
                            obj.find("#length").attr("readonly", true)

                        }
                    },
                    {
                        closeAfterAdd: true,
                        afterSubmit: function (res) {
                            var t = res.responseText;
                            $.ajaxFileUpload({
                                url: "${app}/chapter/upload",
                                data: {"id": t},
                                fileElementId: "src",
                                success: function (data) {
                                    $("#" + subgrid_table_id).trigger("reloadGrid")
                                }
                            })
                            return "aaa"
                        }
                    },
                    {}
                )
            }

        }).jqGrid("navGrid", "#album_div",
            {},
            {
                closeAfterEdit: true,
                beforeShowForm: function (obj) {
                    obj.find("#src").attr("disabled", true)
                    obj.find("#score").attr("readonly", true)
                    obj.find("#author").attr("readonly", true)
                    obj.find("#announcer").attr("readonly", true)
                    obj.find("#chaptersize").attr("readonly", true)
                    obj.find("#message").attr("readonly", true)
                }
            },
            {
                closeAfterAdd: true,
                afterSubmit: function (response) {
                    console.log(response);
                    var t = response.responseText;
                    console.log(t);
                    $.ajaxFileUpload({
                        url: "${app}/album/upload",
                        data: {"id": t},
                        fileElementId: "src",
                        success: function (data) {

                        }
                    })
                    return "aaa"
                }
            },
            {}
        )
    })
</script>
<body>
<table id="tb"></table>
<div id="album_div"></div>
</body>
