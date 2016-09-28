<!DOCTYPE html>
<%--<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<html lang="en">

<head>


    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title> Your Disc</title>


    <link rel="shortcut icon" href="/static/icon.png"
          type="image/x-icon">
    <!-- Bootstrap Core CSS -->
    <link href="<c:url value='/static/css/bootstrap.css' />" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="<c:url value='/static/css/sb-admin.css' />" rel="stylesheet">
    <link href="<c:url value='/static/css/app.css' />" rel="stylesheet">

    <!-- Morris Charts CSS -->
    <link href="<c:url value='/static/css/plugins/morris.css' />" rel="stylesheet">


    <!-- Custom Fonts -->
    <link href="<c:url value='/static/font-awesome/css/font-awesome.min.css' />" rel="stylesheet">


    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <c:set var="types" value="${fn:split('image,text,pdf', ',')}" scope="application"/>
    <c:set var="disabled" value="true"/>


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


            <a class="navbar-brand" href="<c:url value='/add-document-${user.id}' />"><i
                    class="glyphicon glyphicon-hdd"></i> Your Disc
                <c:set var="string" value="${currentFolder.description}"/>
                <span style="margin-left: 125px" class="glyphicon glyphicon-th-list"></span>
                Directory: ${fn:replace(string, '.', '/')}
            </a>
        </div>
        <!-- Top Menu Items -->
        <ul class="nav navbar-right top-nav">


            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i
                        class="fa fa-user"></i> ${user.firstName} ${user.lastName} <b
                        class="caret"></b></a>
                <ul class="dropdown-menu">
                    <%--<li>--%>
                    <%--<a href="#"><i class="fa fa-fw fa-user" style="color: red;"></i> Profile</a>--%>
                    <%--</li>--%>

                    <li>
                        <a href="<c:url value='/edit-user-${user.ssoId}' />"><i class="fa fa-fw fa-gear"></i>
                            Profile</a>
                    </li>
                    <sec:authorize access="hasRole('ADMIN') or hasRole('DBA')">
                        <li>
                            <a href="<c:url value='/list' />">
                                User List</a>
                        </li>
                    </sec:authorize>
                    <li class="divider"></li>
                    <li>
                        <a href="<c:url value="/logout" />"><i class="fa fa-fw fa-power-off"></i> Log Out</a>
                    </li>
                </ul>
            </li>
        </ul>
        <!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
        <div class="collapse navbar-collapse navbar-ex1-collapse">
            <ul class="nav navbar-nav side-nav">
                <li>

                    <form class="form-group input-group search" action="/search-${user.id}-${currentFolder.id}">
                        <input type="text" placeholder="Search files" class="form-control" name="target">
                        <span class="input-group-btn"><button
                                class="btn btn-default" type="submit"><i
                                class="fa fa-search"></i></button></span>
                    </form>
                </li>
                <li>
                    <a href="<c:url value='/add-document-${user.id}' />"><i class="fa fa-home fa-3"></i> ROOT Folder</a>
                </li>
                <li>
                    <a href="#" type="button" data-toggle="modal" data-target="#upload"> <span
                            class="glyphicon glyphicon-upload"></span> Upload a file</a>
                </li>
                <li>
                    <a href="#" type="button" data-toggle="modal" data-target="#new_folder"><span
                            class="glyphicon glyphicon-folder-close"></span> Create new Folder </a>
                    <c:if test="${fn:length(folderNameError) gt 0}">
                        <a href="#" type="button" style="color: red"><span
                                class="glyphicon glyphicon-warning-sign"></span> ${folderNameError} </a>
                    </c:if>
                    <c:if test="${fn:length(folderUniqueError) gt 0}">
                        <a href="#" type="button" style="color: red"><span
                                class="glyphicon glyphicon-warning-sign"></span> ${folderUniqueError} </a>
                    </c:if>
                </li>
                <%----%>
                <%----%>
                <li>
                    <a href="javascript:;" data-toggle="collapse" data-target="#demo"><span
                            class="glyphicon glyphicon-check"></span> Filters <i
                            class="fa fa-fw fa-caret-down"></i></a>
                    <div id="demo" class="collapse container">
                        <form action="/filter-${user.id}-${currentFolder.id}">
                            <div class="form-group">
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="filters" value="documents">Documents
                                    </label>
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="filters" value="pictures">Pictures
                                    </label>
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="filters" value="videos">Videos
                                    </label>
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="filters" value="zip">Zip-archives
                                    </label>
                                </div>
                            </div>
                            <input type="submit" value="search">
                        </form>
                        <%----%>
                    </div>
                    <%----%>
                </li>
                <li>
                    <a href="javascript:;" data-toggle="collapse" data-target="#demo1"><span
                            class="glyphicon glyphicon-check"></span> TOP files by size in Kb <i
                            class="fa fa-fw fa-caret-down"></i></a>
                    <div id="demo1" class="collapse in container row">
                        <div id="morris-donut-chart" style="height: 220px;width: 220px;"></div>

                    </div>
                </li>

            </ul>
        </div>
        <!-- /.navbar-collapse -->
    </nav>


    <div id="page-wrapper">

        <div class="container-fluid">
            <div class="divider"></div>
            <%--<div class="alert alert-info"--%>
            <%--aria-expanded="false" >--%>
            <%--<c:set var="string" value="${currentFolder.description}"/>--%>
            <%--<span class="glyphicon glyphicon-th-list"></span> Directory: ${fn:replace(string, '.', '/')}--%>
            <%--</div>--%>

            <c:if test="${fn:length(folders) gt 0}">
            <div class="alert alert-success cursor" data-toggle="collapse" data-target="#folders-collapse"
                 aria-expanded="false" aria-controls="collapseExample">
                <strong><span class="glyphicon glyphicon-plus"></span> Folders </strong>
            </div>
            <div class="row collapse in" id="folders-collapse">
                </c:if>

                <!-- Page Heading -->

                <c:forEach items="${folders}" var="doc" varStatus="counter">

                    <div class="col-lg-2 col-md-3">
                        <div class="panel panel-primary">
                            <div class="panel-heading cursor"
                                 onmouseenter="this.setAttribute('style','background-color:#163b5a;')"
                                 onmouseleave="this.setAttribute('style','background-color:#337ab7;')"
                                 onclick="location.href = '<c:url value='/open-folder-${user.id}-${doc.id}'/>';">
                                <div class="row">
                                    <div class="col-xs-2">
                                        <i class="fa fa-folder fa-3x"></i>

                                    </div>
                                    <div class="col-xs-10 text-right">
                                        <div>${doc.name}</div>
                                    </div>
                                    <div class="col-xs-10 text-right">
                                        <div class="info-text">${doc.filesCounter} files</div>
                                        <div class="info-text">${doc.size} Kb</div>
                                    </div>
                                </div>
                            </div>
                            <a href="#">
                                <div class="panel-footer">
                                        <%--<a href="<c:url value='/open-folder-${user.id}-${doc.id}' />"--%>
                                        <%--class="btn btn-default btn-sm ">Open <span--%>
                                        <%--class="glyphicon glyphicon-folder-open"></span></a>--%>
                                    <div class="row">

                                        <a href="<c:url value='/delete-folder-${user.id}-${doc.id}' />"
                                           class="btn btn-default btn-sm pull-right"
                                           style="margin-right: 10px">Delete <span
                                                class="glyphicon glyphicon-trash"></span>
                                        </a>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <!-- /.row -->

            <c:choose>
            <c:when test="${fn:length(documents) gt 0}">
            <div class="alert alert-success cursor" data-toggle="collapse" data-target="#files-collapse"
                 aria-expanded="false"
                 aria-controls="collapseExample">
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
                <c:forEach items="${documents}" var="doc" varStatus="counter">

                    <div class="col-lg-3 col-md-6">

                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <c:set var="type" value="${doc.type}"/>
                                <c:forEach items="${types}" var="target" varStatus="counter">
                                    <c:choose>
                                        <c:when test="${fn:contains(type, target)}">
                                            <div class="row">
                                                <div class="collapse" id="collapseExample${doc.id}">
                                                    <div class="well">
                                                        <div class="embed-responsive embed-responsive-16by9">

                                                                <%--<iframe class="embed-responsive-item cursor _pl${doc.id}"--%>
                                                                <%--&lt;%&ndash;datatype="<c:url value='/preview-document-${user.id}-${doc.id}' />"&ndash;%&gt;--%>
                                                                <%--&lt;%&ndash;src="about:blank"></iframe>&ndash;%&gt;--%>
                                                                <%--src="<c:url value='/preview-document-${user.id}-${doc.id}'/>"></iframe>--%>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <c:set var="disabled" value="false"/>
                                        </c:when>
                                    </c:choose>
                                    <%--<c:if test="${fn:contains(type, target)}">--%>
                                    <%----%>
                                    <%--</c:if>--%>
                                </c:forEach>
                                <div class="row">
                                    <div class="col-xs-3">
                                        <i title="Click to preview in new window"
                                           class="fa fa-file${doc.glyphicon}o fa-5x cursor"
                                           onmouseenter="this.setAttribute('style','color:#337ab7;')"
                                           onmouseleave="this.setAttribute('style','color:#333;')"
                                           onclick="window.open('<c:url
                                                   value='/preview-document-${user.id}-${doc.id}'/>','_blank')"></i>
                                    </div>
                                    <div class="col-xs-9 text-right">
                                        <div>${doc.name}</div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-offset-1 col-sm-offset-1 col-md-offset-1 col-xs-offset-1 text-center">
                                            ${doc.type} | ${doc.size} Kb
                                    </div>
                                </div>

                            </div>
                            <a href="#">
                                <div class="panel-footer  text-center">
                                    <div class=" text-center">
                                        <a target="_blank"
                                           href="<c:url value='/download-document-${user.id}-${doc.id}' />"
                                           class="btn btn-default btn-sm"> <span
                                                class="fa fa-download"></span> Download</a>
                                        <c:if test="${disabled eq false}">
                                            <%--<a class="btn btn-default btn-sm" id="${doc.id}" role="button"--%>
                                            <%--data-toggle="collapse"--%>
                                            <%--href="#collapseExample${doc.id}" aria-expanded="false"--%>
                                            <%--&lt;%&ndash;onclick="testFunc('<c:url value='/preview-document-${user.id}-${doc.id}' />', '_pl${doc.id}' )"&ndash;%&gt;--%>
                                            <%--aria-controls="collapseExample">--%>
                                            <%--Preview--%>
                                            <%--</a>--%>
                                            <a href="<c:url value='/preview-document-${user.id}-${doc.id}' />"
                                               target="_blank" class="btn btn-default btn-sm">Preview </span> </a>
                                        </c:if>
                                        <a href="<c:url value='/delete-document-${user.id}-${doc.id}-${currentFolder.id}' />"
                                           class="btn btn-default btn-sm">Delete <span
                                                class="glyphicon glyphicon-trash"></span> </a>
                                    </div>

                                </div>
                            </a>
                        </div>
                    </div>
                    <c:set var="disabled" value="true"/>
                </c:forEach>


            </div>
            <!-- /.container-fluid -->

        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->


</div>

<!-- Modal -->
<div class="modal fade" id="upload" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header text-center">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="text-center"><span class="glyphicon glyphicon-upload"></span> Upload a document</h4>
            </div>
            <div class="modal-body">
                <form:form role="form" method="POST" modelAttribute="fileBucket"
                           enctype="multipart/form-data"
                           action="/add-document-${user.id}-${currentFolder.id}"
                           class="form-vertical">
                    <div class="form-group text-center">


                        <label class="btn btn-default " for="my-file-selector">
                            <form:input type="file" path="file" id="my-file-selector" style="display:none;"
                                        class="form-control input-sm"
                                        onchange="$('#upload-file-info').html($(this).val().substring(12));"/>
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
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header text-center">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="text-center"><span class="glyphicon glyphicon-folder-close"></span> Create new Folder
                </h4>
            </div>
            <div class="modal-body">
                <form:form role="form" method="POST" modelAttribute="folderBucket"
                           action="/create-folder-${user.id}-${currentFolder.id}">
                    <div class="form-group text-center">

                        <form:input class="form-control input-sm" type="text"
                                    placeholder="Folder name"
                                    name="folderName" path="folderName"/>
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


<!-- jQuery -->
<script src="/static/js/jquery.js"></script>


<!-- Bootstrap Core JavaScript -->
<script src="/static/js/bootstrap.min.js"></script>
<script src="/static/js/bootstrap-filestyle.min.js"></script>
<script src="/static/js/app.js"></script>


<!-- Morris Charts JavaScript -->
<%--<script src="http://explorercanvas.googlecode.com/svn/trunk/excanvas.js"></script>--%>

<script src="/static/js/plugins/morris/raphael.min.js"></script>
<script src="/static/js/plugins/morris/morris.js"></script>
<script src="/static/js/plugins/morris/morris-data.js"></script>
<script>
    //    function testFunc(link, plId) {
    //        var el = $("." + plId);
    //        var attr = el.attr('src');
    //        if(attr === "about:blank"){
    //            el.attr('src', link);
    //        }
    //        else{
    //            el.attr('src', "about:blank");
    //        }
    //    };

    (function () {

        Morris.Donut({
            element: 'morris-donut-chart',
            data: [
                <c:forEach items="${documents}" var="doc" varStatus="counter">
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
    ;
</script>
</body>

</html>
