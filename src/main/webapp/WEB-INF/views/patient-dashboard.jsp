<%@ page import="java.util.*" %>
<%@ page import="com.healthconnect.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    List<Map<String,Object>> doctors = (List<Map<String,Object>>) request.getAttribute("doctors");
    List<Map<String,Object>> appointments = (List<Map<String,Object>>) request.getAttribute("appointments");
    List<Map<String,Object>> reports = (List<Map<String,Object>>) request.getAttribute("reports");
    List<Map<String,Object>> messages = (List<Map<String,Object>>) request.getAttribute("messages");
%>
<html>
<head>
    <title>Patient Dashboard | HealthConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script defer src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</head>
<body class="dashboard-bg">
<nav class="nav">
    <a class="brand" href="${pageContext.request.contextPath}/">HealthConnect</a>
    <div><span><%= user.getName() %></span><a href="${pageContext.request.contextPath}/logout">Logout</a></div>
</nav>
<main class="dashboard">
    <header class="dash-head"><h1>Patient Dashboard</h1><p>Search doctors, request appointments, and follow your care updates.</p></header>
    <section class="panel">
        <h2>Search Doctors</h2>
        <form class="filters" method="get">
            <input name="city" placeholder="City" value="<%= request.getParameter("city") == null ? "" : request.getParameter("city") %>">
            <input name="hospital" placeholder="Hospital" value="<%= request.getParameter("hospital") == null ? "" : request.getParameter("hospital") %>">
            <input name="specialization" placeholder="Specialization" value="<%= request.getParameter("specialization") == null ? "" : request.getParameter("specialization") %>">
            <button class="btn small" type="submit">Search</button>
        </form>
        <div class="grid three">
            <% for (Map<String,Object> d : doctors) { %>
            <article class="doctor-card">
                <h3><%= d.get("name") %></h3>
                <p><strong><%= d.get("specialization") %></strong> at <%= d.get("hospital") %></p>
                <p><%= d.get("education") %> · <%= d.get("experience_years") %> years · <%= d.get("city") %></p>
                <p><%= d.get("bio") %></p>
                <form action="${pageContext.request.contextPath}/appointment/request" method="post" class="mini-form">
                    <input type="hidden" name="doctorId" value="<%= d.get("user_id") %>">
                    <textarea name="disease" rows="3" minlength="80" maxlength="350" required placeholder="Disease description in 20-30 words"></textarea>
                    <div class="grid two"><input type="date" name="date" required><input type="time" name="time" required></div>
                    <button class="btn small" type="submit">Request Appointment</button>
                </form>
            </article>
            <% } %>
        </div>
    </section>
    <section class="grid two">
        <article class="panel"><h2>Appointment Notifications</h2><%= table(appointments, new String[]{"doctor_name","hospital","preferred_date","preferred_time","status","alternative_date","alternative_time","doctor_note"}) %></article>
        <article class="panel"><h2>My Profile</h2>
            <form action="${pageContext.request.contextPath}/profile/patient" method="post" class="mini-form">
                <div class="grid two"><input name="age" placeholder="Age"><input name="gender" placeholder="Gender"><input name="bloodGroup" placeholder="Blood group"><input name="allergies" placeholder="Allergies"></div>
                <textarea name="history" rows="4" placeholder="Previous medical history"></textarea>
                <button class="btn small">Update Profile</button>
            </form>
        </article>
    </section>
    <section class="grid two">
        <article class="panel"><h2>Previous Reports</h2><%= table(reports, new String[]{"title","doctor_name","file_name","doctor_message","uploaded_at"}) %></article>
        <article class="panel"><h2>Messages & Files</h2><%= table(messages, new String[]{"sender_name","receiver_name","body","attachment_name","created_at"}) %></article>
    </section>
</main>
</body>
</html>
<%!
    String table(List<Map<String,Object>> rows, String[] keys) {
        if (rows == null || rows.isEmpty()) return "<p class='muted'>No records yet.</p>";
        StringBuilder out = new StringBuilder("<div class='table-wrap'><table><thead><tr>");
        for (String key : keys) out.append("<th>").append(key.replace("_", " ")).append("</th>");
        out.append("</tr></thead><tbody>");
        for (Map<String,Object> row : rows) {
            out.append("<tr>");
            for (String key : keys) out.append("<td>").append(row.get(key) == null ? "" : row.get(key)).append("</td>");
            out.append("</tr>");
        }
        return out.append("</tbody></table></div>").toString();
    }
%>
