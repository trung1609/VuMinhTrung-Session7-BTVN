-- Tạo bảng bệnh nhân
CREATE TABLE xuatsac2.patients (
                          patient_id SERIAL PRIMARY KEY,
                          full_name VARCHAR(100),
                          phone VARCHAR(20),
                          city VARCHAR(50),
                          symptoms TEXT[]
);

-- Tạo bảng bác sĩ
CREATE TABLE xuatsac2.doctors (
                         doctor_id SERIAL PRIMARY KEY,
                         full_name VARCHAR(100),
                         department VARCHAR(50)
);

-- Tạo bảng cuộc hẹn
CREATE TABLE xuatsac2.appointments (
                              appointment_id SERIAL PRIMARY KEY,
                              patient_id INT REFERENCES xuatsac2.patients(patient_id),
                              doctor_id INT REFERENCES xuatsac2.doctors(doctor_id),
                              appointment_date DATE,
                              diagnosis VARCHAR(200),
                              fee NUMERIC(10,2)
);

-- Thêm dữ liệu cho bảng patients
INSERT INTO xuatsac2.patients (full_name, phone, city, symptoms) VALUES
                                                            ('Nguyen Van A', '0912345678', 'Ha Noi', ARRAY['Ho', 'Sot']),
                                                            ('Tran Thi B', '0987654321', 'Da Nang', ARRAY['Dau dau', 'Met moi']),
                                                            ('Le Van C', '0905123456', 'Ho Chi Minh', ARRAY['Dau bung']),
                                                            ('Pham Thi D', '0933221100', 'Hai Phong', ARRAY['Mat ngu', 'Lo au']),
                                                            ('Do Van E', '0977332211', 'Can Tho', ARRAY['Dau hong', 'Ho kho']);

-- Thêm dữ liệu cho bảng doctors
INSERT INTO xuatsac2.doctors (full_name, department) VALUES
                                                ('Dr. Nguyen Thanh', 'Noi Tong Hop'),
                                                ('Dr. Tran Minh', 'Tim Mach'),
                                                ('Dr. Le Hong', 'Nhi Khoa'),
                                                ('Dr. Pham Duc', 'Tai Mui Hong'),
                                                ('Dr. Do Thi', 'Than Kinh');

-- Thêm dữ liệu cho bảng appointments (10 cuộc hẹn)
INSERT INTO xuatsac2.appointments (patient_id, doctor_id, appointment_date, diagnosis, fee) VALUES
                                                                                       (1, 1, '2025-11-01', 'Cam cum nhe', 150000.00),
                                                                                       (1, 2, '2025-11-05', 'Kiem tra huyet ap', 200000.00),
                                                                                       (2, 3, '2025-11-03', 'Sot virus', 180000.00),
                                                                                       (2, 5, '2025-11-06', 'Mat ngu keo dai', 220000.00),
                                                                                       (3, 4, '2025-11-02', 'Dau hong', 160000.00),
                                                                                       (3, 1, '2025-11-08', 'Kham dinh ky', 250000.00),
                                                                                       (4, 5, '2025-11-09', 'Roi loan giac ngu', 230000.00),
                                                                                       (5, 4, '2025-11-04', 'Viêm họng cấp', 170000.00),
                                                                                       (5, 2, '2025-11-07', 'Kiem tra tim mach', 210000.00),
                                                                                       (4, 3, '2025-11-10', 'Sot cao', 190000.00);


create index idx_patient_phone on xuatsac2.patients(phone);
create index idx_patient_city on xuatsac2.patients using hash(city);
create index idx_patient_symptons on xuatsac2.patients using gin(symptoms);
create index idx_appointment_date on xuatsac2.appointments using gist(appointment_date);

CREATE INDEX idx_appointment_date ON xuatsac2.appointments(appointment_date);

CLUSTER xuatsac2.appointments USING xuatsac2.idx_appointment_date;

ALTER TABLE xuatsac2.appointments CLUSTER ON xuatsac2.idx_appointment_date;

SELECT p.patient_id, p.full_name, SUM(a.fee) AS total_fee
FROM xuatsac2.patients p
         JOIN xuatsac2.appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.full_name
ORDER BY total_fee DESC
LIMIT 3;

SELECT d.doctor_id, d.full_name, COUNT(a.appointment_id) AS total_appointments
FROM xuatsac2.doctors d
         LEFT JOIN xuatsac2.appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.full_name
ORDER BY total_appointments DESC;
