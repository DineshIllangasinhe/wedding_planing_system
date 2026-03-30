<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Profile" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<div class="mb-8">
    <h1 class="font-display text-2xl font-semibold text-stone-900 sm:text-3xl">Your profile</h1>
    <p class="mt-1 text-sm text-stone-500">Update contact details and keep your account secure.</p>
</div>

<c:if test="${not empty formError}">
    <div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900"><c:out value="${formError}"/></div>
</c:if>
<c:if test="${param.saved == '1'}">
    <div class="mb-6 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900">Profile updated.</div>
</c:if>

<div class="grid gap-8 lg:grid-cols-2">
    <div class="rounded-2xl border border-stone-200/90 bg-white p-6 shadow-soft sm:p-8">
        <h2 class="font-display text-lg font-semibold text-stone-900">Account details</h2>
        <form method="post" action="${ctx}/profile" class="mt-6 space-y-4">
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700">Username</label>
                <input class="block w-full cursor-not-allowed rounded-xl border border-stone-200 bg-stone-50 px-3 py-2.5 text-sm text-stone-600" value="<c:out value="${profileUser.username}"/>" disabled readonly/>
                <p class="mt-1 text-xs text-stone-500">Username cannot be changed.</p>
            </div>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="email">Email</label>
                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="email" id="email" name="email" required value="<c:out value="${profileUser.email}"/>"/>
            </div>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="fullName">Full name</label>
                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" id="fullName" name="fullName" required value="<c:out value="${profileUser.fullName}"/>"/>
            </div>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="phone">Phone</label>
                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" id="phone" name="phone" required value="<c:out value="${profileUser.phone}"/>"/>
            </div>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-stone-700" for="newPassword">New password</label>
                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="password" id="newPassword" name="newPassword" autocomplete="new-password" placeholder="Leave blank to keep current"/>
            </div>
            <button type="submit" class="inline-flex rounded-xl bg-rose-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-rose-700">Save changes</button>
        </form>
    </div>
    <div class="space-y-6">
        <div class="rounded-2xl border border-red-200/80 bg-red-50/50 p-6 sm:p-8">
            <h2 class="font-display text-lg font-semibold text-red-900">Delete account</h2>
            <p class="mt-2 text-sm text-red-900/80">This removes your user record. Related bookings and payments may be affected—use with care.</p>
            <form method="post" action="${ctx}/profile" class="mt-5" onsubmit="return confirm('Delete your account permanently?');">
                <input type="hidden" name="action" value="delete"/>
                <button type="submit" class="inline-flex rounded-xl border border-red-300 bg-white px-4 py-2.5 text-sm font-semibold text-red-800 shadow-sm hover:bg-red-50">Delete my account</button>
            </form>
        </div>
        <div class="rounded-2xl border border-stone-200/90 bg-white p-6 shadow-soft">
            <p class="text-xs font-semibold uppercase tracking-wider text-stone-500">Role</p>
            <p class="mt-1 text-lg font-semibold text-stone-900"><c:out value="${profileUser.role}"/></p>
            <p class="mt-3 text-sm text-stone-500">Member since <c:out value="${profileUser.createdAt}"/></p>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
