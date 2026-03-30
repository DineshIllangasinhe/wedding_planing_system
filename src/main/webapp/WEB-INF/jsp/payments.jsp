<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Payments" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${not empty param.error}">
    <div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900"><c:out value="${param.error}"/></div>
</c:if>
<c:if test="${not empty param.ok}">
    <div class="mb-6 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900"><c:out value="${param.ok}"/></div>
</c:if>

<div class="mb-8">
    <h1 class="font-display text-2xl font-semibold text-stone-900 sm:text-3xl">Payments &amp; packages</h1>
    <p class="mt-2 max-w-2xl text-sm text-stone-600">
        Packages: <strong>Basic</strong>, <strong>Standard</strong>, and <strong>Premium</strong> with suggested pricing—amounts can be adjusted per booking.
    </p>
</div>

<div class="grid gap-8 lg:grid-cols-12">
    <div class="lg:col-span-5">
        <div class="rounded-2xl border border-stone-200/90 bg-white p-6 shadow-soft lg:h-full">
            <h2 class="font-display text-lg font-semibold text-stone-900">${empty editPayment ? 'Record payment' : 'Edit payment'}</h2>
            <c:choose>
                <c:when test="${empty bookingChoices}">
                    <p class="mt-4 text-sm text-stone-500">Create a booking first, then attach a payment.</p>
                </c:when>
                <c:otherwise>
                    <c:if test="${not empty editPayment}">
                        <form method="post" action="${ctx}/payments" class="mt-6 space-y-4">
                            <input type="hidden" name="action" value="update"/>
                            <input type="hidden" name="paymentId" value="${editPayment.id}"/>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Package</label>
                                <select class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="packageType">
                                    <c:forEach var="pk" items="${packageTypes}">
                                        <option value="${pk.name()}" ${pk == editPayment.packageType ? 'selected' : ''}><c:out value="${pk.name()}"/> (suggested $<c:out value="${pk.suggestedPrice}"/>)</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Amount (USD)</label>
                                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="number" step="0.01" min="0.01" name="amount" required value="${editPayment.amount}"/>
                            </div>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Status</label>
                                <select class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="status" ${sessionScope.currentUser.admin ? '' : 'disabled'}>
                                    <c:forEach var="st" items="${paymentStatuses}">
                                        <option value="${st.name()}" ${st == editPayment.status ? 'selected' : ''}><c:out value="${st.name()}"/></option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not sessionScope.currentUser.admin}">
                                    <input type="hidden" name="status" value="${editPayment.status.name()}"/>
                                    <p class="mt-1 text-xs text-stone-500">Only an administrator can change payment status.</p>
                                </c:if>
                            </div>
                            <div class="flex flex-wrap gap-2">
                                <button type="submit" class="inline-flex rounded-xl bg-rose-600 px-4 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-rose-700">Save</button>
                                <a href="${ctx}/payments" class="inline-flex rounded-xl border border-stone-300 bg-white px-4 py-2.5 text-sm font-semibold text-stone-700 hover:bg-stone-50">Cancel</a>
                            </div>
                        </form>
                    </c:if>
                    <c:if test="${empty editPayment}">
                        <form method="post" action="${ctx}/payments" class="mt-6 space-y-4">
                            <input type="hidden" name="action" value="create"/>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Booking</label>
                                <select class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="bookingId" required>
                                    <c:forEach var="bk" items="${bookingChoices}">
                                        <option value="${bk.id}">#<c:out value="${bk.id}"/> · <c:out value="${bk.eventDate}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Package</label>
                                <select class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="packageType" id="pkgSelect">
                                    <c:forEach var="pk" items="${packageTypes}">
                                        <option value="${pk.name()}" data-suggest="${pk.suggestedPrice}"><c:out value="${pk.name()}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="mb-1.5 block text-sm font-medium text-stone-700">Amount (USD)</label>
                                <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="number" step="0.01" min="0.01" name="amount" id="amt" required/>
                            </div>
                            <button type="submit" class="flex w-full items-center justify-center rounded-xl bg-gradient-to-r from-rose-600 to-rose-700 px-4 py-3 text-sm font-semibold text-white shadow-md shadow-rose-600/25 hover:from-rose-700 hover:to-rose-800">Create payment</button>
                        </form>
                        <script>
                            (function () {
                                var sel = document.getElementById('pkgSelect');
                                var amt = document.getElementById('amt');
                                function sync() {
                                    if (!sel || !amt) return;
                                    var opt = sel.options[sel.selectedIndex];
                                    amt.value = opt.getAttribute('data-suggest') || '';
                                }
                                if (sel) {
                                    sel.addEventListener('change', sync);
                                    sync();
                                }
                            })();
                        </script>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="lg:col-span-7">
        <div class="overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft">
            <div class="border-b border-stone-100 px-5 py-4">
                <h2 class="font-display text-lg font-semibold text-stone-900">Payment records</h2>
            </div>
            <div class="table-wrap overflow-x-auto">
                <table class="min-w-full divide-y divide-stone-200 text-sm">
                    <thead class="bg-stone-50/80 text-left text-xs font-semibold uppercase tracking-wider text-stone-500">
                        <tr>
                            <th class="px-5 py-3">ID</th>
                            <th class="px-5 py-3">Booking</th>
                            <th class="px-5 py-3">Package</th>
                            <th class="px-5 py-3">Amount</th>
                            <th class="px-5 py-3">Status</th>
                            <th class="px-5 py-3 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-stone-100">
                        <c:forEach var="p" items="${payments}">
                            <tr class="hover:bg-stone-50/50">
                                <td class="whitespace-nowrap px-5 py-3 text-stone-700"><c:out value="${p.id}"/></td>
                                <td class="px-5 py-3 text-stone-700"><c:out value="${p.bookingId}"/></td>
                                <td class="px-5 py-3 font-medium text-stone-900"><c:out value="${p.packageType}"/></td>
                                <td class="px-5 py-3 text-stone-700">$<c:out value="${p.amount}"/></td>
                                <td class="px-5 py-3"><span class="inline-flex rounded-full border border-stone-200 bg-stone-50 px-2.5 py-0.5 text-xs font-medium text-stone-700"><c:out value="${p.status}"/></span></td>
                                <td class="px-5 py-3 text-right">
                                    <a href="${ctx}/payments?edit=${p.id}" class="inline-flex rounded-lg border border-rose-200 bg-rose-50 px-2.5 py-1 text-xs font-semibold text-rose-800 hover:bg-rose-100">Edit</a>
                                    <c:if test="${sessionScope.currentUser.admin}">
                                        <form method="post" action="${ctx}/payments" class="ml-2 inline" onsubmit="return confirm('Delete this payment record?');">
                                            <input type="hidden" name="action" value="delete"/>
                                            <input type="hidden" name="paymentId" value="${p.id}"/>
                                            <button type="submit" class="inline-flex rounded-lg border border-red-200 bg-red-50 px-2.5 py-1 text-xs font-semibold text-red-800 hover:bg-red-100">Delete</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <c:if test="${empty payments}">
                <div class="px-5 py-10 text-center text-sm text-stone-500">No payments recorded.</div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
