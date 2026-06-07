<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Contact | HealthConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="page-bg">
<nav class="nav">
    <a class="brand" href="${pageContext.request.contextPath}/">HealthConnect</a>
    <div><a href="${pageContext.request.contextPath}/about">About</a><a href="${pageContext.request.contextPath}/login">Login</a></div>
</nav>
<main class="content-page contact">
    <h1>Contact</h1>
    <p>Need help with appointments, doctor onboarding, or patient report access? Send a message to the support desk.</p>
    <form class="panel">
        <label>Name<input required placeholder="Your name"></label>
        <label>Email<input type="email" required placeholder="you@example.com"></label>
        <label>Message<textarea required rows="5" placeholder="How can we help?"></textarea></label>
        <button class="btn" type="submit">Send Message</button>
    </form>
</main>
</body>
</html>
