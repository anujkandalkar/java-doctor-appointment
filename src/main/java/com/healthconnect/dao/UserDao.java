package com.healthconnect.dao;

import com.healthconnect.config.Database;
import com.healthconnect.model.User;
import com.healthconnect.util.SecurityUtil;

import java.sql.*;

public class UserDao {
    public User create(String role, String name, String email, String phone, String city, String password) throws SQLException {
        String salt = SecurityUtil.newSalt();
        String sql = "INSERT INTO users(role,name,email,phone,city,password_hash,salt) VALUES(?,?,?,?,?,?,?)";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, role);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, city);
            ps.setString(6, SecurityUtil.hashPassword(password, salt));
            ps.setString(7, salt);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return findById(keys.getInt(1));
            }
        }
    }

    public User login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email=?";
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                String expected = rs.getString("password_hash");
                String actual = SecurityUtil.hashPassword(password, rs.getString("salt"));
                return expected.equals(actual) ? map(rs) : null;
            }
        }
    }

    public User findById(int id) throws SQLException {
        try (Connection con = Database.getConnection(); PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    private User map(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setRole(rs.getString("role"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setCity(rs.getString("city"));
        return user;
    }
}
