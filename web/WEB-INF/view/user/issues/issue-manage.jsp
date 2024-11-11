<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Issue Management</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/select2.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <style>
            .content-wrapper {
                max-height: 50px;
                overflow: hidden;
                transition: max-height 0.4s ease-in-out;
                position: relative;
            }
            .content-wrapper.expanded {
                max-height: 1000px;
            }
            .read-more-btn {
                display: inline-block;
                color: #008ce6;
                cursor: pointer;
            }
            th {
                cursor: pointer;
                position: relative;
            }
            .sort-icon {
                margin-left: 5px;
                font-size: 12px;
                width: 10px;
                height: 20px;
            }
            .error-message {
                font-size: 0.875rem;
                margin-top: 0.25rem;
                color: #dc3545;
            }
            .is-invalid {
                border-color: #dc3545;
            }
            /* Status badges */
            .status-badge {
                padding: 0.25em 0.6em;
                border-radius: 0.25rem;
                font-size: 0.875em;
            }
            .status-open {
                background-color: #17a2b8;
                color: white;
            }
            .status-todo {
                background-color: #ffc107;
                color: black;
            }
            .status-doing {
                background-color: #0d6efd;
                color: white;
            }
            .status-done {
                background-color: #198754;
                color: white;
            }
            .status-closed {
                background-color: #6c757d;
                color: white;
            }
            /* Type badges */
            .type-badge {
                padding: 0.25em 0.6em;
                border-radius: 0.25rem;
                font-size: 0.875em;
            }
            .type-qa {
                background-color: #17a2b8;
                color: white;
            }
            .type-task {
                background-color: #28a745;
                color: white;
            }
            .type-issue {
                background-color: #ffc107;
                color: black;
            }
            .type-complaint {
                background-color: #dc3545;
                color: white;
            }
        </style>
    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">
                            <!-- Header Section -->
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5">
                                            <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                                <i class="fa fa-arrow-left"></i>
                                            </a> 
                                            Issues
                                        </h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Home</a></li>
                                            <li class="breadcrumb-item active">Issues</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Filters Section -->
                            <div class="row g-3 mb-3">
                                <div class="col-12">
                                    <div class="card">
                                        <div class="card-body">
                                            <form action="${pageContext.request.contextPath}/issue" method="post" id="filterForm">
                                            <input type="hidden" name="action" value="filter">
                                            <div class="row g-3">
                                                <div class="col-md-2">
                                                    <input type="text" class="form-control" name="searchKey" 
                                                           placeholder="Search..." value="${sessionScope.searchKey}">
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="mb-3">
                                                        <select class="form-select" name="projectFilter" id="projectFilter" required>
                                                            <option value="0">All Projects</option>
                                                            <c:forEach items="${projects}" var="project">
                                                                <option value="${project.id}" 
                                                                        ${project.id == sessionScope.projectFilter ? 'selected' : ''}>
                                                                    ${project.name}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select" name="typeFilter">
                                                        <option value="">All Types</option>
                                                        <option value="Q&A" ${sessionScope.typeFilter == 'Q&A' ? 'selected' : ''}>Q&A</option>
                                                        <option value="Task" ${sessionScope.typeFilter == 'Task' ? 'selected' : ''}>Task</option>
                                                        <option value="Issue" ${sessionScope.typeFilter == 'Issue' ? 'selected' : ''}>Issue</option>
                                                        <option value="Complaint" ${sessionScope.typeFilter == 'Complaint' ? 'selected' : ''}>Complaint</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select" name="statusFilter">
                                                        <option value="" ${empty sessionScope.statusFilter ? 'selected' : ''}>All Status</option>
                                                        <option value="0" ${sessionScope.statusFilter == 0 ? 'selected' : ''}>Open</option>
                                                        <option value="1" ${sessionScope.statusFilter == 1 ? 'selected' : ''}>To Do</option>
                                                        <option value="2" ${sessionScope.statusFilter == 2 ? 'selected' : ''}>Doing</option>
                                                        <option value="3" ${sessionScope.statusFilter == 3 ? 'selected' : ''}>Done</option>
                                                        <option value="4" ${sessionScope.statusFilter == 4 ? 'selected' : ''}>Closed</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-4">
                                                    <button type="submit" class="btn btn-primary">Filter</button>
                                                    <a href="issue?action=showAdd" class="btn btn-success float-end">Add New Issue</a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Issues Table -->
                        <div class="row g-3">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body">
                                        <!-- Alert Messages -->
                                        <c:if test="${not empty successMess}">
                                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                                ${successMess}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty AddErrorMess}">
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                ${AddErrorMess}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty UpdateErrorMess}">
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                ${UpdateErrorMess}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>

                                        <!-- Table -->
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th name="id" sortBy="desc" class="sortTableHead">ID <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="title" sortBy="desc" class="sortTableHead">Title <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="type" sortBy="desc" class="sortTableHead">Type <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="projectId" sortBy="desc" class="sortTableHead">Project <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="requirementId" sortBy="desc" class="sortTableHead">Requirement <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="requirementId" sortBy="desc" class="sortTableHead">Asignee<i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="due_date" sortBy="desc" class="sortTableHead">Due Date <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="end_date" sortBy="desc" class="sortTableHead">End Date <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="status" sortBy="desc" class="sortTableHead">Status <i class="fa fa-sort sort-icon"></i></th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${tableData}" var="issue">
                                                        <tr>
                                                            <td>${issue.id}</td>
                                                            <td>${issue.title}</td>
                                                            <td>
                                                                <span class="type-badge type-${fn:toLowerCase(issue.type)}">${issue.type}</span>
                                                            </td>
                                                            <td>
                                                                <c:forEach items="${projects}" var="project">
                                                                    <c:if test="${project.id == issue.projectId}">
                                                                        ${project.name}
                                                                    </c:if>
                                                                </c:forEach>
                                                            </td>
                                                            <td>
                                                                <c:forEach items="${requirements}" var="requirement">
                                                                    <c:if test="${requirement.id == issue.requirementId}">
                                                                        ${requirement.title}
                                                                    </c:if>
                                                                </c:forEach>
                                                            </td>
                                                            <td>
                                                                ${userService.getUserById(issue.assignee_id).fullname}
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate value="${issue.due_date}" pattern="dd/MM/yyyy"/>
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate value="${issue.end_date}" pattern="dd/MM/yyyy"/>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${issue.status == 0}">
                                                                        <span class="status-badge status-open">Open</span>
                                                                    </c:when>
                                                                    <c:when test="${issue.status == 1}">
                                                                        <span class="status-badge status-todo">To Do</span>
                                                                    </c:when>
                                                                    <c:when test="${issue.status == 2}">
                                                                        <span class="status-badge status-doing">Doing</span>
                                                                    </c:when>
                                                                    <c:when test="${issue.status == 3}">
                                                                        <span class="status-badge status-done">Done</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="status-badge status-closed">Closed</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <div class="btn-group" role="group">
                                                                    <a href="issue?action=showEdit&id=${issue.id}" class="btn btn-sm btn-primary">
                                                                        <i class="fa fa-edit"></i>
                                                                    </a>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                        <!-- Pagination -->
                                        <div class="row mt-3">
                                            <div class="col-12">
                                                <nav aria-label="Page navigation">
                                                    <ul class="pagination justify-content-center">
                                                        <%-- Previous button with text --%>
                                                        <li class="page-item">
                                                            <a class="page-link" href="issue?page=${page-1}">Previous</a>
                                                        </li>
                                        
                                                        <%-- Page numbers --%>
                                                        <c:forEach begin="1" end="${num}" var="i">
                                                            <li class="page-item ${i == page ? 'active' : ''}">
                                                                <a class="page-link" href="issue?page=${i}">${i}</a>
                                                            </li>
                                                        </c:forEach>
                                        
                                                        <%-- Next button with text --%>
                                                        <li class="page-item ">
                                                            <a class="page-link" href="issue?page=${page+1}">Next</a>
                                                        </li>
                                                    </ul>
                                                </nav>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

        <script>
            $(document).ready(function () {
                // Handle Read More buttons
                $('.read-more-btn').click(function () {
                    $(this).closest('.content-wrapper').toggleClass('expanded');
                    $(this).text(function (i, text) {
                        return text === "Read More" ? "Read Less" : "Read More";
                    });
                });

                // Handle Sorting
                $('.sortTableHead').click(function () {
                    const fieldName = $(this).attr('name');
                    const currentOrder = $(this).attr('sortBy');
                    const newOrder = currentOrder === 'asc' ? 'desc' : 'asc';

                    // Update UI
                    $('.sortTableHead').attr('sortBy', 'desc');
                    $('.sortTableHead i').removeClass('fa-sort-up fa-sort-down').addClass('fa-sort');

                    $(this).attr('sortBy', newOrder);
                    $(this).find('i')
                            .removeClass('fa-sort')
                            .addClass(newOrder === 'asc' ? 'fa-sort-up' : 'fa-sort-down');

                    // Submit sort form
                    const form = $('<form>')
                            .attr('method', 'post')
                            .attr('action', '${pageContext.request.contextPath}/issue');

                    form.append($('<input>')
                            .attr('type', 'hidden')
                            .attr('name', 'action')
                            .attr('value', 'sort'));

                    form.append($('<input>')
                            .attr('type', 'hidden')
                            .attr('name', 'fieldName')
                            .attr('value', fieldName));

                    form.append($('<input>')
                            .attr('type', 'hidden')
                            .attr('name', 'sortBy')
                            .attr('value', newOrder));

                    $('body').append(form);
                    form.submit();
                });
            });
        </script>
    </body>
</html>