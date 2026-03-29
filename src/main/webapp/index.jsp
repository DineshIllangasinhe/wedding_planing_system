<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Home" scope="request"/>
<%@ include file="WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${param.deleted == '1'}">
    <div class="alert alert-info alert-dismissible fade show" role="alert">
        Your account was deleted. We hope to see you again.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="hero-gradient p-4 p-md-5 mb-5">
    <div class="row align-items-center g-4">
        <div class="col-lg-7">
            <p class="text-uppercase small opacity-75 mb-2">Wedding Planning &amp; Vendor Booking</p>
            <h1 class="display-5 fw-semibold mb-3">Plan your day with curated vendors and clear timelines.</h1>
            <p class="lead opacity-90 mb-4">
                Discover photographers, catering partners, and décor studios. Book with confidence—our system
                blocks double bookings on the same date and keeps your payment packages organized.
            </p>
            <div class="d-flex flex-wrap gap-2">
                <a class="btn btn-light btn-lg text-dark" href="${ctx}/vendors">Browse vendors</a>
                <c:choose>
                    <c:when test="${empty sessionScope.currentUser}">
                        <a class="btn btn-outline-light btn-lg" href="${ctx}/register">Create account</a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn btn-outline-light btn-lg" href="${ctx}/dashboard">Open dashboard</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="bg-white bg-opacity-10 rounded-4 p-4 border border-light border-opacity-25">
                <h2 class="h5 mb-3">Why couples choose Wedding Suite</h2>
                <ul class="list-unstyled mb-0 small opacity-90">
                    <li class="mb-2">✓ Full vendor profiles with category-specific details</li>
                    <li class="mb-2">✓ Search &amp; filter across photography, catering, and décor</li>
                    <li class="mb-2">✓ Booking history with status tracking</li>
                    <li>✓ Basic, Standard, and Premium package payments</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="row g-4 mb-5">
    <div class="col-md-4">
        <div class="card h-100 p-3">
            <div class="card-body">
                <span class="badge badge-vendor mb-2">Photography</span>
                <h3 class="h5 card-title">Story-driven coverage</h3>
                <p class="card-text text-muted small">Compare editorial, documentary, and classic styles with transparent day rates.</p>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card h-100 p-3">
            <div class="card-body">
                <span class="badge badge-vendor mb-2">Catering</span>
                <h3 class="h5 card-title">Menus that match your venue</h3>
                <p class="card-text text-muted small">Cuisine focus, staffing options, and tasting-ready descriptions.</p>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card h-100 p-3">
            <div class="card-body">
                <span class="badge badge-vendor mb-2">Décor</span>
                <h3 class="h5 card-title">Cohesive visual design</h3>
                <p class="card-text text-muted small">Theme-led styling with optional floral design add-ons.</p>
            </div>
        </div>
    </div>
</div>

<%@ include file="WEB-INF/jsp/includes/footer.jspf" %>
