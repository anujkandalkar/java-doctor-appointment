<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>About | HealthConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="page-bg">
<nav class="nav">
    <a class="brand" href="${pageContext.request.contextPath}/">HealthConnect</a>
    <div><a href="${pageContext.request.contextPath}/contact">Contact</a><a href="${pageContext.request.contextPath}/login">Login</a></div>
</nav>
<main class="content-page">
    <h1>About HealthConnect</h1>
    <p>HealthConnect is a Java Servlet and JDBC based appointment portal that connects patients with doctors while maintaining appointment history, messages, and report sharing.</p>
    <div class="grid three">
        <article class="card"><h3>For Patients</h3><p>Register, describe symptoms in 20-30 words, search doctors, request appointments, and view medical reports.</p></article>
        <article class="card"><h3>For Doctors</h3><p>Manage profiles, accept or reject requests, suggest alternative timings, and review patient medical history.</p></article>
        <article class="card"><h3>Security</h3><p>Prepared statements, protected dashboards, hashed passwords, validated uploads, and role-aware access flows.</p></article>
    </div>
</main>
</body>
</html>
