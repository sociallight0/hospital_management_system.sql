# 🏥 Hospital Management System Database

A comprehensive relational database management system designed for modern healthcare facilities to efficiently manage patients, doctors, appointments, medical records, prescriptions, billing, and hospital operations.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Database Schema](#database-schema)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Installation](#installation)
- [Usage](#usage)
- [Tables Description](#tables-description)
- [Relationships](#relationships)
- [Sample Queries](#sample-queries)
- [Security Features](#security-features)
- [Future Enhancements](#future-enhancements)
- [Contributors](#contributors)
- [License](#license)

---

## 🎯 Overview

The Hospital Management System Database is a robust, scalable solution designed to handle the complex data management needs of healthcare facilities. It provides a normalized database structure that ensures data integrity, reduces redundancy, and optimizes query performance.

### Key Objectives:
- Streamline hospital operations and data management
- Maintain patient medical records securely
- Track appointments and doctor schedules
- Manage medication inventory and prescriptions
- Handle billing and payment processing
- Monitor room availability and patient admissions

---

## ✨ Features

### Core Functionalities:
- ✅ **Patient Management** - Comprehensive patient profiles with emergency contacts
- ✅ **Doctor Management** - Doctor credentials, specializations, and departmental assignments
- ✅ **Appointment Scheduling** - Book, track, and manage patient appointments
- ✅ **Medical Records** - Digital storage of diagnoses, treatments, and medical history
- ✅ **Prescription System** - Electronic prescription management with medication tracking
- ✅ **Billing & Payments** - Complete billing system with multiple payment methods
- ✅ **Inventory Management** - Track medication stock and expiry dates
- ✅ **Room Management** - Monitor room availability and occupancy
- ✅ **Patient Admissions** - Track inpatient admissions and discharges
- ✅ **Staff Management** - Manage non-doctor hospital staff

### Technical Features:
- Fully normalized database (3NF compliant)
- Referential integrity through foreign keys
- Data validation using CHECK constraints
- Performance optimization with strategic indexes
- Automated timestamp tracking
- Cascading operations for data consistency

---

## 🗂️ Database Schema

The database consists of **13 interconnected tables** organized into the following modules:

### Module 1: Personnel Management
- `Departments` - Hospital departments and locations
- `Doctors` - Doctor profiles and credentials
- `Staff` - Non-doctor staff members

### Module 2: Patient Care
- `Patients` - Patient information and demographics
- `EmergencyContacts` - Emergency contact details
- `Appointments` - Appointment scheduling

### Module 3: Medical Records
- `MedicalRecords` - Patient diagnoses and treatments
- `Prescriptions` - Prescription information
- `Medications` - Available medications
- `PrescriptionDetails` - Prescription-medication junction table

### Module 4: Financial Management
- `Billing` - Billing and payment tracking

### Module 5: Facility Management
- `Rooms` - Hospital room information
- `PatientAdmissions` - Patient admission records

---

## 📊 Entity Relationship Diagram

### Relationship Types:

**One-to-One (1:1)**
```
Patients ←→ EmergencyContacts
```

**One-to-Many (1:N)**
```
Departments → Doctors
Departments → Staff
Doctors → Appointments
Patients → Appointments
Patients → MedicalRecords
Patients → Billing
Appointments → MedicalRecords
MedicalRecords → Prescriptions
Rooms → PatientAdmissions
```

**Many-to-Many (M:N)**
```
Prescriptions ←→ Medications (via PrescriptionDetails)
```

---

## 🚀 Installation

### Prerequisites:
- MySQL Server 8.0 or higher
- MySQL Workbench (recommended) or any MySQL client
- Minimum 100MB free disk space

### Installation Steps:

1. **Clone or Download the Repository**
   ```bash
   git clone [repository-url]
   cd hospital-management-system
   ```

2. **Open MySQL Workbench**
   - Launch MySQL Workbench
   - Connect to your MySQL server

3. **Import the Database**
   - Open the `hospital_management_system.sql` file
   - Click on the "Execute" button (⚡ icon) or press `Ctrl+Shift+Enter`
   - Wait for all statements to complete

4. **Verify Installation**
   ```sql
   USE HospitalManagementSystem;
   SHOW TABLES;
   ```
   You should see 13 tables listed.

5. **Optional: Load Sample Data**
   - If provided, run the `sample_data.sql` file to populate the database with test data

---

## 💻 Usage

### Basic Operations:

#### 1. Register a New Patient
```sql
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, PhoneNumber, Address, BloodGroup)
VALUES ('John', 'Doe', '1990-05-15', 'Male', '0712345678', '123 Main St, Nairobi', 'O+');
```

#### 2. Schedule an Appointment
```sql
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Reason)
VALUES (1, 1, '2025-10-10', '10:00:00', 'Regular checkup');
```

#### 3. Create a Medical Record
```sql
INSERT INTO MedicalRecords (PatientID, AppointmentID, Diagnosis, Treatment)
VALUES (1, 1, 'Common cold', 'Rest and fluids recommended');
```

#### 4. Generate a Bill
```sql
INSERT INTO Billing (PatientID, AppointmentID, ConsultationFee, TotalAmount)
VALUES (1, 1, 2000.00, 2000.00);
```

---

## 📚 Tables Description

### 1. Departments
Stores hospital department information.
- **Primary Key:** DepartmentID
- **Unique Constraints:** DepartmentName, PhoneNumber

### 2. Doctors
Stores doctor profiles and credentials.
- **Primary Key:** DoctorID
- **Foreign Key:** DepartmentID → Departments
- **Unique Constraints:** Email, PhoneNumber, LicenseNumber

### 3. Patients
Stores patient demographic and contact information.
- **Primary Key:** PatientID
- **Unique Constraints:** Email, InsuranceNumber
- **Check Constraint:** DateOfBirth must be in the past

### 4. EmergencyContacts
Stores emergency contact for each patient (1:1 relationship).
- **Primary Key:** ContactID
- **Foreign Key:** PatientID → Patients (UNIQUE)
- **Cascade:** ON DELETE CASCADE

### 5. Appointments
Manages appointment scheduling between patients and doctors.
- **Primary Key:** AppointmentID
- **Foreign Keys:** PatientID → Patients, DoctorID → Doctors
- **Check Constraint:** Appointment date must be current or future

### 6. MedicalRecords
Stores patient medical history and diagnoses.
- **Primary Key:** RecordID
- **Foreign Keys:** PatientID → Patients, AppointmentID → Appointments

### 7. Medications
Inventory of available medications.
- **Primary Key:** MedicationID
- **Unique Constraint:** MedicationName
- **Check Constraints:** Positive price, positive stock, future expiry date

### 8. Prescriptions
Stores prescription information.
- **Primary Key:** PrescriptionID
- **Foreign Key:** RecordID → MedicalRecords

### 9. PrescriptionDetails
Junction table linking prescriptions to medications (M:N relationship).
- **Primary Key:** DetailID
- **Foreign Keys:** PrescriptionID → Prescriptions, MedicationID → Medications
- **Unique Constraint:** (PrescriptionID, MedicationID)

### 10. Billing
Manages billing and payment information.
- **Primary Key:** BillID
- **Foreign Keys:** PatientID → Patients, AppointmentID → Appointments
- **Check Constraints:** Positive amounts, paid amount ≤ total amount

### 11. Staff
Stores non-doctor hospital staff information.
- **Primary Key:** StaffID
- **Foreign Key:** DepartmentID → Departments
- **Unique Constraints:** Email, PhoneNumber

### 12. Rooms
Manages hospital room inventory.
- **Primary Key:** RoomID
- **Unique Constraint:** RoomNumber
- **Check Constraints:** Positive capacity, occupancy ≤ capacity, positive rate

### 13. PatientAdmissions
Tracks patient admissions to hospital rooms.
- **Primary Key:** AdmissionID
- **Foreign Keys:** PatientID → Patients, RoomID → Rooms, DoctorID → Doctors
- **Check Constraint:** Discharge date > admission date

---

## 🔗 Relationships

### One-to-One Relationships:
| Parent Table | Child Table | Description |
|--------------|-------------|-------------|
| Patients | EmergencyContacts | Each patient has one emergency contact |

### One-to-Many Relationships:
| Parent Table | Child Table | Description |
|--------------|-------------|-------------|
| Departments | Doctors | One department has many doctors |
| Departments | Staff | One department has many staff members |
| Doctors | Appointments | One doctor has many appointments |
| Patients | Appointments | One patient has many appointments |
| Patients | MedicalRecords | One patient has many medical records |
| Patients | Billing | One patient has many bills |
| Appointments | MedicalRecords | One appointment can generate multiple records |
| MedicalRecords | Prescriptions | One record can have many prescriptions |
| Rooms | PatientAdmissions | One room has many admissions over time |

### Many-to-Many Relationships:
| Table 1 | Junction Table | Table 2 | Description |
|---------|----------------|---------|-------------|
| Prescriptions | PrescriptionDetails | Medications | One prescription contains many medications; one medication appears in many prescriptions |

---

## 🔍 Sample Queries

### Query 1: Get All Appointments for a Specific Doctor
```sql
SELECT 
    a.AppointmentID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    a.AppointmentDate,
    a.AppointmentTime,
    a.Status,
    a.Reason
FROM Appointments a
INNER JOIN Patients p ON a.PatientID = p.PatientID
INNER JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE d.DoctorID = 1
ORDER BY a.AppointmentDate, a.AppointmentTime;
```

### Query 2: Get Patient Medical History
```sql
SELECT 
    mr.RecordDate,
    mr.Diagnosis,
    mr.Treatment,
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    d.Specialization
FROM MedicalRecords mr
INNER JOIN Appointments a ON mr.AppointmentID = a.AppointmentID
INNER JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE mr.PatientID = 1
ORDER BY mr.RecordDate DESC;
```

### Query 3: Get Medications Expiring Soon
```sql
SELECT 
    MedicationName,
    StockQuantity,
    ExpiryDate,
    DATEDIFF(ExpiryDate, CURDATE()) AS DaysUntilExpiry
FROM Medications
WHERE ExpiryDate <= DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY ExpiryDate;
```

### Query 4: Calculate Total Revenue by Department
```sql
SELECT 
    dep.DepartmentName,
    COUNT(DISTINCT a.AppointmentID) AS TotalAppointments,
    SUM(b.TotalAmount) AS TotalRevenue,
    SUM(b.AmountPaid) AS TotalCollected,
    SUM(b.TotalAmount - b.AmountPaid) AS OutstandingAmount
FROM Departments dep
INNER JOIN Doctors d ON dep.DepartmentID = d.DepartmentID
INNER JOIN Appointments a ON d.DoctorID = a.DoctorID
LEFT JOIN Billing b ON a.AppointmentID = b.AppointmentID
GROUP BY dep.DepartmentID, dep.DepartmentName
ORDER BY TotalRevenue DESC;
```

### Query 5: Find Available Rooms
```sql
SELECT 
    RoomNumber,
    RoomType,
    Capacity,
    (Capacity - CurrentOccupancy) AS AvailableBeds,
    DailyRate
FROM Rooms
WHERE Status = 'Available' 
  AND CurrentOccupancy < Capacity
ORDER BY RoomType, RoomNumber;
```

### Query 6: Get Prescription Details with Medications
```sql
SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    pr.PrescriptionDate,
    m.MedicationName,
    pd.Dosage,
    pd.Frequency,
    pd.Duration,
    pd.Quantity
FROM Prescriptions pr
INNER JOIN PrescriptionDetails pd ON pr.PrescriptionID = pd.PrescriptionID
INNER JOIN Medications m ON pd.MedicationID = m.MedicationID
INNER JOIN MedicalRecords mr ON pr.RecordID = mr.RecordID
INNER JOIN Patients p ON mr.PatientID = p.PatientID
WHERE p.PatientID = 1
ORDER BY pr.PrescriptionDate DESC;
```

---

## 🔒 Security Features

### Data Protection Measures:
1. **Referential Integrity** - Foreign key constraints prevent orphaned records
2. **Data Validation** - CHECK constraints ensure data quality
3. **Unique Constraints** - Prevent duplicate critical information
4. **Cascading Operations** - Automatic cleanup of related data
5. **NOT NULL Constraints** - Ensure required fields are populated

### Recommended Additional Security:
- Implement role-based access control (RBAC)
- Encrypt sensitive patient data
- Use SSL/TLS for database connections
- Implement audit logging for all data modifications
- Regular database backups
- Implement password policies for user accounts

---

## 🚧 Future Enhancements

### Planned Features:
1. **Laboratory Management** - Track lab tests and results
2. **Radiology Module** - Manage X-rays, MRIs, and other imaging
3. **Surgery Scheduling** - Operating room and surgery management
4. **Pharmacy Integration** - Direct integration with pharmacy systems
5. **Insurance Claims** - Automated insurance claim processing
6. **Telemedicine** - Virtual consultation support
7. **Mobile App Integration** - Patient portal and mobile access
8. **Analytics Dashboard** - Real-time reporting and analytics
9. **Audit Trail** - Comprehensive logging of all database operations
10. **Document Management** - Store and retrieve medical documents

### Technical Improvements:
- Implement stored procedures for complex operations
- Create views for frequently used queries
- Add triggers for automated business logic
- Implement full-text search for medical records
- Add data archiving for historical records
- Optimize indexes based on query patterns

---

## 👥 Contributors

**Project Lead:** [Your Name]  
**Student ID:** [Your ID]  
**Course:** Database Management Systems  
**Institution:** [Your Institution]  
**Date:** October 4, 2025

### Special Thanks:
- Course instructor and teaching assistants
- MySQL documentation team
- Healthcare professionals who provided domain expertise

---

## 📄 License

This project is created for educational purposes as part of a Database Management Systems course assignment.

**Usage Rights:**
- ✅ Free to use for educational purposes
- ✅ Can be modified and extended for learning
- ✅ Can be used as a reference for similar projects
- ❌ Not licensed for commercial use without permission

---

## 📞 Support

For questions, issues, or suggestions:

- **Email:** [your.email@example.com]
- **GitHub Issues:** [repository-url]/issues
- **Documentation:** See inline comments in SQL file

---

## 📖 Additional Resources

### Recommended Reading:
- MySQL Official Documentation: https://dev.mysql.com/doc/
- Database Normalization Guide: https://www.guru99.com/database-normalization.html
- SQL Best Practices: https://www.sqlshack.com/sql-best-practices/

### Related Technologies:
- **Frontend:** React, Vue.js, or Angular for web interface
- **Backend:** Node.js, Python (Django/Flask), or Java (Spring Boot)
- **API:** RESTful API or GraphQL for data access
- **Reporting:** Power BI, Tableau, or custom reporting tools

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | Oct 4, 2025 | Initial release with core functionality |

---

## ⚠️ Disclaimer

This database system is designed for educational purposes and demonstration of database design principles. Before deploying in a production healthcare environment, ensure compliance with:

- HIPAA (Health Insurance Portability and Accountability Act) - USA
- GDPR (General Data Protection Regulation) - EU
- Local healthcare data protection regulations
- Hospital information security policies

**Always consult with healthcare IT professionals and legal advisors before implementing any patient data management system.**

---

**Made with ❤️ for Database Management Systems Course**
