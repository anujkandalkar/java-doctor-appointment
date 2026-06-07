<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String selectedRole = request.getParameter("role") == null ? "PATIENT" : request.getParameter("role");
%>
<html>
<head>
    <title>Register | HealthConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script defer src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</head>
<body class="auth-bg">
<main class="auth-shell wide">
    <section class="auth-art">
        <a class="brand" href="${pageContext.request.contextPath}/">HealthConnect</a>
        <h1>Create your account</h1>
        <p>Choose patient or doctor and complete the profile details needed for appointments.</p>
    </section>
    <form class="auth-card" action="${pageContext.request.contextPath}/register" method="post">
        <h2>Registration</h2>
        <label>Role
            <select name="role" id="roleSelect">
                <option value="PATIENT" <%= "PATIENT".equals(selectedRole) ? "selected" : "" %>>Patient</option>
                <option value="DOCTOR" <%= "DOCTOR".equals(selectedRole) ? "selected" : "" %>>Doctor</option>
            </select>
        </label>
        <div class="grid two">
            <label>Name<input name="name" required></label>
            <label>Email<input type="email" name="email" required></label>
            <label>Phone<input name="phone" required></label>
            <label>City<input name="city" required></label>
            <label>Password<input type="password" name="password" minlength="8" required></label>
        </div>
        <div id="patientFields">
            <div class="grid two">
                <label>Age<input type="number" name="age" min="1"></label>
                <label>Gender<input name="gender"></label>
                <label>Blood Group<input name="bloodGroup"></label>
                <label>Allergies<input name="allergies"></label>
            </div>
            <label>Previous Medical History<textarea name="history" rows="3"></textarea></label>
        </div>
        <div id="doctorFields">
            <div class="grid two">
                <label>Hospital<input name="hospital"></label>
                <label>Specialization<input name="specialization"></label>
                <label>Education<input name="education"></label>
                <label>Experience Years<input type="number" name="experience" min="0"></label>
                <label>Consultation Fee<input name="fee" type="number" min="0" step="0.01"></label>
                <label>Available Days<input name="days" placeholder="Mon, Wed, Fri"></label>
            </div>
            <label>Professional Bio<textarea name="bio" rows="3"></textarea></label>
        </div>
        <button class="btn" type="submit">Create Account</button>
        <p>Already registered? <a href="${pageContext.request.contextPath}/login">Login</a></p>
    </form>
</main>
</body>
</html>
