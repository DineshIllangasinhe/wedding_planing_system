<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Profile" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<h1 class="h3 mb-4">Your profile</h1>

<c:if test="${not empty formError}">
    <div class="alert alert-danger"><c:out value="${formError}"/></div>
</c:if>
<c:if test="${param.saved == '1'}">
    <div class="alert alert-success">Profile updated.</div>
</c:if>

<div class="row g-4">
    <div class="col-md-6">
        <div class="card p-4">
            <h2 class="h5 mb-3">Account details</h2>
            <form method="post" action="${ctx}/profile">
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input class="form-control" value="<c:out value="${profileUser.username}"/>" disabled readonly/>
                    <div class="form-text">Username cannot be changed.</div>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="email">Email</label>
                    <input class="form-control" type="email" id="email" name="email" required value="<c:out value="${profileUser.email}"/>"/>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="fullName">Full name</label>
                    <input class="form-control" id="fullName" name="fullName" required value="<c:out value="${profileUser.fullName}"/>"/>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="phone">Phone</label>
                    <input class="form-control" id="phone" name="phone" required value="<c:out value="${profileUser.phone}"/>"/>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="newPassword">New password</label>
                    <input class="form-control" type="password" id="newPassword" name="newPassword" autocomplete="new-password" placeholder="Leave blank to keep current"/>
                </div>
                <button type="submit" class="btn btn-primary">Save changes</button>
            </form>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card p-4 border-danger-subtle">
            <h2 class="h5 mb-3 text-danger">Delete account</h2>
            <p class="text-muted small">This removes your user record. Bookings and payments may become orphaned in the demo dataset—use with care.</p>
            <form method="post" action="${ctx}/profile" onsubmit="return confirm('Delete your account permanently?');">
                <input type="hidden" name="action" value="delete"/>
                <button type="submit" class="btn btn-outline-danger">Delete my account</button>
            </form>
        </div>
        <div class="card p-4 mt-3">
            <p class="small text-muted mb-1">Role</p>
            <p class="mb-0"><strong><c:out value="${profileUser.role}"/></strong></p>
            <p class="small text-muted mt-2 mb-0">Member since <c:out value="${profileUser.createdAt}"/></p>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
