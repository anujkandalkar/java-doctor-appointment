<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Login | HealthConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="auth-bg">
<main class="auth-shell">
    <section class="auth-art">
        <a class="brand" href="${pageContext.request.contextPath}/">HealthConnect</a>
        <h1>Welcome back</h1>
        <p>Continue to your patient or doctor dashboard.</p>
    </section>
    <form class="auth-card" action="${pageContext.request.contextPath}/login" method="post">
        <h2>Login</h2>
        <% if (request.getAttribute("error") != null) { %><p class="alert"><%= request.getAttribute("error") %></p><% } %>
        <label>Email<input type="email" name="email" required></label>
        <label>Password<input type="password" name="password" required></label>
        <button class="btn" type="submit">Login</button>
        <p>New here? <a href="${pageContext.request.contextPath}/register">Create an account</a></p>
    </form>
</main>
</body>
</html>
