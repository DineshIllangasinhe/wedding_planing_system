<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Bookings" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${not empty param.error}">
    <div class="alert alert-danger"><c:out value="${param.error}"/></div>
</c:if>
<c:if test="${not empty param.ok}">
    <div class="alert alert-success"><c:out value="${param.ok}"/></div>
</c:if>

<h1 class="h3 mb-4">Bookings</h1>

<div class="row g-4">
    <div class="col-lg-5">
        <div class="card p-4 h-100">
            <h2 class="h5 mb-3">${empty editBooking ? 'New booking' : 'Edit booking'}</h2>
            <c:choose>
                <c:when test="${empty vendors}">
                    <p class="text-muted small">No vendors available yet. Ask an administrator to add vendors first.</p>
                </c:when>
                <c:otherwise>
                    <c:if test="${not empty editBooking}">
                        <form method="post" action="${ctx}/bookings" class="mb-4">
                            <input type="hidden" name="action" value="update"/>
                            <input type="hidden" name="bookingId" value="${editBooking.id}"/>
                            <div class="mb-3">
                                <label class="form-label">Vendor</label>
                                <select class="form-select" name="vendorId" required>
                                    <c:forEach var="ven" items="${vendors}">
                                        <option value="${ven.id}" ${ven.id == editBooking.vendorId ? 'selected' : ''}><c:out value="${ven.businessName}"/> (${ven.typeDisplayName})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Event date</label>
                                <input class="form-control" type="date" name="eventDate" required value="${editBooking.eventDate}"/>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Status</label>
                                <select class="form-select" name="status">
                                    <c:forEach var="st" items="${statuses}">
                                        <option value="${st.name()}" ${st == editBooking.status ? 'selected' : ''}><c:out value="${st.name()}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Notes</label>
                                <textarea class="form-control" name="notes" rows="2"><c:out value="${editBooking.notes}"/></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">Save changes</button>
                            <a class="btn btn-outline-secondary" href="${ctx}/bookings">Cancel</a>
                        </form>
                    </c:if>
                    <c:if test="${empty editBooking}">
                        <form method="post" action="${ctx}/bookings">
                            <input type="hidden" name="action" value="create"/>
                            <div class="mb-3">
                                <label class="form-label">Vendor</label>
                                <select class="form-select" name="vendorId" required>
                                    <c:forEach var="ven" items="${vendors}">
                                        <option value="${ven.id}"><c:out value="${ven.businessName}"/> (${ven.typeDisplayName})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Event date</label>
                                <input class="form-control" type="date" name="eventDate" required/>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Notes</label>
                                <textarea class="form-control" name="notes" rows="2" placeholder="Ceremony time, venue, special requests…"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Submit booking</button>
                        </form>
                    </c:if>
                    <p class="small text-muted mt-3 mb-0">The same vendor cannot be booked twice on the same date unless a prior booking is cancelled.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="col-lg-7">
        <div class="card p-0 overflow-hidden">
            <div class="card-header bg-white py-3"><h2 class="h6 mb-0">Booking history</h2></div>
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Date</th>
                        <th>Vendor</th>
                        <th>Status</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <c:set var="ven" value="${vendorMap[b.vendorId]}"/>
                        <tr>
                            <td><c:out value="${b.eventDate}"/></td>
                            <td><c:out value="${empty ven ? 'Unknown vendor' : ven.businessName}"/></td>
                            <td><span class="badge text-bg-secondary"><c:out value="${b.status}"/></span></td>
                            <td class="text-end">
                                <div class="btn-group btn-group-sm">
                                    <a class="btn btn-outline-primary" href="${ctx}/bookings?edit=${b.id}">Edit</a>
                                    <form method="post" action="${ctx}/bookings" class="d-inline" onsubmit="return confirm('Cancel this booking?');">
                                        <input type="hidden" name="action" value="cancel"/>
                                        <input type="hidden" name="bookingId" value="${b.id}"/>
                                        <button type="submit" class="btn btn-outline-warning">Cancel</button>
                                    </form>
                                    <c:if test="${sessionScope.currentUser.admin}">
                                        <form method="post" action="${ctx}/bookings" class="d-inline" onsubmit="return confirm('Permanently delete this record?');">
                                            <input type="hidden" name="action" value="delete"/>
                                            <input type="hidden" name="bookingId" value="${b.id}"/>
                                            <button type="submit" class="btn btn-outline-danger">Delete</button>
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
                <div class="p-4 text-muted text-center">No bookings yet.</div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
