-- ============================================================
-- COMPLETE DATABASE MANAGEMENT SYSTEM
-- Project: Hospital Management System
-- Student Name: [Your Name Here]
-- Date: October 4, 2025
-- Description: A comprehensive database for managing hospital operations
--              including patients, doctors, appointments, medical records,
--              prescriptions, billing, and inventory management.
-- ============================================================

-- ============================================================
-- DATABASE CREATION
-- ============================================================
DROP DATABASE IF EXISTS HospitalManagementSystem;
CREATE DATABASE HospitalManagementSystem;
USE HospitalManagementSystem;

-- ============================================================
-- TABLE 1: Departments
-- Purpose: Store hospital departments information
-- Relationship: One-to-Many with Doctors
-- ============================================================
CREATE TABLE Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100) NOT NULL,
    HeadOfDepartment VARCHAR(100),
    PhoneNumber VARCHAR(15) UNIQUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE 2: Doctors
-- Purpose: Store doctor information
-- Relationship: Many-to-One with Departments
--              One-to-Many with Appointments
-- ============================================================
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(15) NOT NULL UNIQUE,
    LicenseNumber VARCHAR(50) NOT NULL UNIQUE,
    DepartmentID INT NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10, 2),
    Status ENUM('Active', 'On Leave', 'Resigned') DEFAULT 'Active',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================================
-- TABLE 3: Patients
-- Purpose: Store patient information
-- Relationship: One-to-Many with Appointments
--              One-to-Many with MedicalRecords
--              One-to-One with EmergencyContacts
-- ============================================================
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15) NOT NULL,
    Address TEXT NOT NULL,
    BloodGroup VARCHAR(5),
    InsuranceNumber VARCHAR(50) UNIQUE,
    RegisteredDate DATE DEFAULT (CURRENT_DATE),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dob CHECK (DateOfBirth < CURRENT_DATE)
);

-- ============================================================
-- TABLE 4: EmergencyContacts
-- Purpose: Store emergency contact for each patient
-- Relationship: One-to-One with Patients
-- ============================================================
CREATE TABLE EmergencyContacts (
    ContactID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL UNIQUE,
    ContactName VARCHAR(100) NOT NULL,
    Relationship VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    AlternatePhone VARCHAR(15),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- TABLE 5: Appointments
-- Purpose: Store appointment scheduling information
-- Relationship: Many-to-One with Patients
--              Many-to-One with Doctors
--              One-to-Many with MedicalRecords
-- ============================================================
CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Reason TEXT NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    Notes TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_future_appointment CHECK (AppointmentDate >= CURRENT_DATE)
);

-- ============================================================
-- TABLE 6: MedicalRecords
-- Purpose: Store patient medical history and diagnoses
-- Relationship: Many-to-One with Patients
--              Many-to-One with Appointments
--              One-to-Many with Prescriptions
-- ============================================================
CREATE TABLE MedicalRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    AppointmentID INT,
    Diagnosis TEXT NOT NULL,
    Symptoms TEXT,
    Treatment TEXT,
    TestsRecommended TEXT,
    RecordDate DATE DEFAULT (CURRENT_DATE),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- ============================================================
-- TABLE 7: Medications
-- Purpose: Store available medications in hospital pharmacy
-- Relationship: Many-to-Many with Prescriptions (through junction table)
-- ============================================================
CREATE TABLE Medications (
    MedicationID INT AUTO_INCREMENT PRIMARY KEY,
    MedicationName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    Manufacturer VARCHAR(100),
    UnitPrice DECIMAL(8, 2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    ExpiryDate DATE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_positive_price CHECK (UnitPrice > 0),
    CONSTRAINT chk_positive_stock CHECK (StockQuantity >= 0),
    CONSTRAINT chk_future_expiry CHECK (ExpiryDate > CURRENT_DATE)
);

-- ============================================================
-- TABLE 8: Prescriptions
-- Purpose: Store prescriptions given to patients
-- Relationship: Many-to-One with MedicalRecords
--              Many-to-Many with Medications (through PrescriptionDetails)
-- ============================================================
CREATE TABLE Prescriptions (
    PrescriptionID INT AUTO_INCREMENT PRIMARY KEY,
    RecordID INT NOT NULL,
    PrescriptionDate DATE DEFAULT (CURRENT_DATE),
    Instructions TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RecordID) REFERENCES MedicalRecords(RecordID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- TABLE 9: PrescriptionDetails (Junction Table)
-- Purpose: Many-to-Many relationship between Prescriptions and Medications
-- Relationship: Links Prescriptions with Medications
-- ============================================================
CREATE TABLE PrescriptionDetails (
    DetailID INT AUTO_INCREMENT PRIMARY KEY,
    PrescriptionID INT NOT NULL,
    MedicationID INT NOT NULL,
    Dosage VARCHAR(50) NOT NULL,
    Frequency VARCHAR(50) NOT NULL,
    Duration VARCHAR(50) NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (PrescriptionID) REFERENCES Prescriptions(PrescriptionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (MedicationID) REFERENCES Medications(MedicationID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_positive_quantity CHECK (Quantity > 0),
    UNIQUE KEY unique_prescription_medication (PrescriptionID, MedicationID)
);

-- ============================================================
-- TABLE 10: Billing
-- Purpose: Store billing and payment information
-- Relationship: Many-to-One with Patients
--              Many-to-One with Appointments
-- ============================================================
CREATE TABLE Billing (
    BillID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    AppointmentID INT,
    BillDate DATE DEFAULT (CURRENT_DATE),
    ConsultationFee DECIMAL(10, 2) DEFAULT 0,
    MedicationCost DECIMAL(10, 2) DEFAULT 0,
    TestCost DECIMAL(10, 2) DEFAULT 0,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    AmountPaid DECIMAL(10, 2) DEFAULT 0,
    PaymentStatus ENUM('Pending', 'Partial', 'Paid') DEFAULT 'Pending',
    PaymentMethod ENUM('Cash', 'Card', 'Insurance', 'Mobile Money') NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT chk_positive_amounts CHECK (
        ConsultationFee >= 0 AND 
        MedicationCost >= 0 AND 
        TestCost >= 0 AND 
        TotalAmount >= 0 AND 
        AmountPaid >= 0
    ),
    CONSTRAINT chk_paid_not_exceeds CHECK (AmountPaid <= TotalAmount)
);

-- ============================================================
-- TABLE 11: Staff
-- Purpose: Store non-doctor staff information (nurses, admin, etc.)
-- Relationship: Many-to-One with Departments
-- ============================================================
CREATE TABLE Staff (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(15) NOT NULL UNIQUE,
    DepartmentID INT NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10, 2),
    Status ENUM('Active', 'On Leave', 'Resigned') DEFAULT 'Active',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================================
-- TABLE 12: Rooms
-- Purpose: Store hospital room information
-- Relationship: One-to-Many with PatientAdmissions
-- ============================================================
CREATE TABLE Rooms (
    RoomID INT AUTO_INCREMENT PRIMARY KEY,
    RoomNumber VARCHAR(10) NOT NULL UNIQUE,
    RoomType ENUM('General', 'Private', 'ICU', 'Emergency') NOT NULL,
    Capacity INT NOT NULL,
    CurrentOccupancy INT DEFAULT 0,
    DailyRate DECIMAL(8, 2) NOT NULL,
    Status ENUM('Available', 'Occupied', 'Maintenance') DEFAULT 'Available',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_positive_capacity CHECK (Capacity > 0),
    CONSTRAINT chk_occupancy_limit CHECK (CurrentOccupancy <= Capacity),
    CONSTRAINT chk_positive_rate CHECK (DailyRate > 0)
);

-- ============================================================
-- TABLE 13: PatientAdmissions
-- Purpose: Track patient admissions to hospital rooms
-- Relationship: Many-to-One with Patients
--              Many-to-One with Rooms
--              Many-to-One with Doctors
-- ============================================================
CREATE TABLE PatientAdmissions (
    AdmissionID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    RoomID INT NOT NULL,
    DoctorID INT NOT NULL,
    AdmissionDate DATETIME NOT NULL,
    DischargeDate DATETIME,
    Reason TEXT NOT NULL,
    Status ENUM('Admitted', 'Discharged', 'Transferred') DEFAULT 'Admitted',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_discharge_after_admission CHECK (
        DischargeDate IS NULL OR DischargeDate > AdmissionDate
    )
);

-- ============================================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION
-- ============================================================
CREATE INDEX idx_patient_name ON Patients(LastName, FirstName);
CREATE INDEX idx_doctor_name ON Doctors(LastName, FirstName);
CREATE INDEX idx_appointment_date ON Appointments(AppointmentDate);
CREATE INDEX idx_appointment_status ON Appointments(Status);
CREATE INDEX idx_billing_status ON Billing(PaymentStatus);
CREATE INDEX idx_medication_expiry ON Medications(ExpiryDate);
CREATE INDEX idx_patient_email ON Patients(Email);
CREATE INDEX idx_doctor_email ON Doctors(Email);

-- ============================================================
-- SUMMARY OF RELATIONSHIPS
-- ============================================================
/*
ONE-TO-ONE RELATIONSHIPS:
1. Patients ↔ EmergencyContacts (One patient has one emergency contact)

ONE-TO-MANY RELATIONSHIPS:
1. Departments → Doctors (One department has many doctors)
2. Departments → Staff (One department has many staff members)
3. Doctors → Appointments (One doctor has many appointments)
4. Patients → Appointments (One patient has many appointments)
5. Patients → MedicalRecords (One patient has many medical records)
6. Appointments → MedicalRecords (One appointment can have many records)
7. MedicalRecords → Prescriptions (One record can have many prescriptions)
8. Patients → Billing (One patient has many bills)
9. Rooms → PatientAdmissions (One room has many admissions over time)

MANY-TO-MANY RELATIONSHIPS:
1. Prescriptions ↔ Medications (through PrescriptionDetails junction table)
   - One prescription can contain many medications
   - One medication can be in many prescriptions

CONSTRAINTS USED:
- PRIMARY KEY: Unique identifier for each table
- FOREIGN KEY: Maintains referential integrity
- NOT NULL: Ensures required fields are filled
- UNIQUE: Prevents duplicate values
- CHECK: Validates data ranges and logic
- ENUM: Restricts values to predefined options
- DEFAULT: Sets default values
- ON DELETE CASCADE: Automatically deletes related records
- ON DELETE RESTRICT: Prevents deletion if related records exist
- ON DELETE SET NULL: Sets foreign key to NULL on deletion

BUSINESS RULES IMPLEMENTED:
1. Doctors cannot be deleted if they have active appointments
2. Patients are automatically removed from emergency contacts if deleted
3. Appointments must be scheduled for current or future dates
4. Medication expiry dates must be in the future
5. Room occupancy cannot exceed capacity
6. Payment amounts cannot exceed total bill amount
7. Discharge date must be after admission date
*/
