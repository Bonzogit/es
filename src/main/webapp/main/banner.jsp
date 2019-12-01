<%@page isELIgnored="false" contentType="text/html; utf-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="app" value="${pageContext.request.contextPath}"></c:set>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <script>
        $(function () {
            $("#banner").jqGrid({
                url: "${app}/banner/findByPage",
                editurl: "${app}/banner/edit",
                datatype: "json",
                styleUI: "Bootstrap",
                autowidth: true,
                pager: "#bannerPager",
                rowNum: 2,
                page: 1,
                multiselect: true,
                rowList: [2, 4, 8],
                viewrecords: true,
                colNames: ["编号", "标题", "状态", "描述", "创建时间", "图片"],
                colModel: [
                    {name: "id"},
                    {
                        name: "title",
                        editable: true
                    },
                    {
                        name: "status", edittype: "select",
                        editoptions: {value: "y:展示;n:不展示"},
                        formatter: function (a, b, c) {
                            if (a == 'y') {
                                return "展示";
                            } else {
                                return "不展示";
                            }
                        },
                        editable: true
                    },
                    {
                        name: "message",
                        editable: true
                    },
                    {name: "createtime"},
                    {
                        name: "src",
                        editable: true, edittype: "file",
                        formatter: function (cellvalue, options, rowObject) {

                            return "<img style='width:100px;height:70px' src='${app}/img/" + cellvalue + "'/>"
                        }
                    }
                ]
            }).jqGrid("navGrid", "#bannerPager",
                {},
                {
                    closeAfterEdit: true,
                    beforeShowForm: function (obj) {
                        obj.find("#src").attr("disabled", true)
                    }
                },

                {
                    closeAfterAdd: true,
                    afterSubmit: function (response) {
                        var test = response.responseText;

                        $.ajaxFileUpload({
                            url: "${app}/banner/upload",
                            data: {"imgId": test},
                            fileElementId: "src",
                            success: function (data) {

                            }
                        })
                        return response
                    }
                },
                {
                    reloadAfterSubmit: true
                }
            )
        })

        function addExcel() {
            location.href = "${app}/banner/excel"
        }
    </script>
</head>
<body>
<button onclick="addExcel()">轮播图信息导出</button>
<table id="banner">

</table>
<div id="bannerPager"></div>
</body>
</html>