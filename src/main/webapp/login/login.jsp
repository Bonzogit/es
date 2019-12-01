<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="app" value="${pageContext.request.contextPath}"></c:set>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap Login Form Template</title>
    <!-- CSS -->
    <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Roboto:400,100,300,500">
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="assets/css/form-elements.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="shortcut icon" href="assets/ico/favicon.png">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-57-precomposed.png">
    <script src="../boot/js/jquery-2.2.1.min.js"></script>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/js/jquery.backstretch.min.js"></script>
    <script src="assets/js/scripts.js"></script>
    <script src="../boot/js/jquery.validate.min.js"></script>
    <script>
        $(function () {
            var aname = false;
            var apwd = false;
            var avail = false;

            $("#captchaImage").click(function () {
                $(this).prop("src", "${app}/kaptcha/vail?t=" + new Date().getTime());
            })
            $("#form-username").blur(function () {
                var un = $(this).val();
                if (un.trim() == "") {
                    $("#msgDiv").html("<font color='red'>姓名不能为空！<font>")
                } else if (un.length > 10) {
                    $("#msgDiv").html("<font color='red'>长度不能超过10位！<font>")
                } else {
                    $("#msgDiv").empty();
                    aname = true;

                }
            });

            $("#form-password").blur(function () {
                var un = $(this).val();
                if (un.trim() == "") {
                    $("#msgDiv").html("<font color='red'>密码不能为空！<font>")
                } else if (un.length > 6) {
                    $("#msgDiv").html("<font color='red'>长度不能超过6位！<font>")
                } else {
                    $("#msgDiv").empty();
                    apwd = true;
                }
            });
            $("#form-code").blur(function () {
                var un = $(this).val();
                if (un.trim() == "") {
                    $("#msgDiv").html("<font color='red'>验证码不能为空！<font>")
                } else if (un.length != 4) {
                    $("#msgDiv").html("<font color='red'>请输入4位验证码！<font>")
                } else {
                    $("#msgDiv").empty();
                    avail = true;
                }
            });

            $("#loginButtonId").click(function () {
                var un = $("#form-username").val();
                var pwd = $("#form-password").val();
                var vail = $("#form-code").val();

                $("input").trigger("blur");
                if (aname == false && (apwd == true || avail == true)) {
                    $("#msgDiv").html("<font color='red'>请输入正确的用户名！<font>")
                } else if (apwd == false && (aname == true || avail == true)) {
                    $("#msgDiv").html("<font color='red'>密码格式错误！<font>")
                } else if ((aname == true || apwd == true) && avail == false) {
                    $("#msgDiv").html("<font color='red'>请输入四位验证码<font>")
                } else if (aname == true && apwd == true && avail == true) {

                    $.ajax({
                        url: "${app}/admin/login",

                        type: "post",
                        data: $("#loginForm").serialize(),
                        success: function (data) {

                            var da = data;
                            if (data != "") {
                                $("#msgDiv").html("<font color='red'>" + data + "</font>");
                            } else {
                                location.href = "${app}/main/main.jsp";
                            }
                        }
                    })
                }
            })


        })
    </script>
</head>

<body>

<!-- Top content -->
<div class="top-content">

    <div class="inner-bg">
        <div class="container">
            <div class="row">
                <div class="col-sm-8 col-sm-offset-2 text">
                    <h1><strong>CMFZ</strong> Login Form</h1>
                    <div class="description">
                        <p>
                            <a href="#"><strong>CMFZ</strong></a>
                        </p>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6 col-sm-offset-3 form-box">
                    <div class="form-top" style="width: 450px">
                        <div class="form-top-left">
                            <h3>Login to showall</h3>
                            <p>Enter your username and password to log on:</p>
                        </div>
                        <div class="form-top-right">
                            <i class="fa fa-key"></i>
                        </div>
                    </div>
                    <div class="form-bottom" style="width: 450px">
                        <form role="form" action="" method="post" class="login-form" id="loginForm">
                            <span id="msgDiv"></span>
                            <div class="form-group">
                                <label class="sr-only" for="form-username">Username</label>
                                <input type="text" name="name" placeholder="请输入用户名..."
                                       class="form-username form-control" id="form-username">
                            </div>
                            <div class="form-group">
                                <label class="sr-only" for="form-password">Password</label>
                                <input type="password" name="password" placeholder="请输入密码..."
                                       class="form-password form-control" id="form-password">
                            </div>
                            <div class="form-group">
                                <img id="captchaImage" style="height: 48px" class="captchaImage"
                                     src="${app}/kaptcha/vail">
                                <input style="width: 289px;height: 50px;border:3px solid #ddd;border-radius: 4px;"
                                       type="test" name="code" id="form-code">
                            </div>
                            <input type="button" style="width: 400px;border:1px solid #9d9d9d;border-radius: 4px;"
                                   id="loginButtonId" value="登录">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>


</body>

</html>