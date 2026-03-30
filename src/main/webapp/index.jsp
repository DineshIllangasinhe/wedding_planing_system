<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Home" scope="request"/>
<%@ include file="WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${param.deleted == '1'}">
    <div class="mb-8 rounded-2xl border border-sky-200 bg-sky-50 px-4 py-3 text-sm text-sky-900" role="status">
        Your account was deleted. We hope to see you again.
    </div>
</c:if>

<%-- Full-bleed hero: couple on left, copy on right (matches photo composition) --%>
<section class="relative left-1/2 right-1/2 -ml-[50vw] -mr-[50vw] w-screen overflow-hidden">
    <div class="relative min-h-[min(88vh,52rem)] w-full bg-stone-900">
        <div class="absolute inset-0 bg-cover bg-center sm:bg-[center_30%]" style="background-image: url('${ctx}/images/home/hero-lake.png');"></div>
        <div class="absolute inset-0 bg-gradient-to-r from-stone-950/95 via-stone-900/75 to-stone-900/25 sm:from-stone-950/90 sm:via-stone-900/55 sm:to-transparent"></div>
        <div class="absolute inset-0 bg-gradient-to-t from-stone-950/50 to-transparent sm:hidden"></div>
        <div class="relative z-10 mx-auto flex min-h-[min(88vh,52rem)] max-w-7xl flex-col justify-end px-4 pb-16 pt-28 sm:px-6 sm:pb-20 sm:pt-32 lg:flex-row lg:items-center lg:justify-end lg:px-8 lg:pb-24 lg:pt-36">
            <div class="max-w-xl text-left lg:ml-auto lg:text-right">
                <p class="text-xs font-semibold uppercase tracking-[0.35em] text-amber-200/90">Wedding Suite</p>
                <h1 class="mt-4 font-hero text-4xl font-semibold leading-[1.1] tracking-tight text-white sm:text-5xl lg:text-6xl">
                    Plan the day you&rsquo;ll remember forever.
                </h1>
                <p class="mt-6 text-base leading-relaxed text-stone-200/95 sm:text-lg">
                    Curated vendors, protected dates, and payments in one place—built like a real operations platform, not a demo form.
                </p>
                <div class="mt-10 flex flex-wrap gap-3 lg:justify-end">
                    <a href="${ctx}/vendors" class="inline-flex items-center justify-center rounded-full bg-white px-7 py-3.5 text-sm font-semibold text-stone-900 shadow-lg shadow-black/20 transition hover:bg-amber-50">
                        Explore vendors
                    </a>
                    <c:choose>
                        <c:when test="${empty sessionScope.currentUser}">
                            <a href="${ctx}/register" class="inline-flex items-center justify-center rounded-full border border-white/35 bg-white/10 px-7 py-3.5 text-sm font-semibold text-white backdrop-blur-sm transition hover:bg-white/20">
                                Get started free
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${ctx}/dashboard" class="inline-flex items-center justify-center rounded-full border border-white/35 bg-white/10 px-7 py-3.5 text-sm font-semibold text-white backdrop-blur-sm transition hover:bg-white/20">
                                Open dashboard
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- Trust strip --%>
<section class="relative z-20 -mt-6 mx-auto max-w-7xl px-4 sm:-mt-8 sm:px-6 lg:px-8">
    <div class="grid gap-4 rounded-2xl border border-stone-200/90 bg-white/95 p-6 shadow-card backdrop-blur-sm sm:grid-cols-3 sm:p-8">
        <div class="text-center sm:text-left">
            <p class="font-display text-2xl font-semibold text-rose-800">Double-booking safe</p>
            <p class="mt-1 text-sm text-stone-600">Same vendor &amp; date conflicts are blocked automatically.</p>
        </div>
        <div class="text-center sm:border-x sm:border-stone-200 sm:px-6">
            <p class="font-display text-2xl font-semibold text-rose-800">Packages &amp; payments</p>
            <p class="mt-1 text-sm text-stone-600">Basic, Standard &amp; Premium flows with status tracking.</p>
        </div>
        <div class="text-center sm:text-right">
            <p class="font-display text-2xl font-semibold text-rose-800">Admin-ready</p>
            <p class="mt-1 text-sm text-stone-600">User directory, vendor CRUD, and audit-friendly records.</p>
        </div>
    </div>
</section>

<%-- Visual story: two images --%>
<section class="mt-16 sm:mt-20">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="mb-10 max-w-2xl">
            <h2 class="font-hero text-3xl font-semibold tracking-tight text-stone-900 sm:text-4xl">Every detail, considered</h2>
            <p class="mt-3 text-stone-600">From the first vow to the last toast—coordinate vendors and timelines with clarity.</p>
        </div>
        <div class="grid gap-6 lg:grid-cols-2 lg:gap-8">
            <figure class="group overflow-hidden rounded-3xl shadow-card">
                <img src="${ctx}/images/home/hero-rings.png" alt="Wedding ring exchange" class="h-72 w-full object-cover transition duration-700 group-hover:scale-[1.02] sm:h-96" loading="lazy" width="800" height="600"/>
                <figcaption class="border-x border-b border-stone-200/90 bg-white px-5 py-4">
                    <p class="font-display text-sm font-semibold text-stone-900">The moment</p>
                    <p class="mt-1 text-sm text-stone-500">Ceremony details, captured with care—mirrored in how we store your bookings.</p>
                </figcaption>
            </figure>
            <figure class="group overflow-hidden rounded-3xl shadow-card">
                <img src="${ctx}/images/home/hero-arch.png" alt="Couple at floral wedding arch" class="h-72 w-full object-cover object-[center_25%] transition duration-700 group-hover:scale-[1.02] sm:h-96" loading="lazy" width="800" height="600"/>
                <figcaption class="border-x border-b border-stone-200/90 bg-white px-5 py-4">
                    <p class="font-display text-sm font-semibold text-stone-900">The setting</p>
                    <p class="mt-1 text-sm text-stone-500">Décor, catering, photography—search and shortlist vendors that fit your vision.</p>
                </figcaption>
            </figure>
        </div>
    </div>
</section>

<%-- Full-bleed B&W celebration band --%>
<section class="relative left-1/2 right-1/2 mt-16 -ml-[50vw] -mr-[50vw] w-screen sm:mt-24">
    <div class="relative min-h-[22rem] overflow-hidden bg-stone-900">
        <img src="${ctx}/images/home/celebration-bw.png" alt="Celebration after the ceremony" class="absolute inset-0 h-full w-full object-cover object-center opacity-90" loading="lazy"/>
        <div class="absolute inset-0 bg-gradient-to-r from-stone-950/85 via-stone-900/55 to-stone-900/30"></div>
        <div class="relative z-10 mx-auto flex min-h-[22rem] max-w-4xl flex-col justify-center px-6 py-16 text-center sm:px-8">
            <blockquote class="font-hero text-2xl font-medium leading-snug text-white sm:text-3xl md:text-4xl">
                &ldquo;Your story deserves more than spreadsheets and group chats.&rdquo;
            </blockquote>
            <p class="mt-6 text-sm font-medium uppercase tracking-[0.25em] text-amber-200/90">One suite for couples &amp; coordinators</p>
        </div>
    </div>
</section>

<%-- Services --%>
<section class="mt-16 sm:mt-20">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <h2 class="font-hero text-2xl font-semibold text-stone-900 sm:text-3xl">What you can book</h2>
        <p class="mt-2 max-w-2xl text-stone-600">Categories designed around real vendor data—not generic placeholders.</p>
        <div class="mt-10 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <article class="group rounded-2xl border border-stone-200/90 bg-white p-6 shadow-soft transition hover:border-rose-200/80 hover:shadow-card">
                <span class="inline-flex rounded-full bg-rose-100 px-3 py-1 text-xs font-semibold text-rose-800">Photography</span>
                <h3 class="mt-4 font-display text-lg font-semibold text-stone-900">Story-driven coverage</h3>
                <p class="mt-2 text-sm leading-relaxed text-stone-600">Editorial, documentary, and classic styles with transparent day rates.</p>
            </article>
            <article class="group rounded-2xl border border-stone-200/90 bg-white p-6 shadow-soft transition hover:border-rose-200/80 hover:shadow-card">
                <span class="inline-flex rounded-full bg-amber-100 px-3 py-1 text-xs font-semibold text-amber-900">Catering</span>
                <h3 class="mt-4 font-display text-lg font-semibold text-stone-900">Menus that match your venue</h3>
                <p class="mt-2 text-sm leading-relaxed text-stone-600">Cuisine focus, staffing options, and tasting-ready descriptions.</p>
            </article>
            <article class="group rounded-2xl border border-stone-200/90 bg-white p-6 shadow-soft transition hover:border-rose-200/80 hover:shadow-card sm:col-span-2 lg:col-span-1">
                <span class="inline-flex rounded-full bg-violet-100 px-3 py-1 text-xs font-semibold text-violet-900">Décor</span>
                <h3 class="mt-4 font-display text-lg font-semibold text-stone-900">Cohesive visual design</h3>
                <p class="mt-2 text-sm leading-relaxed text-stone-600">Theme-led styling with optional floral design add-ons.</p>
            </article>
        </div>
    </div>
</section>

<%-- Bottom CTA --%>
<section class="mt-16 pb-4 sm:mt-20">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="overflow-hidden rounded-3xl bg-gradient-to-br from-rose-900 via-rose-800 to-amber-900 px-8 py-12 text-center shadow-card sm:px-12 sm:py-16">
            <h2 class="font-hero text-2xl font-semibold text-white sm:text-3xl">Ready to shape your timeline?</h2>
            <p class="mx-auto mt-3 max-w-lg text-rose-100/90">Browse vendors, lock your date, and keep payments aligned—starting today.</p>
            <div class="mt-8 flex flex-wrap justify-center gap-3">
                <a href="${ctx}/vendors" class="inline-flex rounded-full bg-white px-8 py-3 text-sm font-semibold text-rose-900 shadow-lg hover:bg-amber-50">Browse directory</a>
                <c:if test="${empty sessionScope.currentUser}">
                    <a href="${ctx}/register" class="inline-flex rounded-full border border-white/40 bg-white/10 px-8 py-3 text-sm font-semibold text-white backdrop-blur-sm hover:bg-white/20">Create account</a>
                </c:if>
            </div>
        </div>
    </div>
</section>

<%@ include file="WEB-INF/jsp/includes/footer.jspf" %>
