CREATE DATABASE IF NOT EXISTS doctor_appointment_java;
USE doctor_appointment_java;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role ENUM('PATIENT','DOCTOR') NOT NULL,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(30) NOT NULL,
    city VARCHAR(80),
    password_hash VARCHAR(128) NOT NULL,
    salt VARCHAR(64) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS doctor_profiles (
    user_id INT PRIMARY KEY,
    hospital VARCHAR(150) NOT NULL,
    specialization VARCHAR(120) NOT NULL,
    education VARCHAR(255) NOT NULL,
    experience_years INT NOT NULL DEFAULT 0,
    consultation_fee DECIMAL(10,2) DEFAULT 0,
    bio TEXT,
    available_days VARCHAR(120),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS patient_profiles (
    user_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(30),
    blood_group VARCHAR(10),
    allergies VARCHAR(255),
    medical_history TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    disease_description VARCHAR(350) NOT NULL,
    preferred_date DATE NOT NULL,
    preferred_time TIME NOT NULL,
    status ENUM('PENDING','ACCEPTED','REJECTED') NOT NULL DEFAULT 'PENDING',
    alternative_date DATE NULL,
    alternative_time TIME NULL,
    doctor_note VARCHAR(350),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT NULL,
    title VARCHAR(150) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    stored_name VARCHAR(255) NOT NULL,
    doctor_message TEXT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    body TEXT NOT NULL,
    attachment_name VARCHAR(255),
    attachment_stored_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (role, name, email, phone, city, password_hash, salt)
VALUES
('DOCTOR','Dr. Asha Mehta','asha.mehta@example.com','9876543210','Mumbai','c14ccdbada476ac6c81c08c41c18273ef97f92d2550dea4d02590871cc281025','seed'),
('DOCTOR','Dr. Rohan Iyer','rohan.iyer@example.com','9876543211','Pune','c14ccdbada476ac6c81c08c41c18273ef97f92d2550dea4d02590871cc281025','seed'),
('DOCTOR','Dr. Neha Kapoor','neha.kapoor@example.com','9876543212','Delhi','c14ccdbada476ac6c81c08c41c18273ef97f92d2550dea4d02590871cc281025','seed')
ON DUPLICATE KEY UPDATE email = email;

INSERT INTO doctor_profiles (user_id, hospital, specialization, education, experience_years, consultation_fee, bio, available_days)
SELECT id, 'City Care Hospital', 'Cardiology', 'MBBS, MD Cardiology', 12, 900, 'Heart health specialist with preventive care focus.', 'Mon, Wed, Fri'
FROM users WHERE email = 'asha.mehta@example.com'
ON DUPLICATE KEY UPDATE user_id = user_id;

INSERT INTO doctor_profiles (user_id, hospital, specialization, education, experience_years, consultation_fee, bio, available_days)
SELECT id, 'Sunrise Multispeciality', 'Dermatology', 'MBBS, DDVL', 8, 700, 'Skin, hair, and allergy care for all age groups.', 'Tue, Thu, Sat'
FROM users WHERE email = 'rohan.iyer@example.com'
ON DUPLICATE KEY UPDATE user_id = user_id;

INSERT INTO doctor_profiles (user_id, hospital, specialization, education, experience_years, consultation_fee, bio, available_days)
SELECT id, 'Metro Health Institute', 'Neurology', 'MBBS, DM Neurology', 15, 1200, 'Neurology consultations and long-term patient follow-up.', 'Mon, Tue, Thu'
FROM users WHERE email = 'neha.kapoor@example.com'
ON DUPLICATE KEY UPDATE user_id = user_id;
