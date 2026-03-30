<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="Dashboard" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<div class="mb-8">
    <h1 class="font-display text-2xl font-semibold text-stone-900 sm:text-3xl">Dashboard</h1>
    <p class="mt-1 text-sm text-stone-500">Overview of your wedding planning activity.</p>
</div>

<div class="mb-8 grid gap-4 sm:grid-cols-3">
    <div class="rounded-2xl border border-stone-200/90 bg-white p-5 shadow-soft">
        <p class="text-xs font-semibold uppercase tracking-wider text-stone-500">Paid (total)</p>
        <p class="mt-2 font-display text-2xl font-semibold text-stone-900">$<c:out value="${totalPaid}"/></p>
    </div>
    <div class="rounded-2xl border border-stone-200/90 bg-white p-5 shadow-soft">
        <p class="text-xs font-semibold uppercase tracking-wider text-stone-500">Bookings</p>
        <p class="mt-2 font-display text-2xl font-semibold text-stone-900">${fn:length(bookingHistory)}</p>
    </div>
    <div class="rounded-2xl border border-stone-200/90 bg-white p-5 shadow-soft">
        <p class="text-xs font-semibold uppercase tracking-wider text-stone-500">Payment records</p>
        <p class="mt-2 font-display text-2xl font-semibold text-stone-900">${fn:length(payments)}</p>
    </div>
</div>

<div class="grid gap-6 lg:grid-cols-2">
    <div class="overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft">
        <div class="flex items-center justify-between border-b border-stone-100 px-5 py-4">
            <h2 class="font-display text-lg font-semibold text-stone-900">Upcoming focus</h2>
            <a href="${ctx}/bookings" class="text-sm font-medium text-rose-700 hover:underline">Manage</a>
        </div>
        <ul class="divide-y divide-stone-100">
            <c:forEach var="b" items="${upcoming}">
                <c:set var="ven" value="${vendorMap[b.vendorId]}"/>
                <li class="flex items-center justify-between gap-4 px-5 py-4">
                    <div>
                        <p class="font-medium text-stone-900"><c:out value="${empty ven ? 'Unknown vendor' : ven.businessName}"/></p>
                        <p class="text-sm text-stone-500"><c:out value="${b.eventDate}"/> · <c:out value="${b.status}"/></p>
                    </div>
                </li>
            </c:forEach>
            <c:if test="${empty upcoming}">
                <li class="px-5 py-8 text-center text-sm text-stone-500">No active upcoming bookings.</li>
            </c:if>
        </ul>
    </div>
    <div class="overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft">
        <div class="flex items-center justify-between border-b border-stone-100 px-5 py-4">
            <h2 class="font-display text-lg font-semibold text-stone-900">Booking history</h2>
            <a href="${ctx}/bookings" class="text-sm font-medium text-rose-700 hover:underline">Full list</a>
        </div>
        <div class="table-wrap overflow-x-auto">
            <table class="min-w-full divide-y divide-stone-200 text-sm">
                <thead class="bg-stone-50/80 text-left text-xs font-semibold uppercase tracking-wider text-stone-500">
                    <tr><th class="px-5 py-3">Date</th><th class="px-5 py-3">Vendor</th><th class="px-5 py-3">Status</th></tr>
                </thead>
                <tbody class="divide-y divide-stone-100">
                    <c:forEach var="b" items="${bookingHistory}" end="7">
                        <c:set var="ven" value="${vendorMap[b.vendorId]}"/>
                        <tr>
                            <td class="whitespace-nowrap px-5 py-3 text-stone-700"><c:out value="${b.eventDate}"/></td>
                            <td class="px-5 py-3 text-stone-700"><c:out value="${empty ven ? 'Unknown vendor' : ven.businessName}"/></td>
                            <td class="px-5 py-3"><span class="inline-flex rounded-full bg-stone-100 px-2.5 py-0.5 text-xs font-medium text-stone-700"><c:out value="${b.status}"/></span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="mt-6 overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft">
    <div class="flex items-center justify-between border-b border-stone-100 px-5 py-4">
        <h2 class="font-display text-lg font-semibold text-stone-900">Recent payments</h2>
        <a href="${ctx}/payments" class="text-sm font-medium text-rose-700 hover:underline">Payments</a>
    </div>
    <div class="table-wrap overflow-x-auto">
        <table class="min-w-full divide-y divide-stone-200 text-sm">
            <thead class="bg-stone-50/80 text-left text-xs font-semibold uppercase tracking-wider text-stone-500">
                <tr><th class="px-5 py-3">Package</th><th class="px-5 py-3">Amount</th><th class="px-5 py-3">Status</th><th class="px-5 py-3">Date</th></tr>
            </thead>
            <tbody class="divide-y divide-stone-100">
                <c:forEach var="p" items="${payments}" end="9">
                    <tr>
                        <td class="px-5 py-3 font-medium text-stone-900"><c:out value="${p.packageType}"/></td>
                        <td class="px-5 py-3 text-stone-700">$<c:out value="${p.amount}"/></td>
                        <td class="px-5 py-3"><span class="inline-flex rounded-full bg-stone-100 px-2.5 py-0.5 text-xs font-medium text-stone-700"><c:out value="${p.status}"/></span></td>
                        <td class="whitespace-nowrap px-5 py-3 text-stone-600"><c:out value="${p.createdAt}"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
