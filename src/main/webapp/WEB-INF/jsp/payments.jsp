<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Payments" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${not empty param.error}">
    <div class="alert alert-danger"><c:out value="${param.error}"/></div>
</c:if>
<c:if test="${not empty param.ok}">
    <div class="alert alert-success"><c:out value="${param.ok}"/></div>
</c:if>

<h1 class="h3 mb-4">Payments &amp; packages</h1>
<p class="text-muted small mb-4">Packages: <strong>Basic</strong>, <strong>Standard</strong>, and <strong>Premium</strong> with suggested pricing—amounts can be adjusted per booking.</p>

<div class="row g-4">
    <div class="col-lg-5">
        <div class="card p-4">
            <h2 class="h5 mb-3">${empty editPayment ? 'Record payment' : 'Edit payment'}</h2>
            <c:choose>
                <c:when test="${empty bookingChoices}">
                    <p class="text-muted small">Create a booking first, then attach a payment.</p>
                </c:when>
                <c:otherwise>
                    <c:if test="${not empty editPayment}">
                        <form method="post" action="${ctx}/payments" class="mb-0">
                            <input type="hidden" name="action" value="update"/>
                            <input type="hidden" name="paymentId" value="${editPayment.id}"/>
                            <div class="mb-3">
                                <label class="form-label">Package</label>
                                <select class="form-select" name="packageType">
                                    <c:forEach var="pk" items="${packageTypes}">
                                        <option value="${pk.name()}" ${pk == editPayment.packageType ? 'selected' : ''}><c:out value="${pk.name()}"/> (suggested $<c:out value="${pk.suggestedPrice}"/>)</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Amount (USD)</label>
                                <input class="form-control" type="number" step="0.01" min="0.01" name="amount" required value="${editPayment.amount}"/>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Status</label>
                                <select class="form-select" name="status" ${sessionScope.currentUser.admin ? '' : 'disabled'}>
                                    <c:forEach var="st" items="${paymentStatuses}">
                                        <option value="${st.name()}" ${st == editPayment.status ? 'selected' : ''}><c:out value="${st.name()}"/></option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not sessionScope.currentUser.admin}">
                                    <input type="hidden" name="status" value="${editPayment.status.name()}"/>
                                    <div class="form-text">Only an administrator can change payment status.</div>
                                </c:if>
                            </div>
                            <button type="submit" class="btn btn-primary">Save</button>
                            <a class="btn btn-outline-secondary" href="${ctx}/payments">Cancel</a>
                        </form>
                    </c:if>
                    <c:if test="${empty editPayment}">
                        <form method="post" action="${ctx}/payments">
                            <input type="hidden" name="action" value="create"/>
                            <div class="mb-3">
                                <label class="form-label">Booking</label>
                                <select class="form-select" name="bookingId" required>
                                    <c:forEach var="bk" items="${bookingChoices}">
                                        <option value="${bk.id}">#<c:out value="${bk.id}"/> · <c:out value="${bk.eventDate}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Package</label>
                                <select class="form-select" name="packageType" id="pkgSelect">
                                    <c:forEach var="pk" items="${packageTypes}">
                                        <option value="${pk.name()}" data-suggest="${pk.suggestedPrice}"><c:out value="${pk.name()}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Amount (USD)</label>
                                <input class="form-control" type="number" step="0.01" min="0.01" name="amount" id="amt" required/>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Create payment</button>
                        </form>
                        <script>
                            (function () {
                                const sel = document.getElementById('pkgSelect');
                                const amt = document.getElementById('amt');
                                function sync() {
                                    const opt = sel.options[sel.selectedIndex];
                                    amt.value = opt.getAttribute('data-suggest') || '';
                                }
                                sel.addEventListener('change', sync);
                                sync();
                            })();
                        </script>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="col-lg-7">
        <div class="card p-0 overflow-hidden">
            <div class="card-header bg-white py-3"><h2 class="h6 mb-0">Payment records</h2></div>
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Booking</th>
                        <th>Package</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${payments}">
                        <tr>
                            <td><c:out value="${p.id}"/></td>
                            <td><c:out value="${p.bookingId}"/></td>
                            <td><c:out value="${p.packageType}"/></td>
                            <td>$<c:out value="${p.amount}"/></td>
                            <td><span class="badge text-bg-light border"><c:out value="${p.status}"/></span></td>
                            <td class="text-end">
                                <a class="btn btn-sm btn-outline-primary" href="${ctx}/payments?edit=${p.id}">Edit</a>
                                <c:if test="${sessionScope.currentUser.admin}">
                                    <form method="post" action="${ctx}/payments" class="d-inline" onsubmit="return confirm('Delete this payment record?');">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="paymentId" value="${p.id}"/>
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <c:if test="${empty payments}">
                <div class="p-4 text-muted text-center">No payments recorded.</div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
