<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<html lang="en">

<head>
    <link rel="stylesheet" type="text/css" href="src/main/webapp/static/css/app.css"/>
    <link rel="stylesheet" type="text/css" href="src/main/webapp/static/css/app.css"/>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" documentLink="IE=edge">
    <meta name="viewport" documentLink="width=device-width, initial-scale=1">
    <meta name="description" documentLink="">
    <meta name="author" documentLink="">

    <title> Your Disk</title>

    <link rel="shortcut icon" href="/static/icon.png"
          type="image/x-icon">
    <!-- Bootstrap Core CSS -->
    <link href="<c:url value='/static/css/bootstrap.css' />" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<c:url value='/static/css/sb-admin.css' />" rel="stylesheet">
    <link href="<c:url value='/static/css/app.css' />" rel="stylesheet">
    <link href="<c:url value='/static/css/footer-distributed.css' />" rel="stylesheet">
    <!-- Morris Charts CSS -->
    <link href="<c:url value='/static/css/plugins/morris.css' />" rel="stylesheet">
    <!-- Custom Fonts -->
    <link href="<c:url value='/static/font-awesome/css/font-awesome.min.css' />" rel="stylesheet">

</head>

<body>

<div id="wrapper">
    <!-- Navigation -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>

            <span class="navbar-brand"><i class="glyphicon glyphicon-hdd"></i> Your Disk </span>
            <%--<span class=" glyphicon glyphicon-th-list"></span><strong class="directory">--%>
            <%--Directory: ${directory}</strong>--%>

            <ul class="nav navbar-nav navstrong">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/open-root-folder-${user.id}' />">
                        <strong class="navbut"><i class="fa fa-home fa-3"></i> Home</strong></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/open-folder-${user.id}-${parent_folder_id}'/>">
                        <strong class="navbut"> <i class="fa fa-arrow-up fa-3"></i> Go up</strong></a>
                </li>
                <li class="nav-item">
                    <span class="glyphicon glyphicon-th-list nav-item"></span><strong class="directory">
                    Directory: ${directory}</strong>
                </li>

            </ul>

        </div>
        <!-- Top Menu Items -->
        <ul class="nav navbar-right top-nav">
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i
                        class="fa fa-user"></i> ${user.firstName} ${user.lastName} <b
                        class="caret"></b></a>
                <ul class="dropdown-menu">
                    <li><a href="<c:url value='/edit-user-${user.ssoId}' />"><i class="fa fa-gear"></i> Profile</a></li>

                    <sec:authorize access="hasRole('ADMIN') or hasRole('DBA')">
                    <li><a href="<c:url value='/list' />"><i class="fa fa-list-alt"></i> User List</a></li>
                    </sec:authorize>

                    <li class="divider"></li>
                    <li><a href="<c:url value="/logout" />"><i class="fa fa-power-off"></i> Log Out</a></li>
                </ul>
            </li>
        </ul>
        <!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
        <div class="collapse navbar-collapse navbar-ex1-collapse">
            <ul class="nav navbar-nav side-nav">
                <li>
                    <form class="form-group input-group search" action="/search-${user.id}-${currentFolder.id}">
                        <input type="text" placeholder="Search files" class="form-control" name="target">
                        <span class="input-group-btn"><button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button></span>
                    </form>
                </li>
                <li>
                    <a href="javascript:;" data-toggle="collapse" data-target="#demo"><span class="glyphicon glyphicon-check"></span>
                    Filters <i class="fa fa-fw fa-caret-down"></i></a>
                    <div id="demo" class="collapse container">
                        <form action="/filter-${user.id}-${currentFolder.id}">
                            <div class="form-group">
                                <div class="checkbox"><label><input type="checkbox" name="filters" value="documents">Documents</label></div>
                                <div class="checkbox"><label><input type="checkbox" name="filters" value="pictures">Pictures</label></div>
                                <div class="checkbox"><label><input type="checkbox" name="filters" value="videos">Videos</label></div>
                                <div class="checkbox"><label><input type="checkbox" name="filters" value="zip">Zip-archives</label></div>
                            </div>
                            <input type="submit" class="btn btn-default btn-search" value="search">
                        </form>
                    </div>
                </li>
                <%--<li>--%>
                    <%--<a href="<c:url value='/open-root-folder-${user.id}' />"><hr><i class="fa fa-home fa-3"></i>--%>
                        <%--ROOT Folder</a>--%>
                <%--</li>--%>
                <%--<li>--%>
                    <%--<a href="<c:url value='/open-folder-${user.id}-${parent_folder_id}'/>"><i class="fa fa-arrow-up fa-3"></i>--%>
                        <%--GO UP</a>--%>
                <%--</li>--%>

                <li>
                    <a href="#" type="button" data-toggle="modal" data-target="#upload"><hr> <span class="glyphicon glyphicon-upload"></span>
                        Upload a file</a>
                </li>
                <li>
                    <a href="#" type="button" data-toggle="modal" data-target="#new_folder"><span class="glyphicon glyphicon-folder-close"></span>
                        Create new Folder </a>
                    <%--This if block is used to show an error produced by wrong Folder name input (separately from modal form)  --%>
                    <c:if test="${fn:length(folderError) gt 0}">
                        <a href="#" type="button" style="color: red"><span class="glyphicon glyphicon-warning-sign"></span> ${folderError} </a>
                    </c:if>
                </li>
                <li>
                    <a href="javascript:;" data-toggle="collapse" data-target="#demo2" title="By size in KB"><hr><span class="fa fa-pie-chart"></span>
                        Top files <i class="fa fa-fw fa-caret-down"></i></a>
                    <div id="demo2" class="collapse container row">
                        <div id="morris-donut-chart-top" style="height: 220px;width: 200px;"></div>
                    </div>
                </li>
                <li>
                    <a href="javascript:;" data-toggle="collapse" data-target="#demo1" title="By size in KB"><span class="fa fa-pie-chart"></span>
                        Types structure <i class="fa fa-fw fa-caret-down"></i></a>
                    <div id="demo1" class="collapse in container row">
                        <div id="morris-donut-chart" style="height: 220px;width: 210px;"></div>
                    </div>
                </li>
            </ul>
        </div>
        <!-- /.navbar-collapse -->
    </nav>


    <div id="page-wrapper">

        <div class="container-fluid">
            <div class="divider"></div>
            <c:if test="${fn:length(folders) gt 0}">
                <div class="alert alert-success cursor" data-toggle="collapse" data-target="#folders-collapse"
                     aria-expanded="false" aria-controls="collapseExample">
                    <strong><span class="glyphicon glyphicon-plus"></span> Folders </strong>
                </div>
                <div class="row collapse in" id="folders-collapse">
            </c:if>
                <!-- Page Heading -->
                <%--Folders container items--%>
                <c:forEach items="${folders}" var="doc" varStatus="counter">
                    <div class="col-lg-2 col-md-3 col-xs-6">
                        <div class="panel panel-primary">
                            <div class="panel-heading cursor"
                                 onmouseenter="this.setAttribute('style','background-color:#163b5a;')"
                                 onmouseleave="this.setAttribute('style','background-color:#337ab7;')"
                                 onclick="location.href = '<c:url value='/open-folder-${user.id}-${doc.id}'/>';">
                                <div class="row">
                                        <%--Folder icon--%>
                                    <div class="col-xs-3"><i class="fa fa-folder fa-3x"></i></div>
                                        <%--Folder name--%>
                                    <div class="col-xs-9 text-right">
                                        <div>${doc.name}</div>
                                    </div>
                                        <%--Number and total size of files in folder--%>
                                    <div class="col-xs-9 text-right">
                                        <div class="info-text">${doc.filesCounter} files</div>
                                        <div class="info-text">${doc.size} Kb</div>
                                    </div>
                                </div>
                            </div>
                            <a href="#">
                                <div class="panel-footer">
                                    <div class="row">
                                        <a href="<c:url value='/delete-folder-${user.id}-${doc.id}' />" class="btn btn-default btn-sm pull-right delete">
                                            Delete <span class="glyphicon glyphicon-trash"></span>
                                        </a>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
                <%--/ Folders container items--%>

                <%--Choose construction is used to show 'No files here' alert, when current folder is empty--%>
            <c:choose>
                <c:when test="${fn:length(documents) gt 0}">
                    <div class="alert alert-success cursor" data-toggle="collapse" data-target="#files-collapse" aria-expanded="false" aria-controls="collapseExample">
                        <strong><span class="glyphicon glyphicon-plus"></span> Files</strong>
                    </div>
                    <div class="row collapse in" id="files-collapse">
                </c:when>
                <c:otherwise>
                    <div class="alert alert-danger">
                        <h3>No files here</h3>
                    </div>
                </c:otherwise>
            </c:choose>

                <%-- Files container items--%>
                <c:forEach items="${documents}" var="doc" varStatus="counter">
                    <div class="col-lg-3 col-md-6 col-xs-6">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                        <%--File icon (depends of file type)--%>
                                    <div class="col-xs-3"> <i title="Click to preview in new window" class="fa fa-file${doc.glyphicon}o fa-5x cursor"
                                           onmouseenter="this.setAttribute('style','color:#337ab7;')"
                                           onmouseleave="this.setAttribute('style','color:#333;')"
                                           onclick="window.open('<c:url value='/preview-document-${user.id}-${doc.id}'/>','_blank')"></i>
                                    </div>
                                        <%--File name--%>
                                    <div class="col-xs-9 text-right"><div>${doc.name}</div></div>
                                </div>
                                <div class="row">
                                        <%--File type and size --%>
                                    <div class="col-lg-offset-1 col-sm-offset-1 col-md-offset-1 col-xs-offset-1 text-center">
                                            ${doc.type} | ${doc.size} Kb
                                    </div>
                                </div>
                            </div>
                            <a href="#">
                                <div class="panel-footer  text-center">
                                    <div class="text-center">
                                        <a target="_blank" href="<c:url value='/download-document-${user.id}-${doc.id}' />"class="btn btn-default btn-sm"><span class="fa fa-download"></span>
                                           Download</a>
                                        <a href="<c:url value='/preview-document-${user.id}-${doc.id}' />" target="_blank" class="btn btn-default btn-sm">
                                           Preview </span> </a>
                                        <a href="<c:url value='/delete-document-${user.id}-${doc.id}-${currentFolder.id}' />" class="btn btn-default btn-sm">
                                           Delete <span class="glyphicon glyphicon-trash"></span> </a>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </c:forEach>
                    <%--/ Files container items--%>
                </div>
            <!-- /.container-fluid -->
        </div>
        <!-- /#page-wrapper -->
    </div>
    <!-- /#wrapper -->
</div>

<%--Bootstrap Modal elements are used to add some animation and nice looking to "File upload" and "Create folder" forms--%>
<div class="modal fade" id="upload" role="dialog">
    <div class="modal-dialog">
        <!-- Modal documentLink-->
        <div class="modal-documentLink">
            <div class="modal-header text-center">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="text-center"><span class="glyphicon glyphicon-upload"></span>
                    Upload a document</h4>
            </div>
            <div class="modal-body">
                <form:form role="form" method="POST" modelAttribute="fileBucket" enctype="multipart/form-data"
                           action="/add-document-${user.id}-${currentFolder.id}" class="form-vertical">
                    <div class="form-group text-center">
                        <label class="btn btn-default " for="my-file-selector">
                            <form:input type="file" path="file" id="my-file-selector" style="display:none;" class="form-control input-sm" onchange="$('#upload-file-info').html($(this).val().substring(12));"/>
                            Browse
                        </label>
                        <span class='label label-info' id="upload-file-info"></span>
                    </div>
                    <button type="submit" class="btn btn-success btn-block">Upload</button>
                </form:form>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-danger btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span>Cancel
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="new_folder" role="dialog">
    <div class="modal-dialog">
        <!-- Modal documentLink-->
        <div class="modal-documentLink">
            <div class="modal-header text-center">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="text-center"><span class="glyphicon glyphicon-folder-close"></span>
                    Create new Folder
                </h4>
            </div>
            <div class="modal-body">
                <form:form role="form" method="POST" modelAttribute="folderBucket" action="/create-folder-${user.id}-${currentFolder.id}">
                    <div class="form-group text-center">
                        <form:input class="form-control input-sm" type="text" placeholder="Folder name" name="folderName" path="folderName"/>
                    </div>
                    <button type="submit" class="btn btn-success btn-block"> Create</button>
                </form:form>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-danger btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel
                </button>
            </div>
        </div>
    </div>
</div>


<footer class="footer-distributed">

    <div class="footer-right">

        <a href="https://www.facebook.com/profile.php?id=100006472218074"><i class="fa fa-facebook"></i></a>
        <a href="#"><i class="fa fa-linkedin"></i></a>
        <a href="https://vk.com/darkush"><i class="fa fa-vk"></i></a>
        <a href="https://github.com/relzet/"><i class="fa fa-github"></i></a>

    </div>

    <div class="footer-left">
        <p>Borovyk Sergey © 2016</p>
    </div>

</footer>

<!-- jQuery -->
<script src="/static/js/jquery.js"></script>


<!-- Bootstrap Core JavaScript -->
<script src="/static/js/bootstrap.min.js"></script>
<script src="/static/js/bootstrap-filestyle.min.js"></script>

<script src="/static/js/plugins/morris/raphael.min.js"></script>
<script src="/static/js/plugins/morris/morris.js"></script>
<script src="/static/js/plugins/morris/morris-data.js"></script>

<%--This script is used to add some graphic visualisation to TOP files feature--%>
<script>
    (function () {
        Morris.Donut({
            element: 'morris-donut-chart-top',
            data: [
                <c:forEach items="${top}" var="doc" varStatus="counter">
                {
                    <c:set var="string1" value="${doc.name}"/>
                    <c:set var="string2" value="${fn:substring(string1, 0, 15)}" />
                    label: "${string2}",
                    value: ${doc.size}
                },
                </c:forEach>
            ],
            resize: true
        })
    })();
    (function () {
        Morris.Donut({
            element: 'morris-donut-chart',
            data: [
                <c:forEach items="${structure}" var="doc" varStatus="counter">
                {
                    label: "${doc.key}",
                    value: ${doc.value}
                },
                </c:forEach>
            ],
            resize: true
        })
    })();
</script>
</body>

</html>
