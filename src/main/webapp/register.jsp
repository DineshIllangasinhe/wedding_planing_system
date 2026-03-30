<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Register" scope="request"/>
<%@ include file="WEB-INF/jsp/includes/header.jspf" %>

<div class="mx-auto max-w-lg">
    <div class="mb-8 text-center">
        <h1 class="font-display text-2xl font-semibold text-stone-900 sm:text-3xl">Create your account</h1>
        <p class="mt-2 text-sm text-stone-500">Join to browse vendors, book dates, and track payments.</p>
    </div>

    <c:if test="${not empty formError}">
        <div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900"><c:out value="${formError}"/></div>
    </c:if>

    <div class="rounded-2xl border border-stone-200/90 bg-white p-6 shadow-card sm:p-8">
        <form method="post" action="${ctx}/register" class="space-y-5">
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="username">Username</label>
                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" id="username" name="username" required minlength="3" value="${username}" autocomplete="username"/>
            </div>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="password">Password</label>
                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="password" id="password" name="password" required minlength="6" autocomplete="new-password"/>
            </div>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="email">Email</label>
                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="email" id="email" name="email" required value="${email}"/>
            </div>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="fullName">Full name</label>
                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" id="fullName" name="fullName" required value="${fullName}"/>
            </div>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="phone">Phone</label>
                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" id="phone" name="phone" required value="${phone}"/>
            </div>
            <button type="submit" class="flex w-full items-center justify-center rounded-xl bg-gradient-to-r from-rose-600 to-rose-700 px-4 py-3 text-sm font-semibold text-white shadow-md shadow-rose-600/25 transition hover:from-rose-700 hover:to-rose-800">
                Create account
            </button>
        </form>
    </div>
    <p class="mt-6 text-center text-sm text-stone-600">
        Already registered? <a href="${ctx}/login" class="font-semibold text-rose-700 hover:underline">Sign in</a>
    </p>
</div>

<%@ include file="WEB-INF/jsp/includes/footer.jspf" %>
