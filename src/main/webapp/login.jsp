<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Login" scope="request"/>
<%@ include file="WEB-INF/jsp/includes/header.jspf" %>

<div class="mx-auto max-w-md">
    <div class="mb-8 text-center">
        <h1 class="font-display text-2xl font-semibold text-stone-900 sm:text-3xl">Welcome back</h1>
        <p class="mt-2 text-sm text-stone-500">Sign in to manage bookings and payments.</p>
    </div>

    <c:if test="${param.error == 'credentials'}">
        <div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900">Invalid username or password.</div>
    </c:if>
    <c:if test="${param.error == 'missing'}">
        <div class="mb-6 rounded-2xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">Please enter both username and password.</div>
    </c:if>
    <c:if test="${param.error == 'server'}">
        <div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900">
            Sign-in is temporarily unavailable (database unreachable). Confirm MySQL is running, the <code class="rounded bg-red-100 px-1">wedding</code> schema exists,
            <code class="rounded bg-red-100 px-1">schema.sql</code> was applied, and <code class="rounded bg-red-100 px-1">database.properties</code> is correct. Check the server console for details.
        </div>
    </c:if>
    <c:if test="${param.registered == '1'}">
        <div class="mb-6 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900">Registration successful. You can sign in now.</div>
    </c:if>

    <div class="rounded-2xl border border-stone-200/90 bg-white p-6 shadow-card sm:p-8">
        <form method="post" action="${ctx}/login" class="space-y-5">
            <c:if test="${not empty param.next}">
                <input type="hidden" name="next" value="${param.next}"/>
            </c:if>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="username">Username</label>
                <input class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm text-stone-900 shadow-sm placeholder:text-stone-400 focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" id="username" name="username" required autocomplete="username"/>
            </div>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="password">Password</label>
                <input class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm text-stone-900 shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="password" id="password" name="password" required autocomplete="current-password"/>
            </div>
            <button type="submit" class="flex w-full items-center justify-center rounded-xl bg-gradient-to-r from-rose-600 to-rose-700 px-4 py-3 text-sm font-semibold text-white shadow-md shadow-rose-600/25 transition hover:from-rose-700 hover:to-rose-800">
                Sign in
            </button>
        </form>
    </div>

    <p class="mt-6 text-center text-xs text-stone-500">
        Demo: <strong class="text-stone-700">admin</strong> / <strong class="text-stone-700">admin123</strong> &middot;
        <strong class="text-stone-700">couple1</strong> / <strong class="text-stone-700">wedding2026</strong>
    </p>
    <p class="mt-3 text-center text-sm">
        <a href="${ctx}/register" class="font-medium text-rose-700 hover:text-rose-800 hover:underline">Create an account</a>
    </p>
</div>

<%@ include file="WEB-INF/jsp/includes/footer.jspf" %>
