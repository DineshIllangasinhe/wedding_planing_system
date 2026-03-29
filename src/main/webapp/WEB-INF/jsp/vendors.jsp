<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Vendors" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${not empty flashSuccess}"><div class="alert alert-success alert-dismissible fade show">${flashSuccess}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
<c:if test="${not empty flashError}"><div class="alert alert-danger alert-dismissible fade show">${flashError}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>

<div class="d-flex flex-column flex-md-row justify-content-between align-items-start gap-3 mb-4">
    <div>
        <h1 class="h3 mb-1">Vendor directory</h1>
        <p class="text-muted mb-0 small">Search by keyword and narrow by category.</p>
    </div>
    <c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
        <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#vendorFormCollapse">
            Add or edit vendor
        </button>
    </c:if>
</div>

<form class="row g-2 align-items-end mb-4" method="get" action="${ctx}/vendors">
    <div class="col-md-5">
        <label class="form-label small text-muted" for="search">Search</label>
        <input class="form-control" id="search" name="search" placeholder="Name, description, specialty…" value="${search}"/>
    </div>
    <div class="col-md-4">
        <label class="form-label small text-muted" for="type">Category</label>
        <select class="form-select" id="type" name="type">
            <option value="">All categories</option>
            <option value="PHOTOGRAPHER" ${typeFilterParam == 'PHOTOGRAPHER' ? 'selected' : ''}>Photographer</option>
            <option value="CATERING" ${typeFilterParam == 'CATERING' ? 'selected' : ''}>Catering</option>
            <option value="DECORATION" ${typeFilterParam == 'DECORATION' ? 'selected' : ''}>Decoration</option>
        </select>
    </div>
    <div class="col-md-3">
        <button type="submit" class="btn btn-outline-primary w-100">Apply filters</button>
    </div>
</form>

<c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
    <c:set var="v" value="${editVendor}"/>
    <div class="collapse mb-4 ${not empty editVendor ? 'show' : ''}" id="vendorFormCollapse">
        <div class="card p-4">
            <h2 class="h5 mb-3">${empty editVendor ? 'New vendor' : 'Edit vendor'}</h2>
            <form method="post" action="${ctx}/vendors" id="vendorSaveForm">
                <input type="hidden" name="action" value="save"/>
                <c:if test="${not empty v}"><input type="hidden" name="id" value="${v.id}"/></c:if>
                <c:set var="selType" value="${empty v ? 'PHOTOGRAPHER' : v.type.name()}"/>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Category</label>
                        <select class="form-select" name="vendorType" id="vendorType" required>
                            <option value="PHOTOGRAPHER" ${selType == 'PHOTOGRAPHER' ? 'selected' : ''}>Photographer</option>
                            <option value="CATERING" ${selType == 'CATERING' ? 'selected' : ''}>Catering</option>
                            <option value="DECORATION" ${selType == 'DECORATION' ? 'selected' : ''}>Decoration</option>
                        </select>
                    </div>
                    <div class="col-md-8">
                        <label class="form-label">Business name</label>
                        <input class="form-control" name="businessName" required value="${v.businessName}"/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Contact email</label>
                        <input class="form-control" type="email" name="contactEmail" required value="${v.contactEmail}"/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Phone</label>
                        <input class="form-control" name="contactPhone" required value="${v.contactPhone}"/>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="2" required><c:out value="${v.description}"/></textarea>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Daily rate (USD)</label>
                        <input class="form-control" name="dailyRate" type="number" step="0.01" min="0.01" required
                               value="${v.dailyRate}"/>
                    </div>
                    <div class="col-md-4 field-photo">
                        <label class="form-label">Shooting style</label>
                        <input class="form-control" name="shootingStyle" value="<c:choose><c:when test="${not empty v and v['class'].simpleName == 'Photographer'}"><c:out value="${v.shootingStyle}"/></c:when><c:otherwise></c:otherwise></c:choose>"/>
                    </div>
                    <div class="col-md-4 field-photo">
                        <label class="form-label">Included hours / day</label>
                        <input class="form-control" type="number" name="includedHours" min="1" max="24"
                               value="<c:choose><c:when test="${not empty v and v['class'].simpleName == 'Photographer'}"><c:out value="${v.includedHours}"/></c:when><c:otherwise>8</c:otherwise></c:choose>"/>
                    </div>
                    <div class="col-md-6 field-cat d-none">
                        <label class="form-label">Cuisine type</label>
                        <input class="form-control" name="cuisineType" value="<c:choose><c:when test="${not empty v and v['class'].simpleName == 'Caterer'}"><c:out value="${v.cuisineType}"/></c:when><c:otherwise></c:otherwise></c:choose>"/>
                    </div>
                    <div class="col-md-6 field-cat d-none">
                        <label class="form-label d-block">Staffing</label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="includesStaffing" id="staff"
                                   <c:if test="${not empty v and v['class'].simpleName == 'Caterer' and v.includesStaffing}">checked</c:if>/>
                            <label class="form-check-label" for="staff">Includes on-site staffing</label>
                        </div>
                    </div>
                    <div class="col-md-6 field-dec d-none">
                        <label class="form-label">Theme / style focus</label>
                        <input class="form-control" name="themeFocus" value="<c:choose><c:when test="${not empty v and v['class'].simpleName == 'DecoratorVendor'}"><c:out value="${v.themeFocus}"/></c:when><c:otherwise></c:otherwise></c:choose>"/>
                    </div>
                    <div class="col-md-6 field-dec d-none">
                        <label class="form-label d-block">Florals</label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="providesFlorals" id="floral"
                                   <c:if test="${not empty v and v['class'].simpleName == 'DecoratorVendor' and v.providesFlorals}">checked</c:if>/>
                            <label class="form-check-label" for="floral">Provides floral design</label>
                        </div>
                    </div>
                </div>
                <div class="mt-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary">Save vendor</button>
                    <c:if test="${not empty v}">
                        <a class="btn btn-outline-secondary" href="${ctx}/vendors">Cancel edit</a>
                    </c:if>
                </div>
            </form>
        </div>
    </div>
    <script>
        (function () {
            const type = document.getElementById('vendorType');
            const photo = document.querySelectorAll('.field-photo');
            const cat = document.querySelectorAll('.field-cat');
            const dec = document.querySelectorAll('.field-dec');
            function sync() {
                const val = type.value;
                photo.forEach(el => el.classList.toggle('d-none', val !== 'PHOTOGRAPHER'));
                cat.forEach(el => el.classList.toggle('d-none', val !== 'CATERING'));
                dec.forEach(el => el.classList.toggle('d-none', val !== 'DECORATION'));
            }
            type.addEventListener('change', sync);
            sync();
        })();
    </script>
</c:if>

<div class="row g-4">
    <c:forEach var="vendor" items="${vendors}">
        <div class="col-md-6 col-xl-4">
            <div class="card h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <span class="badge badge-vendor">${vendor.typeDisplayName}</span>
                        <strong class="text-success">$<c:out value="${vendor.dailyRate}"/>/day</strong>
                    </div>
                    <h2 class="h5 card-title"><c:out value="${vendor.businessName}"/></h2>
                    <p class="small text-muted mb-2"><c:out value="${vendor.specialtySummary}"/></p>
                    <p class="card-text small"><c:out value="${vendor.description}"/></p>
                    <p class="small mb-1"><strong>Contact:</strong> <c:out value="${vendor.contactEmail}"/> · <c:out value="${vendor.contactPhone}"/></p>
                    <p class="small text-muted mb-0"><c:out value="${vendor.serviceDetails}"/></p>
                    <c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
                        <div class="d-flex gap-2 mt-3">
                            <a class="btn btn-sm btn-outline-primary" href="${ctx}/vendors?edit=${vendor.id}">Edit</a>
                            <form method="post" action="${ctx}/vendors" onsubmit="return confirm('Delete this vendor?');">
                                <input type="hidden" name="action" value="delete"/>
                                <input type="hidden" name="id" value="${vendor.id}"/>
                                <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </c:forEach>
</div>
<c:if test="${empty vendors}">
    <p class="text-muted">No vendors match your filters.</p>
</c:if>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
