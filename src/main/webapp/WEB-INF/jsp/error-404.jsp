<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Not found" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>
<div class="mx-auto max-w-lg py-16 text-center">
    <p class="font-display text-2xl font-semibold text-stone-400">404</p>
    <h1 class="mt-4 font-display text-2xl font-semibold text-stone-900 sm:text-3xl">Page not found</h1>
    <p class="mt-3 text-stone-600">That page does not exist or was moved.</p>
    <a href="${pageContext.request.contextPath}/index.jsp" class="mt-8 inline-flex rounded-xl bg-rose-600 px-6 py-3 text-sm font-semibold text-white shadow-md hover:bg-rose-700">Back home</a>
</div>
<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
