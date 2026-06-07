package com.healthconnect.dao;

import com.healthconnect.config.Database;

import java.sql.*;
import java.util.*;

public class PortalDao {
    public List<Map<String, Object>> searchDoctors(String city, String hospital, String specialization) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT u.id,u.name,u.email,u.phone,u.city,d.* FROM users u JOIN doctor_profiles d ON u.id=d.user_id WHERE u.role='DOCTOR'");
        List<String> args = new ArrayList<>();
        if (city != null && !city.isBlank()) { sql.append(" AND u.city LIKE ?"); args.add("%" + city + "%"); }
        if (hospital != null && !hospital.isBlank()) { sql.append(" AND d.hospital LIKE ?"); args.add("%" + hospital + "%"); }
        if (specialization != null && !specialization.isBlank()) { sql.append(" AND d.specialization LIKE ?"); args.add("%" + specialization + "%"); }
        sql.append(" ORDER BY d.experience_years DESC, u.name");
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < args.size(); i++) ps.setString(i + 1, args.get(i));
            return rows(ps);
        }
    }

    public void upsertDoctorProfile(int userId, String hospital, String specialization, String education, int experience, String fee, String bio, String days) throws SQLException {
        String sql = "INSERT INTO doctor_profiles(user_id,hospital,specialization,education,experience_years,consultation_fee,bio,available_days) VALUES(?,?,?,?,?,?,?,?) " +
                "ON DUPLICATE KEY UPDATE hospital=VALUES(hospital),specialization=VALUES(specialization),education=VALUES(education),experience_years=VALUES(experience_years),consultation_fee=VALUES(consultation_fee),bio=VALUES(bio),available_days=VALUES(available_days)";
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, hospital);
            ps.setString(3, specialization);
            ps.setString(4, education);
            ps.setInt(5, experience);
            ps.setBigDecimal(6, new java.math.BigDecimal(fee == null || fee.isBlank() ? "0" : fee));
            ps.setString(7, bio);
            ps.setString(8, days);
            ps.executeUpdate();
        }
    }

    public void upsertPatientProfile(int userId, String age, String gender, String bloodGroup, String allergies, String history) throws SQLException {
        String sql = "INSERT INTO patient_profiles(user_id,age,gender,blood_group,allergies,medical_history) VALUES(?,?,?,?,?,?) " +
                "ON DUPLICATE KEY UPDATE age=VALUES(age),gender=VALUES(gender),blood_group=VALUES(blood_group),allergies=VALUES(allergies),medical_history=VALUES(medical_history)";
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (age == null || age.isBlank()) ps.setNull(2, Types.INTEGER); else ps.setInt(2, Integer.parseInt(age));
            ps.setString(3, gender);
            ps.setString(4, bloodGroup);
            ps.setString(5, allergies);
            ps.setString(6, history);
            ps.executeUpdate();
        }
    }

    public void requestAppointment(int patientId, int doctorId, String disease, String date, String time) throws SQLException {
        String sql = "INSERT INTO appointments(patient_id,doctor_id,disease_description,preferred_date,preferred_time) VALUES(?,?,?,?,?)";
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ps.setInt(2, doctorId);
            ps.setString(3, disease);
            ps.setDate(4, java.sql.Date.valueOf(date));
            ps.setTime(5, java.sql.Time.valueOf(time + ":00"));
            ps.executeUpdate();
        }
    }

    public void updateAppointmentStatus(int appointmentId, int doctorId, String status, String altDate, String altTime, String note) throws SQLException {
        String sql = "UPDATE appointments SET status=?, alternative_date=?, alternative_time=?, doctor_note=? WHERE id=? AND doctor_id=?";
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            if (altDate == null || altDate.isBlank()) ps.setNull(2, Types.DATE); else ps.setDate(2, java.sql.Date.valueOf(altDate));
            if (altTime == null || altTime.isBlank()) ps.setNull(3, Types.TIME); else ps.setTime(3, java.sql.Time.valueOf(altTime + ":00"));
            ps.setString(4, note);
            ps.setInt(5, appointmentId);
            ps.setInt(6, doctorId);
            ps.executeUpdate();
        }
    }

    public void saveReport(int patientId, int doctorId, String title, String fileName, String storedName, String message) throws SQLException {
        String sql = "INSERT INTO reports(patient_id,doctor_id,title,file_name,stored_name,doctor_message) VALUES(?,?,?,?,?,?)";
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ps.setInt(2, doctorId);
            ps.setString(3, title);
            ps.setString(4, fileName);
            ps.setString(5, storedName);
            ps.setString(6, message);
            ps.executeUpdate();
        }
    }

    public void sendMessage(int senderId, int receiverId, String body, String fileName, String storedName) throws SQLException {
        String sql = "INSERT INTO messages(sender_id,receiver_id,body,attachment_name,attachment_stored_name) VALUES(?,?,?,?,?)";
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            ps.setString(3, body);
            ps.setString(4, fileName);
            ps.setString(5, storedName);
            ps.executeUpdate();
        }
    }

    public List<Map<String, Object>> patientAppointments(int patientId) throws SQLException {
        String sql = "SELECT a.*, u.name doctor_name, u.city doctor_city, d.hospital, d.specialization FROM appointments a JOIN users u ON a.doctor_id=u.id JOIN doctor_profiles d ON d.user_id=u.id WHERE a.patient_id=? ORDER BY a.created_at DESC";
        return queryOneInt(sql, patientId);
    }

    public List<Map<String, Object>> doctorAppointments(int doctorId) throws SQLException {
        String sql = "SELECT a.*, u.name patient_name, u.email patient_email, p.medical_history FROM appointments a JOIN users u ON a.patient_id=u.id LEFT JOIN patient_profiles p ON p.user_id=u.id WHERE a.doctor_id=? ORDER BY a.created_at DESC";
        return queryOneInt(sql, doctorId);
    }

    public List<Map<String, Object>> reportsForPatient(int patientId) throws SQLException {
        String sql = "SELECT r.*, u.name doctor_name FROM reports r JOIN users u ON r.doctor_id=u.id WHERE r.patient_id=? ORDER BY r.uploaded_at DESC";
        return queryOneInt(sql, patientId);
    }

    public List<Map<String, Object>> messagesForUser(int userId) throws SQLException {
        String sql = "SELECT m.*, s.name sender_name, r.name receiver_name FROM messages m JOIN users s ON m.sender_id=s.id JOIN users r ON m.receiver_id=r.id WHERE sender_id=? OR receiver_id=? ORDER BY m.created_at DESC";
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            return rows(ps);
        }
    }

    public List<Map<String, Object>> patientsForDoctor(int doctorId) throws SQLException {
        String sql = "SELECT DISTINCT u.id,u.name,u.email,u.phone,u.city,p.age,p.gender,p.blood_group,p.allergies,p.medical_history FROM appointments a JOIN users u ON a.patient_id=u.id LEFT JOIN patient_profiles p ON p.user_id=u.id WHERE a.doctor_id=? ORDER BY u.name";
        return queryOneInt(sql, doctorId);
    }

    private List<Map<String, Object>> queryOneInt(String sql, int value) throws SQLException {
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, value);
            return rows(ps);
        }
    }

    private List<Map<String, Object>> rows(PreparedStatement ps) throws SQLException {
        try (ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> list = new ArrayList<>();
            ResultSetMetaData meta = rs.getMetaData();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= meta.getColumnCount(); i++) row.put(meta.getColumnLabel(i), rs.getObject(i));
                list.add(row);
            }
            return list;
        }
    }
}
