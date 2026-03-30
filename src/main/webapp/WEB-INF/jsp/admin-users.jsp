<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Users" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${not empty flashSuccess}"><div class="mb-6 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900"><c:out value="${flashSuccess}"/></div></c:if>
<c:if test="${not empty flashError}"><div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900"><c:out value="${flashError}"/></div></c:if>

<div class="mb-8">
    <h1 class="font-display text-2xl font-semibold text-stone-900 sm:text-3xl">User directory</h1>
    <p class="mt-1 text-sm text-stone-500">All registered accounts. Deleting a user removes their row from the <code class="rounded bg-stone-100 px-1.5 py-0.5 text-xs">users</code> table.</p>
</div>

<div class="overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft">
    <div class="table-wrap overflow-x-auto">
        <table class="min-w-full divide-y divide-stone-200 text-sm">
            <thead class="bg-stone-50/80 text-left text-xs font-semibold uppercase tracking-wider text-stone-500">
                <tr>
                    <th class="px-5 py-3">ID</th>
                    <th class="px-5 py-3">Username</th>
                    <th class="px-5 py-3">Name</th>
                    <th class="px-5 py-3">Email</th>
                    <th class="px-5 py-3">Phone</th>
                    <th class="px-5 py-3">Role</th>
                    <th class="px-5 py-3">Joined</th>
                    <th class="px-5 py-3 text-right"></th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-100">
                <c:forEach var="u" items="${allUsers}">
                    <tr class="hover:bg-stone-50/50">
                        <td class="whitespace-nowrap px-5 py-3 text-stone-700"><c:out value="${u.id}"/></td>
                        <td class="px-5 py-3 font-medium text-stone-900"><c:out value="${u.username}"/></td>
                        <td class="px-5 py-3 text-stone-700"><c:out value="${u.fullName}"/></td>
                        <td class="px-5 py-3 text-stone-600"><c:out value="${u.email}"/></td>
                        <td class="px-5 py-3 text-stone-600"><c:out value="${u.phone}"/></td>
                        <td class="px-5 py-3">
                            <span class="inline-flex rounded-full px-2.5 py-0.5 text-xs font-semibold ${u.admin ? 'bg-stone-900 text-white' : 'bg-stone-200 text-stone-800'}"><c:out value="${u.role}"/></span>
                        </td>
                        <td class="whitespace-nowrap px-5 py-3 text-stone-600"><c:out value="${u.createdAt}"/></td>
                        <td class="px-5 py-3 text-right">
                            <c:if test="${u.id != sessionScope.currentUser.id}">
                                <form method="post" action="${ctx}/admin/users" class="inline" onsubmit="return confirm('Delete user ${u.username}?');">
                                    <input type="hidden" name="action" value="delete"/>
                                    <input type="hidden" name="userId" value="${u.id}"/>
                                    <button type="submit" class="inline-flex rounded-lg border border-red-200 bg-red-50 px-2.5 py-1 text-xs font-semibold text-red-800 hover:bg-red-100">Delete</button>
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
