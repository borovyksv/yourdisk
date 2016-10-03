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
                <div class="col-sm-8 col-sm-offset-2 text">
                    <h1>Welcome to <strong><a href="<c:url value='/add-document-${user.id}' />" >Your Disk</a></strong></h1>
                    <div class="description">
                        <p>
                            Here you can store personal files and documents
                        </p>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-8 col-sm-offset-2 form-box">
                    <div class="form-top">
                        <div class="form-top-left">
                            <h3>User Registration Form</h3>

                        </div>

                    </div>
                    <div class="form-bottom">
                        <form:form method="POST" modelAttribute="user" class="form-horizontal">
                            <form:input type="hidden" path="id" id="id"/>

                            <div class="row">
                                <div class="form-group col-md-12">
                                    <label class="col-md-3 control-lable" for="firstName">First Name</label>
                                    <div class="col-md-9">
                                        <form:input type="text" path="firstName" id="firstName" class="form-control input-sm"/>
                                        <div class="has-error">
                                            <form:errors path="firstName" class="help-inline"/>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="form-group col-md-12">
                                    <label class="col-md-3 control-lable" for="lastName">Last Name</label>
                                    <div class="col-md-9">
                                        <form:input type="text" path="lastName" id="lastName" class="form-control input-sm" />
                                        <div class="has-error">
                                            <form:errors path="lastName" class="help-inline"/>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="form-group col-md-12">
                                    <label class="col-md-3 control-lable" for="ssoId">SSO ID</label>
                                    <div class="col-md-9">
                                        <c:choose>
                                            <c:when test="${edit}">
                                                <form:input type="text" path="ssoId" id="ssoId" class="form-control input-sm" disabled="true"/>
                                            </c:when>
                                            <c:otherwise>
                                                <form:input type="text" path="ssoId" id="ssoId" class="form-control input-sm" />
                                                <div class="has-error">
                                                    <form:errors path="ssoId" class="help-inline"/>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="form-group col-md-12">
                                    <label class="col-md-3 control-lable" for="password">Password</label>
                                    <div class="col-md-9">
                                        <form:input type="password" path="password" id="password" class="form-control input-sm" />
                                        <div class="has-error">
                                            <form:errors path="password" class="help-inline"/>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="form-group col-md-12">
                                    <label class="col-md-3 control-lable" for="email">Email</label>
                                    <div class="col-md-9">
                                        <form:input type="text" path="email" id="email" class="form-control input-sm" />
                                        <div class="has-error">
                                            <form:errors path="email" class="help-inline"/>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="form-group col-md-12">
                                    <label class="col-md-3 control-lable" for="userProfiles">Roles</label>
                                    <div class="col-md-9">
                                            <%--<form:select path="userProfiles" items="${roles}" multiple="true" itemValue="id" itemLabel="type" class="form-control input-sm" />--%>
                                        <form:select id="userProfiles" name="userProfiles" class="form-control input-sm" multiple="multiple" path="userProfiles">
                                            <sec:authorize access="hasRole('ADMIN')">
                                                <option value="2">ADMIN</option>
                                                <option value="3">DBA</option>
                                            </sec:authorize>
                                            <option value="1" >USER</option>
                                        </form:select>

                                        <div class="has-error">
                                            <form:errors path="userProfiles" class="help-inline"/>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">

                                <div class="form-actions ">

                                    <c:choose>
                                        <c:when test="${edit}">
                                            <button type="submit" class="btn">Update</button>
                                            <button class="btn" style="margin-top: 2%; background-color: rgba(0, 0, 0, .5);"><a href="<c:url value='/add-document-${user.id}' />">Cancel</a></button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="submit" class="btn">Register</button>
                                            <button class="btn" style="margin-top: 2%; background-color: rgba(0, 0, 0, .5);"><a href="<c:url value='/add-document-${user.id}' />">Cancel</a></button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                        </form:form>

                        </form>
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