<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>User Registration Form</title>
    <link rel="shortcut icon" href="/static/icon.png"
          type="image/x-icon">

    <!-- CSS -->
    <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Roboto:400,100,300,500">
    <link href="<c:url value='/static/css/bootstrap.css' />" rel="stylesheet">
    <link href="<c:url value='/static/font-awesome/css/font-awesome.min.css' />" rel="stylesheet">
    <link href="<c:url value='/static/css/form-elements.css' />" rel="stylesheet">
    <link href="<c:url value='/static/css/style.css' />" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->


</head>

<body>

<!-- Top content -->
<div class="top-content">

    <div class="inner-bg">
        <div class="container">
            <div class="row">
                <div class="col-sm-12  form-box">
                    <div class="form-top">
                        <div class="form-top-left">
                            <h3>List of registered users</h3>

                        </div>
                    </div>
                    <div class="form-bottom">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Firstname</th>
                                <th>Lastname</th>
                                <th>Email</th>
                                <th>SSO ID</th>
                                <sec:authorize access="hasRole('ADMIN')">
                                    <th width="100"></th>
                                </sec:authorize>
                                <sec:authorize access="hasRole('ADMIN') or hasRole('DBA')">
                                    <th width="100"></th>
                                </sec:authorize>
                                <sec:authorize access="hasRole('ADMIN')">
                                    <th width="100"></th>
                                </sec:authorize>

                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${users}" var="user">
                                <tr>
                                    <td>${user.firstName}</td>
                                    <td>${user.lastName}</td>
                                    <td>${user.email}</td>
                                    <td>${user.ssoId}</td>
                                    <sec:authorize access="hasRole('ADMIN') or hasRole('DBA')">
                                        <td><a href="<c:url value='/add-document-${user.id}' />"
                                               class="btn btn-info custom-width">Disk</a></td>
                                    </sec:authorize>
                                    <sec:authorize access="hasRole('ADMIN') or hasRole('DBA')">
                                        <td><a href="<c:url value='/edit-user-${user.ssoId}' />"
                                               class="btn btn-success custom-width">edit</a></td>
                                    </sec:authorize>
                                    <sec:authorize access="hasRole('ADMIN')">
                                        <td><a href="<c:url value='/delete-user-${user.ssoId}' />"
                                               class="btn btn-danger custom-width">delete</a></td>
                                    </sec:authorize>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                            <a href="<c:url value="/logout" />"><i class="fa fa-fw fa-power-off"></i> Log Out</a>
                    </div>
                </div>
            </div>

        </div>
    </div>

</div>


<!-- Javascript -->

<script src="static/js/jquery-1.11.1.min.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/jquery.backstretch.min.js"></script>
<script src="static/js/scripts.js"></script>



</body>

</html>