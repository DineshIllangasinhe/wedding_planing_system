<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Server error" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>
<div class="row justify-content-center">
    <div class="col-md-6 text-center py-5">
        <h1 class="display-6">500</h1>
        <p class="lead text-muted">Something went wrong on the server. Please try again later.</p>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/index.jsp">Back home</a>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
