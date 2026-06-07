<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>HealthConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<nav class="nav">
    <a class="brand" href="${pageContext.request.contextPath}/">HealthConnect</a>
    <div>
        <a href="${pageContext.request.contextPath}/about">About</a>
        <a href="${pageContext.request.contextPath}/contact">Contact</a>
        <a href="${pageContext.request.contextPath}/login">Login</a>
        <a class="btn small" href="${pageContext.request.contextPath}/register">Register</a>
    </div>
</nav>
<main class="hero">
    <section class="hero-copy">
        <p class="eyebrow">Patient-Doctor Appointment Management</p>
        <h1>Find the right doctor, request care, and keep your medical updates in one secure place.</h1>
        <p>Patients can search by city, hospital, and specialization. Doctors can manage requests, review patient history, suggest alternate timings, and share reports or messages.</p>
        <div class="actions">
            <a class="btn" href="${pageContext.request.contextPath}/register?role=PATIENT">Patient Registration</a>
            <a class="btn ghost" href="${pageContext.request.contextPath}/register?role=DOCTOR">Doctor Registration</a>
        </div>
    </section>
</main>
<section class="feature-band">
    <article><h3>Smart Search</h3><p>Filter doctors by city, hospital, specialization, experience, and availability.</p></article>
    <article><h3>Live Requests</h3><p>Track pending, accepted, and rejected appointments with doctor suggestions.</p></article>
    <article><h3>Medical Files</h3><p>Doctors can share reports and notes while patients keep their history visible.</p></article>
</section>
</body>
</html>
