<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Home" scope="request"/>
<%@ include file="WEB-INF/jsp/includes/header.jspf" %>

<c:if test="${param.deleted == '1'}">
    <div class="mb-8 rounded-2xl border border-sky-200 bg-sky-50 px-4 py-3 text-sm text-sky-900" role="status">
        Your account was deleted. We hope to see you again.
    </div>
</c:if>

<section class="relative left-1/2 right-1/2 -ml-[50vw] -mr-[50vw] w-screen overflow-hidden">
    <div class="relative min-h-[min(90vh,56rem)] w-full bg-stone-950">
        <div class="absolute inset-0 hero-slider">
            <img src="${ctx}/images/home/lake-couple-2.png" alt="Bride and groom by lakeside" class="hero-slide"/>
            <img src="${ctx}/images/home/hero-lake.png" alt="Golden hour wedding portrait" class="hero-slide"/>
            <img src="${ctx}/images/home/arch-floral-2.png" alt="Couple under floral arch" class="hero-slide"/>
            <img src="${ctx}/images/home/hero-arch.png" alt="Outdoor wedding ceremony" class="hero-slide"/>
        </div>
        <div class="absolute inset-0 bg-gradient-to-r from-stone-950/90 via-stone-950/65 to-stone-900/20"></div>
        <div class="hero-glow hero-glow-left"></div>
        <div class="hero-glow hero-glow-right"></div>
        <div class="relative z-10 mx-auto flex min-h-[min(90vh,56rem)] max-w-7xl flex-col justify-end px-4 pb-20 pt-28 sm:px-6 lg:px-8">
            <div class="max-w-2xl motion-fade-up">
                <p class="text-xs font-semibold uppercase tracking-[0.35em] text-rose-200">Wedding Planning Platform</p>
                <h1 class="mt-4 font-hero text-4xl font-semibold leading-tight text-white sm:text-5xl lg:text-6xl">
                    Real weddings deserve a real system.
                </h1>
                <p class="mt-6 max-w-xl text-base leading-relaxed text-stone-200 sm:text-lg">
                    Plan your ceremony like modern teams do: coordinated vendors, secured dates, clear payments, and a polished experience from first click to final celebration.
                </p>
                <div class="mt-10 flex flex-wrap gap-3">
                    <a href="${ctx}/vendors" class="inline-flex items-center justify-center rounded-full bg-white px-7 py-3.5 text-sm font-semibold text-stone-900 shadow-lg shadow-black/30 transition hover:bg-rose-50">
                        Explore vendors
                    </a>
                    <c:choose>
                        <c:when test="${empty sessionScope.currentUser}">
                            <a href="${ctx}/register" class="inline-flex items-center justify-center rounded-full border border-white/35 bg-white/10 px-7 py-3.5 text-sm font-semibold text-white backdrop-blur-sm transition hover:bg-white/20">
                                Start planning
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

<section class="relative z-20 -mt-7 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
    <div class="grid gap-4 rounded-2xl border border-stone-200/90 bg-white/95 p-6 shadow-card motion-fade-up sm:grid-cols-3 sm:p-8">
        <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-stone-500">Availability</p>
            <p class="mt-2 font-display text-2xl font-semibold text-stone-900">Conflict-safe booking</p>
            <p class="mt-1 text-sm text-stone-600">Auto blocks duplicate vendor/date reservations.</p>
        </div>
        <div class="sm:border-x sm:border-stone-200 sm:px-6">
            <p class="text-xs font-semibold uppercase tracking-wider text-stone-500">Operations</p>
            <p class="mt-2 font-display text-2xl font-semibold text-stone-900">Package + payment flow</p>
            <p class="mt-1 text-sm text-stone-600">Track status from request to final payment.</p>
        </div>
        <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-stone-500">Control</p>
            <p class="mt-2 font-display text-2xl font-semibold text-stone-900">Admin-ready tools</p>
            <p class="mt-1 text-sm text-stone-600">Manage vendors and users with search and filters.</p>
        </div>
    </div>
</section>

<section class="mt-8 sm:mt-10">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="glass-strip rounded-2xl px-4 py-4 sm:px-6">
            <div class="grid gap-3 text-center sm:grid-cols-3">
                <div class="glass-chip">
                    <p class="text-xs uppercase tracking-[0.22em] text-rose-700/80">Avg booking setup</p>
                    <p class="mt-1 font-display text-2xl text-stone-900">~ 6 min</p>
                </div>
                <div class="glass-chip">
                    <p class="text-xs uppercase tracking-[0.22em] text-rose-700/80">Tracked payment states</p>
                    <p class="mt-1 font-display text-2xl text-stone-900">Pending / Paid</p>
                </div>
                <div class="glass-chip">
                    <p class="text-xs uppercase tracking-[0.22em] text-rose-700/80">Role separation</p>
                    <p class="mt-1 font-display text-2xl text-stone-900">Admin + Customer</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="mt-16 sm:mt-20">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="mb-10 max-w-2xl">
            <h2 class="font-hero text-3xl font-semibold tracking-tight text-stone-900 sm:text-4xl">A complete wedding story, in one experience</h2>
            <p class="mt-3 text-stone-600">Built with real visuals and real product behavior. Every stage of a wedding can be managed from one clean interface.</p>
        </div>
        <div class="grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
            <figure class="group overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft motion-fade-up">
                <img src="${ctx}/images/home/hero-lake.png" alt="Couple portrait in golden landscape" class="h-56 w-full object-cover transition duration-700 group-hover:scale-105"/>
                <figcaption class="px-4 py-3 text-sm text-stone-600">Golden-hour portraits</figcaption>
            </figure>
            <figure class="group overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft motion-fade-up motion-delay-1">
                <img src="${ctx}/images/home/ring-closeup-2.png" alt="Close-up ring exchange" class="h-56 w-full object-cover transition duration-700 group-hover:scale-105"/>
                <figcaption class="px-4 py-3 text-sm text-stone-600">Ring exchange details</figcaption>
            </figure>
            <figure class="group overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft motion-fade-up motion-delay-2">
                <img src="${ctx}/images/home/hero-rings.png" alt="Marriage signing moment" class="h-56 w-full object-cover transition duration-700 group-hover:scale-105"/>
                <figcaption class="px-4 py-3 text-sm text-stone-600">Legal and ceremony signing</figcaption>
            </figure>
            <figure class="group overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft motion-fade-up motion-delay-3">
                <img src="${ctx}/images/home/hero-arch.png" alt="Garden ceremony with wedding party" class="h-56 w-full object-cover transition duration-700 group-hover:scale-105"/>
                <figcaption class="px-4 py-3 text-sm text-stone-600">Classic ceremony setup</figcaption>
            </figure>
            <figure class="group overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft motion-fade-up">
                <img src="${ctx}/images/home/arch-floral-2.png" alt="Couple under colorful floral arch" class="h-56 w-full object-cover transition duration-700 group-hover:scale-105"/>
                <figcaption class="px-4 py-3 text-sm text-stone-600">Floral concept ceremony</figcaption>
            </figure>
            <figure class="group overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft motion-fade-up motion-delay-1">
                <img src="${ctx}/images/home/lake-couple-2.png" alt="Bride and groom by the lake" class="h-56 w-full object-cover transition duration-700 group-hover:scale-105"/>
                <figcaption class="px-4 py-3 text-sm text-stone-600">Editorial couple session</figcaption>
            </figure>
            <figure class="group overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft motion-fade-up motion-delay-2">
                <img src="${ctx}/images/home/celebration-rice-bw-2.png" alt="Black and white wedding celebration" class="h-56 w-full object-cover transition duration-700 group-hover:scale-105"/>
                <figcaption class="px-4 py-3 text-sm text-stone-600">Grand celebration exit</figcaption>
            </figure>
            <figure class="group overflow-hidden rounded-2xl border border-stone-200/90 bg-white shadow-soft motion-fade-up motion-delay-3">
                <img src="${ctx}/images/home/celebration-bw.png" alt="Traditional wedding ring ceremony" class="h-56 w-full object-cover transition duration-700 group-hover:scale-105"/>
                <figcaption class="px-4 py-3 text-sm text-stone-600">Cultural ceremony moment</figcaption>
            </figure>
        </div>
    </div>
</section>

<section class="mt-16 sm:mt-20">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="mb-8 flex items-end justify-between gap-4">
            <div>
                <h2 class="font-hero text-3xl font-semibold tracking-tight text-stone-900 sm:text-4xl">Signature experiences</h2>
                <p class="mt-2 text-stone-600">Designed like a real event operation: visual, organized, and fast.</p>
            </div>
            <a href="${ctx}/dashboard" class="hidden rounded-full border border-stone-300 bg-white px-4 py-2 text-sm font-semibold text-stone-700 shadow-sm transition hover:bg-stone-50 sm:inline-flex">View dashboard</a>
        </div>
        <div class="grid gap-5 md:grid-cols-3">
            <article class="premium-card motion-fade-up">
                <div class="premium-pill">01</div>
                <h3 class="mt-5 font-display text-xl font-semibold text-stone-900">Visual vendor discovery</h3>
                <p class="mt-2 text-sm leading-relaxed text-stone-600">Search vendors by category and compare offerings before locking your date.</p>
            </article>
            <article class="premium-card motion-fade-up motion-delay-1">
                <div class="premium-pill">02</div>
                <h3 class="mt-5 font-display text-xl font-semibold text-stone-900">Protected booking workflow</h3>
                <p class="mt-2 text-sm leading-relaxed text-stone-600">Date conflicts are blocked automatically, so your timeline stays reliable.</p>
            </article>
            <article class="premium-card motion-fade-up motion-delay-2">
                <div class="premium-pill">03</div>
                <h3 class="mt-5 font-display text-xl font-semibold text-stone-900">Clear financial tracking</h3>
                <p class="mt-2 text-sm leading-relaxed text-stone-600">Manage package selections and payment status from one secure screen.</p>
            </article>
        </div>
    </div>
</section>

<section class="mt-16 sm:mt-20">
    <div class="mx-auto grid max-w-7xl gap-8 px-4 sm:px-6 lg:grid-cols-2 lg:px-8">
        <article class="rounded-3xl border border-stone-200/90 bg-white p-7 shadow-soft motion-fade-up">
            <h3 class="font-display text-xl font-semibold text-stone-900">How couples use it in real life</h3>
            <ul class="mt-5 space-y-4 text-sm text-stone-600">
                <li class="timeline-item pl-5">Discover and compare verified vendors in one directory.</li>
                <li class="timeline-item pl-5">Reserve your preferred date without double-booking risks.</li>
                <li class="timeline-item pl-5">Track package and payment status in one clear place.</li>
                <li class="timeline-item pl-5">Collaborate with planners and keep decisions organized.</li>
            </ul>
        </article>
        <article class="overflow-hidden rounded-3xl bg-gradient-to-br from-rose-900 via-rose-800 to-amber-900 p-8 text-white shadow-card motion-fade-up motion-delay-1">
            <h3 class="font-display text-2xl font-semibold">Wedding-ready UI, business-ready engine</h3>
            <p class="mt-3 text-sm leading-relaxed text-rose-100/95">
                This is not a template-only page. Behind this interface are role-based access, validation, booking rules, and payment records built for real operation flows.
            </p>
            <div class="mt-8 flex flex-wrap gap-3">
                <a href="${ctx}/vendors" class="rounded-full bg-white px-6 py-3 text-sm font-semibold text-rose-900 hover:bg-amber-50">View vendors</a>
                <a href="${ctx}/bookings" class="rounded-full border border-white/45 bg-white/10 px-6 py-3 text-sm font-semibold text-white hover:bg-white/20">Manage bookings</a>
            </div>
        </article>
    </div>
</section>

<%@ include file="WEB-INF/jsp/includes/footer.jspf" %>
