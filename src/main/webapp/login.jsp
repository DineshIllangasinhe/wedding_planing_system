<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Login" scope="request"/>
<%@ include file="WEB-INF/jsp/includes/header.jspf" %>

<div class="row justify-content-center">
    <div class="col-md-5 col-lg-4">
        <h1 class="h3 mb-4">Sign in</h1>
        <c:if test="${param.error == 'credentials'}">
            <div class="alert alert-danger">Invalid username or password.</div>
        </c:if>
        <c:if test="${param.error == 'missing'}">
            <div class="alert alert-warning">Please enter both username and password.</div>
        </c:if>
        <c:if test="${param.registered == '1'}">
            <div class="alert alert-success">Registration successful. You can sign in now.</div>
        </c:if>
        <form method="post" action="${ctx}/login" class="card p-4 shadow-sm border-0">
            <c:if test="${not empty param.next}">
                <input type="hidden" name="next" value="${param.next}"/>
            </c:if>
            <div class="mb-3">
                <label class="form-label" for="username">Username</label>
                <input class="form-control" id="username" name="username" required autocomplete="username"/>
            </div>
            <div class="mb-3">
                <label class="form-label" for="password">Password</label>
                <input class="form-control" type="password" id="password" name="password" required autocomplete="current-password"/>
            </div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>
        <p class="text-center text-muted small mt-3">Demo: <strong>admin</strong> / <strong>admin123</strong> or <strong>couple1</strong> / <strong>wedding2026</strong></p>
        <p class="text-center"><a href="${ctx}/register">Create an account</a></p>
    </div>
</div>

<%@ include file="WEB-INF/jsp/includes/footer.jspf" %>
