<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Bookings" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${not empty param.error}">
    <div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900"><c:out value="${param.error}"/></div>
</c:if>
<c:if test="${not empty param.ok}">
    <div class="mb-6 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900"><c:out value="${param.ok}"/></div>
</c:if>

<div class="mb-8">
    <h1 class="font-display text-2xl font-semibold text-stone-900 sm:text-3xl">Bookings</h1>
    <p class="mt-1 text-sm text-stone-500">Create requests and track status for your event dates.</p>
</div>

<div class="grid gap-8 lg:grid-cols-12">
    <div class="lg:col-span-5">
        <div class="rounded-2xl border border-stone-200/90 bg-white p-6 shadow-soft lg:h-full">
            <h2 class="font-display text-lg font-semibold text-stone-900">${empty editBooking ? 'New booking' : 'Edit booking'}</h2>
            <c:choose>
                <c:when test="${empty vendors}">
                    <p class="mt-4 text-sm text-stone-500">No vendors available yet. Ask an administrator to add vendors first.</p>
                </c:when>
                <c:otherwise>
                    <c:if test="${not empty editBooking}">
                        <form method="post" action="${ctx}/bookings" class="mt-6 space-y-4">
                            <input type="hidden" name="action" value="update"/>
                            <input type="hidden" name="bookingId" value="${editBooking.id}"/>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Vendor</label>
                                <select class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="vendorId" required>
                                    <c:forEach var="ven" items="${vendors}">
                                        <option value="${ven.id}" ${ven.id == editBooking.vendorId ? 'selected' : ''}><c:out value="${ven.businessName}"/> (${ven.typeDisplayName})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Event date</label>
                                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="date" name="eventDate" required value="${editBooking.eventDate}"/>
                            </div>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Status</label>
                                <select class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="status">
                                    <c:forEach var="st" items="${statuses}">
                                        <option value="${st.name()}" ${st == editBooking.status ? 'selected' : ''}><c:out value="${st.name()}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Notes</label>
                                <textarea class="block w-full rounded-xl border border-stone-300 px-3 py-2 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="notes" rows="3"><c:out value="${editBooking.notes}"/></textarea>
                            </div>
                            <div class="flex flex-wrap gap-2">
                                <button type="submit" class="inline-flex rounded-xl bg-rose-600 px-4 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-rose-700">Save changes</button>
                                <a href="${ctx}/bookings" class="inline-flex rounded-xl border border-stone-300 bg-white px-4 py-2.5 text-sm font-semibold text-stone-700 hover:bg-stone-50">Cancel</a>
                            </div>
                        </form>
                    </c:if>
                    <c:if test="${empty editBooking}">
                        <form method="post" action="${ctx}/bookings" class="mt-6 space-y-4">
                            <input type="hidden" name="action" value="create"/>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Vendor</label>
                                <select class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="vendorId" required>
                                    <c:forEach var="ven" items="${vendors}">
                                        <option value="${ven.id}"><c:out value="${ven.businessName}"/> (${ven.typeDisplayName})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Event date</label>
                                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="date" name="eventDate" required/>
                            </div>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Notes</label>
                                <textarea class="block w-full rounded-xl border border-stone-300 px-3 py-2 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="notes" rows="3" placeholder="Ceremony time, venue, special requests…"></textarea>
                            </div>
                            <button type="submit" class="flex w-full items-center justify-center rounded-xl bg-gradient-to-r from-rose-600 to-rose-700 px-4 py-3 text-sm font-semibold text-white shadow-md shadow-rose-600/25 hover:from-rose-700 hover:to-rose-800">Submit booking</button>
                        </form>
                    </c:if>
                    <p class="mt-4 text-xs text-stone-500">The same vendor cannot be booked twice on the same date unless a prior booking is cancelled.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="lg:col-span-7">
        <div class="overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft">
            <div class="border-b border-stone-100 px-5 py-4">
                <h2 class="font-display text-lg font-semibold text-stone-900">Booking history</h2>
            </div>
            <div class="table-wrap overflow-x-auto">
                <table class="min-w-full divide-y divide-stone-200 text-sm">
                    <thead class="bg-stone-50/80 text-left text-xs font-semibold uppercase tracking-wider text-stone-500">
                        <tr>
                            <th class="px-5 py-3">Date</th>
                            <th class="px-5 py-3">Vendor</th>
                            <th class="px-5 py-3">Status</th>
                            <th class="px-5 py-3 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-stone-100">
                        <c:forEach var="b" items="${bookings}">
                            <c:set var="ven" value="${vendorMap[b.vendorId]}"/>
                            <tr class="hover:bg-stone-50/50">
                                <td class="whitespace-nowrap px-5 py-3 text-stone-700"><c:out value="${b.eventDate}"/></td>
                                <td class="px-5 py-3 text-stone-800"><c:out value="${empty ven ? 'Unknown vendor' : ven.businessName}"/></td>
                                <td class="px-5 py-3"><span class="inline-flex rounded-full bg-stone-100 px-2.5 py-0.5 text-xs font-medium text-stone-700"><c:out value="${b.status}"/></span></td>
                                <td class="px-5 py-3 text-right">
                                    <div class="flex flex-wrap items-center justify-end gap-2">
                                        <a href="${ctx}/bookings?edit=${b.id}" class="inline-flex rounded-lg border border-rose-200 bg-rose-50 px-2.5 py-1 text-xs font-semibold text-rose-800 hover:bg-rose-100">Edit</a>
                                        <form method="post" action="${ctx}/bookings" class="inline" onsubmit="return confirm('Cancel this booking?');">
                                            <input type="hidden" name="action" value="cancel"/>
                                            <input type="hidden" name="bookingId" value="${b.id}"/>
                                            <button type="submit" class="inline-flex rounded-lg border border-amber-200 bg-amber-50 px-2.5 py-1 text-xs font-semibold text-amber-900 hover:bg-amber-100">Cancel</button>
                                        </form>
                                        <c:if test="${sessionScope.currentUser.admin}">
                                            <form method="post" action="${ctx}/bookings" class="inline" onsubmit="return confirm('Permanently delete this record?');">
                                                <input type="hidden" name="action" value="delete"/>
                                                <input type="hidden" name="bookingId" value="${b.id}"/>
                                                <button type="submit" class="inline-flex rounded-lg border border-red-200 bg-red-50 px-2.5 py-1 text-xs font-semibold text-red-800 hover:bg-red-100">Delete</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <c:if test="${empty bookings}">
                <div class="px-5 py-10 text-center text-sm text-stone-500">No bookings yet.</div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
