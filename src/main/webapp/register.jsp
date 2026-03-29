<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Register" scope="request"/>
<%@ include file="WEB-INF/jsp/includes/header.jspf" %>

<div class="row justify-content-center">
    <div class="col-md-6 col-lg-5">
        <h1 class="h3 mb-4">Create your account</h1>
        <c:if test="${not empty formError}">
            <div class="alert alert-danger"><c:out value="${formError}"/></div>
        </c:if>
        <form method="post" action="${ctx}/register" class="card p-4 shadow-sm border-0">
            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label" for="username">Username</label>
                    <input class="form-control" id="username" name="username" required minlength="3"
                           value="${username}" autocomplete="username"/>
                </div>
                <div class="col-12">
                    <label class="form-label" for="password">Password</label>
                    <input class="form-control" type="password" id="password" name="password" required minlength="6" autocomplete="new-password"/>
                </div>
                <div class="col-12">
                    <label class="form-label" for="email">Email</label>
                    <input class="form-control" type="email" id="email" name="email" required value="${email}"/>
                </div>
                <div class="col-12">
                    <label class="form-label" for="fullName">Full name</label>
                    <input class="form-control" id="fullName" name="fullName" required value="${fullName}"/>
                </div>
                <div class="col-12">
                    <label class="form-label" for="phone">Phone</label>
                    <input class="form-control" id="phone" name="phone" required value="${phone}"/>
                </div>
            </div>
            <button type="submit" class="btn btn-primary w-100 mt-4">Register</button>
        </form>
        <p class="text-center mt-3"><a href="${ctx}/login">Already have an account?</a></p>
    </div>
</div>

<%@ include file="WEB-INF/jsp/includes/footer.jspf" %>
