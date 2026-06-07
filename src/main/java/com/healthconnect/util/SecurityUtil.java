package com.healthconnect.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;

public final class SecurityUtil {
    private static final SecureRandom RANDOM = new SecureRandom();

    private SecurityUtil() {
    }

    public static String newSalt() {
        byte[] bytes = new byte[16];
        RANDOM.nextBytes(bytes);
        return toHex(bytes);
    }

    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest((salt + password).getBytes(StandardCharsets.UTF_8));
            return toHex(hash);
        } catch (Exception ex) {
            throw new IllegalStateException("Could not hash password", ex);
        }
    }

    public static boolean isValidReportType(String fileName) {
        String lower = fileName.toLowerCase();
        return lower.endsWith(".pdf") || lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".docx");
    }

    public static String cleanFileName(String fileName) {
        return fileName == null ? "file" : fileName.replaceAll("[^A-Za-z0-9._-]", "_");
    }

    private static String toHex(byte[] bytes) {
        StringBuilder out = new StringBuilder(bytes.length * 2);
        for (byte value : bytes) out.append(String.format("%02x", value));
        return out.toString();
    }
}
