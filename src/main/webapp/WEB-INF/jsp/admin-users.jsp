<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Users" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${not empty flashSuccess}"><div class="alert alert-success">${flashSuccess}</div></c:if>
<c:if test="${not empty flashError}"><div class="alert alert-danger">${flashError}</div></c:if>

<h1 class="h3 mb-4">User directory</h1>
<p class="text-muted small mb-4">View all registered accounts. Deleting a user removes their row from <code>users.txt</code>.</p>

<div class="card p-0 overflow-hidden">
    <div class="table-responsive">
        <table class="table table-hover mb-0 align-middle">
            <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Role</th>
                <th>Joined</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="u" items="${allUsers}">
                <tr>
                    <td><c:out value="${u.id}"/></td>
                    <td><c:out value="${u.username}"/></td>
                    <td><c:out value="${u.fullName}"/></td>
                    <td><c:out value="${u.email}"/></td>
                    <td><c:out value="${u.phone}"/></td>
                    <td><span class="badge ${u.admin ? 'text-bg-dark' : 'text-bg-secondary'}"><c:out value="${u.role}"/></span></td>
                    <td><c:out value="${u.createdAt}"/></td>
                    <td class="text-end">
                        <c:if test="${u.id != sessionScope.currentUser.id}">
                            <form method="post" action="${ctx}/admin/users" class="d-inline" onsubmit="return confirm('Delete user ${u.username}?');">
                                <input type="hidden" name="action" value="delete"/>
                                <input type="hidden" name="userId" value="${u.id}"/>
                                <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
