<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="Dashboard" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<h1 class="h3 mb-1">Dashboard</h1>
<p class="text-muted mb-4">Overview of your wedding planning activity.</p>

<div class="row g-4 mb-4">
    <div class="col-md-4">
        <div class="card p-4">
            <p class="small text-muted text-uppercase mb-1">Recorded payments (paid)</p>
            <p class="h4 mb-0">$<c:out value="${totalPaid}"/></p>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card p-4">
            <p class="small text-muted text-uppercase mb-1">Bookings tracked</p>
            <p class="h4 mb-0">${fn:length(bookingHistory)}</p>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card p-4">
            <p class="small text-muted text-uppercase mb-1">Payment records</p>
            <p class="h4 mb-0">${fn:length(payments)}</p>
        </div>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-6">
        <div class="card p-0 overflow-hidden">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h2 class="h6 mb-0">Upcoming focus</h2>
                <a class="small" href="${ctx}/bookings">Manage</a>
            </div>
            <ul class="list-group list-group-flush">
                <c:forEach var="b" items="${upcoming}">
                    <c:set var="ven" value="${vendorMap[b.vendorId]}"/>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <strong><c:out value="${empty ven ? 'Unknown vendor' : ven.businessName}"/></strong>
                            <div class="small text-muted"><c:out value="${b.eventDate}"/> · <c:out value="${b.status}"/></div>
                        </div>
                    </li>
                </c:forEach>
                <c:if test="${empty upcoming}">
                    <li class="list-group-item text-muted">No active upcoming bookings.</li>
                </c:if>
            </ul>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="card p-0 overflow-hidden">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h2 class="h6 mb-0">Booking history</h2>
                <a class="small" href="${ctx}/bookings">Full list</a>
            </div>
            <div class="table-responsive">
                <table class="table table-sm mb-0">
                    <thead><tr><th>Date</th><th>Vendor</th><th>Status</th></tr></thead>
                    <tbody>
                    <c:forEach var="b" items="${bookingHistory}" end="7">
                        <c:set var="ven" value="${vendorMap[b.vendorId]}"/>
                        <tr>
                            <td><c:out value="${b.eventDate}"/></td>
                            <td><c:out value="${empty ven ? 'Unknown vendor' : ven.businessName}"/></td>
                            <td><c:out value="${b.status}"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="card mt-4 p-0 overflow-hidden">
    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
        <h2 class="h6 mb-0">Recent payments</h2>
        <a class="small" href="${ctx}/payments">Payments</a>
    </div>
    <div class="table-responsive">
        <table class="table mb-0 align-middle">
            <thead class="table-light"><tr><th>Package</th><th>Amount</th><th>Status</th><th>Date</th></tr></thead>
            <tbody>
            <c:forEach var="p" items="${payments}" end="9">
                <tr>
                    <td><c:out value="${p.packageType}"/></td>
                    <td>$<c:out value="${p.amount}"/></td>
                    <td><c:out value="${p.status}"/></td>
                    <td><c:out value="${p.createdAt}"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
