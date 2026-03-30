<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Vendors" scope="request"/>
<%@ include file="/WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${not empty flashSuccess}"><div class="mb-6 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900"><c:out value="${flashSuccess}"/></div></c:if>
<c:if test="${not empty flashError}"><div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900"><c:out value="${flashError}"/></div></c:if>

<div class="mb-8 flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
    <div>
        <h1 class="font-display text-2xl font-semibold text-stone-900 sm:text-3xl">Vendor directory</h1>
        <p class="mt-1 text-sm text-stone-500">Search by keyword and narrow by category.</p>
    </div>
    <c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
        <button class="inline-flex items-center justify-center rounded-xl bg-gradient-to-r from-rose-600 to-rose-700 px-5 py-2.5 text-sm font-semibold text-white shadow-md shadow-rose-600/20 hover:from-rose-700 hover:to-rose-800" type="button" id="toggleVendorForm">
            Add or edit vendor
        </button>
    </c:if>
</div>

<form class="mb-8 grid gap-4 rounded-2xl border border-stone-200/90 bg-white p-4 shadow-soft sm:grid-cols-12 sm:items-end sm:gap-3 sm:p-5" method="get" action="${ctx}/vendors">
    <div class="sm:col-span-5">
        <label class="mb-1.5 block text-xs font-medium uppercase tracking-wide text-stone-500" for="search">Search</label>
        <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" id="search" name="search" placeholder="Name, description, specialty…" value="${search}"/>
    </div>
    <div class="sm:col-span-4">
        <label class="mb-1.5 block text-xs font-medium uppercase tracking-wide text-stone-500" for="type">Category</label>
        <select class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" id="type" name="type">
            <option value="">All categories</option>
            <option value="PHOTOGRAPHER" ${typeFilterParam == 'PHOTOGRAPHER' ? 'selected' : ''}>Photographer</option>
            <option value="CATERING" ${typeFilterParam == 'CATERING' ? 'selected' : ''}>Catering</option>
            <option value="DECORATION" ${typeFilterParam == 'DECORATION' ? 'selected' : ''}>Decoration</option>
        </select>
    </div>
    <div class="sm:col-span-3">
        <button type="submit" class="flex w-full items-center justify-center rounded-xl border border-stone-300 bg-white px-4 py-2.5 text-sm font-semibold text-stone-800 shadow-sm hover:bg-stone-50">Apply filters</button>
    </div>
</form>

<c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
    <c:set var="v" value="${editVendor}"/>
    <div id="vendorFormCollapse" class="mb-8 ${empty editVendor ? 'hidden' : ''} rounded-2xl border border-stone-200/90 bg-white p-6 shadow-card sm:p-8">
        <h2 class="font-display text-lg font-semibold text-stone-900">${empty editVendor ? 'New vendor' : 'Edit vendor'}</h2>
        <form method="post" action="${ctx}/vendors" id="vendorSaveForm" class="mt-6">
            <input type="hidden" name="action" value="save"/>
            <c:if test="${not empty v}"><input type="hidden" name="id" value="${v.id}"/></c:if>
            <c:set var="selType" value="${empty v ? 'PHOTOGRAPHER' : v.type.name()}"/>
            <div class="grid gap-4 sm:grid-cols-12">
                <div class="sm:col-span-4">
                    <label class="mb-1.5 block text-sm font-medium text-stone-700">Category</label>
                    <select class="block w-full rounded-xl border border-stone-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="vendorType" id="vendorType" required>
                        <option value="PHOTOGRAPHER" ${selType == 'PHOTOGRAPHER' ? 'selected' : ''}>Photographer</option>
                        <option value="CATERING" ${selType == 'CATERING' ? 'selected' : ''}>Catering</option>
                        <option value="DECORATION" ${selType == 'DECORATION' ? 'selected' : ''}>Decoration</option>
                    </select>
                </div>
                <div class="sm:col-span-8">
                    <label class="mb-1.5 block text-sm font-medium text-stone-700">Business name</label>
                    <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="businessName" required value="${v.businessName}"/>
                </div>
                <div class="sm:col-span-6">
                    <label class="mb-1.5 block text-sm font-medium text-stone-700">Contact email</label>
                    <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="email" name="contactEmail" required value="${v.contactEmail}"/>
                </div>
                <div class="sm:col-span-6">
                    <label class="mb-1.5 block text-sm font-medium text-stone-700">Phone</label>
                    <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="contactPhone" required value="${v.contactPhone}"/>
                </div>
                <div class="sm:col-span-12">
                    <label class="mb-1.5 block text-sm font-medium text-stone-700">Description</label>
                    <textarea class="block w-full rounded-xl border border-stone-300 px-3 py-2 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="description" rows="3" required><c:out value="${v.description}"/></textarea>
                </div>
                <div class="sm:col-span-4">
                    <label class="mb-1.5 block text-sm font-medium text-stone-700">Daily rate (USD)</label>
                    <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="dailyRate" type="number" step="0.01" min="0.01" required value="${v.dailyRate}"/>
                </div>
                <div class="field-photo sm:col-span-4">
                    <label class="mb-1.5 block text-sm font-medium text-stone-700">Shooting style</label>
                    <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="shootingStyle" value="<c:choose><c:when test="${not empty v and v['class'].simpleName == 'Photographer'}"><c:out value="${v.shootingStyle}"/></c:when><c:otherwise></c:otherwise></c:choose>"/>
                </div>
                <div class="field-photo sm:col-span-4">
                    <label class="mb-1.5 block text-sm font-medium text-stone-700">Included hours / day</label>
                    <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" type="number" name="includedHours" min="1" max="24"
                           value="<c:choose><c:when test="${not empty v and v['class'].simpleName == 'Photographer'}"><c:out value="${v.includedHours}"/></c:when><c:otherwise>8</c:otherwise></c:choose>"/>
                </div>
                <div class="field-cat hidden sm:col-span-6">
                    <label class="mb-1.5 block text-sm font-medium text-stone-700">Cuisine type</label>
                    <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="cuisineType" value="<c:choose><c:when test="${not empty v and v['class'].simpleName == 'Caterer'}"><c:out value="${v.cuisineType}"/></c:when><c:otherwise></c:otherwise></c:choose>"/>
                </div>
                <div class="field-cat hidden sm:col-span-6">
                    <label class="mb-1.5 flex items-center gap-2 text-sm font-medium text-stone-700">
                        <input class="h-4 w-4 rounded border-stone-300 text-rose-600 focus:ring-rose-500" type="checkbox" name="includesStaffing" id="staff"
                               <c:if test="${not empty v and v['class'].simpleName == 'Caterer' and v.includesStaffing}">checked</c:if>/>
                        Includes on-site staffing
                    </label>
                </div>
                <div class="field-dec hidden sm:col-span-6">
                    <label class="mb-1.5 block text-sm font-medium text-stone-700">Theme / style focus</label>
                    <input class="block w-full rounded-xl border border-stone-300 px-3 py-2.5 text-sm shadow-sm focus:border-rose-500 focus:outline-none focus:ring-2 focus:ring-rose-500/25" name="themeFocus" value="<c:choose><c:when test="${not empty v and v['class'].simpleName == 'DecoratorVendor'}"><c:out value="${v.themeFocus}"/></c:when><c:otherwise></c:otherwise></c:choose>"/>
                </div>
                <div class="field-dec hidden sm:col-span-6">
                    <label class="mb-1.5 flex items-center gap-2 text-sm font-medium text-stone-700">
                        <input class="h-4 w-4 rounded border-stone-300 text-rose-600 focus:ring-rose-500" type="checkbox" name="providesFlorals" id="floral"
                               <c:if test="${not empty v and v['class'].simpleName == 'DecoratorVendor' and v.providesFlorals}">checked</c:if>/>
                        Provides floral design
                    </label>
                </div>
            </div>
            <div class="mt-6 flex flex-wrap gap-2">
                <button type="submit" class="inline-flex rounded-xl bg-rose-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-rose-700">Save vendor</button>
                <c:if test="${not empty v}">
                    <a href="${ctx}/vendors" class="inline-flex rounded-xl border border-stone-300 bg-white px-5 py-2.5 text-sm font-semibold text-stone-700 hover:bg-stone-50">Cancel edit</a>
                </c:if>
            </div>
        </form>
    </div>
    <script>
        (function () {
            var btn = document.getElementById('toggleVendorForm');
            var panel = document.getElementById('vendorFormCollapse');
            if (btn && panel) {
                btn.addEventListener('click', function () { panel.classList.toggle('hidden'); });
            }
            var type = document.getElementById('vendorType');
            var photo = document.querySelectorAll('.field-photo');
            var cat = document.querySelectorAll('.field-cat');
            var dec = document.querySelectorAll('.field-dec');
            function sync() {
                if (!type) return;
                var val = type.value;
                photo.forEach(function (el) { el.classList.toggle('hidden', val !== 'PHOTOGRAPHER'); });
                cat.forEach(function (el) { el.classList.toggle('hidden', val !== 'CATERING'); });
                dec.forEach(function (el) { el.classList.toggle('hidden', val !== 'DECORATION'); });
            }
            if (type) {
                type.addEventListener('change', sync);
                sync();
            }
        })();
    </script>
</c:if>

<div class="grid gap-6 sm:grid-cols-2 xl:grid-cols-3">
    <c:forEach var="vendor" items="${vendors}">
        <article class="flex flex-col rounded-2xl border border-stone-200/90 bg-white p-6 shadow-soft transition hover:border-rose-200/80 hover:shadow-card">
            <div class="flex items-start justify-between gap-2">
                <span class="inline-flex rounded-full bg-rose-100 px-3 py-1 text-xs font-semibold text-rose-900">${vendor.typeDisplayName}</span>
                <span class="text-sm font-semibold text-emerald-700">$<c:out value="${vendor.dailyRate}"/>/day</span>
            </div>
            <h2 class="mt-4 font-display text-lg font-semibold text-stone-900"><c:out value="${vendor.businessName}"/></h2>
            <p class="mt-1 text-sm text-stone-500"><c:out value="${vendor.specialtySummary}"/></p>
            <p class="mt-3 flex-1 text-sm leading-relaxed text-stone-600"><c:out value="${vendor.description}"/></p>
            <p class="mt-4 text-xs text-stone-600"><strong class="text-stone-800">Contact:</strong> <c:out value="${vendor.contactEmail}"/> · <c:out value="${vendor.contactPhone}"/></p>
            <p class="mt-1 text-xs text-stone-500"><c:out value="${vendor.serviceDetails}"/></p>
            <c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
                <div class="mt-5 flex flex-wrap gap-2 border-t border-stone-100 pt-4">
                    <a href="${ctx}/vendors?edit=${vendor.id}" class="inline-flex rounded-lg border border-rose-200 bg-rose-50 px-3 py-1.5 text-xs font-semibold text-rose-900 hover:bg-rose-100">Edit</a>
                    <form method="post" action="${ctx}/vendors" onsubmit="return confirm('Delete this vendor?');">
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="id" value="${vendor.id}"/>
                        <button type="submit" class="inline-flex rounded-lg border border-red-200 bg-red-50 px-3 py-1.5 text-xs font-semibold text-red-800 hover:bg-red-100">Delete</button>
                    </form>
                </div>
            </c:if>
        </article>
    </c:forEach>
</div>
<c:if test="${empty vendors}">
    <p class="mt-8 text-center text-sm text-stone-500">No vendors match your filters.</p>
</c:if>

<%@ include file="/WEB-INF/jsp/includes/footer.jspf" %>
