<%@ page import="java.util.*" %>
<%@ page import="com.healthconnect.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    List<Map<String,Object>> appointments = (List<Map<String,Object>>) request.getAttribute("appointments");
    List<Map<String,Object>> patients = (List<Map<String,Object>>) request.getAttribute("patients");
    List<Map<String,Object>> messages = (List<Map<String,Object>>) request.getAttribute("messages");
%>
<html>
<head>
    <title>Doctor Dashboard | HealthConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="dashboard-bg doctor">
<nav class="nav">
    <a class="brand" href="${pageContext.request.contextPath}/">HealthConnect</a>
    <div><span><%= user.getName() %></span><a href="${pageContext.request.contextPath}/logout">Logout</a></div>
</nav>
<main class="dashboard">
    <header class="dash-head"><h1>Doctor Dashboard</h1><p>Manage your profile, appointment requests, patient history, and shared files.</p></header>
    <section class="grid two">
        <article class="panel">
            <h2>Edit Doctor Profile</h2>
            <form action="${pageContext.request.contextPath}/profile/doctor" method="post" class="mini-form">
                <div class="grid two">
                    <input name="hospital" placeholder="Hospital" required><input name="specialization" placeholder="Specialization" required>
                    <input name="education" placeholder="Education" required><input name="experience" type="number" min="0" placeholder="Experience">
                    <input name="fee" type="number" step="0.01" placeholder="Fee"><input name="days" placeholder="Available days">
                </div>
                <textarea name="bio" rows="3" placeholder="Profile bio"></textarea>
                <button class="btn small">Save Profile</button>
            </form>
        </article>
        <article class="panel">
            <h2>Send Message or File</h2>
            <form action="${pageContext.request.contextPath}/message/send" method="post" enctype="multipart/form-data" class="mini-form">
                <select name="receiverId" required>
                    <option value="">Select patient</option>
                    <% for (Map<String,Object> p : patients) { %><option value="<%= p.get("id") %>"><%= p.get("name") %></option><% } %>
                </select>
                <textarea name="body" rows="3" required placeholder="Message to patient"></textarea>
                <input type="file" name="attachment">
                <button class="btn small">Send</button>
            </form>
        </article>
    </section>
    <section class="panel">
        <h2>Appointment Requests</h2>
        <div class="request-list">
            <% if (appointments.isEmpty()) { %><p class="muted">No appointment requests yet.</p><% } %>
            <% for (Map<String,Object> a : appointments) { %>
            <article class="request-card">
                <div>
                    <h3><%= a.get("patient_name") %> <span class="status"><%= a.get("status") %></span></h3>
                    <p><%= a.get("disease_description") %></p>
                    <p><strong>Preferred:</strong> <%= a.get("preferred_date") %> at <%= a.get("preferred_time") %></p>
                    <p class="muted">History: <%= a.get("medical_history") == null ? "Not updated" : a.get("medical_history") %></p>
                </div>
                <form action="${pageContext.request.contextPath}/appointment/status" method="post" class="mini-form status-form">
                    <input type="hidden" name="appointmentId" value="<%= a.get("id") %>">
                    <select name="status"><option>ACCEPTED</option><option>REJECTED</option></select>
                    <div class="grid two"><input type="date" name="altDate"><input type="time" name="altTime"></div>
                    <input name="note" placeholder="Note or alternative suggestion">
                    <button class="btn small">Update</button>
                </form>
            </article>
            <% } %>
        </div>
    </section>
    <section class="grid two">
        <article class="panel">
            <h2>Patient Profiles</h2>
            <%= table(patients, new String[]{"name","email","phone","city","age","gender","blood_group","allergies","medical_history"}) %>
        </article>
        <article class="panel">
            <h2>Upload Report</h2>
            <form action="${pageContext.request.contextPath}/report/upload" method="post" enctype="multipart/form-data" class="mini-form">
                <select name="patientId" required>
                    <option value="">Select patient</option>
                    <% for (Map<String,Object> p : patients) { %><option value="<%= p.get("id") %>"><%= p.get("name") %></option><% } %>
                </select>
                <input name="title" required placeholder="Report title">
                <input type="file" name="report" required>
                <textarea name="message" rows="3" placeholder="Instructions for patient"></textarea>
                <button class="btn small">Upload Report</button>
            </form>
            <h2>Messages</h2>
            <%= table(messages, new String[]{"sender_name","receiver_name","body","attachment_name","created_at"}) %>
        </article>
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
