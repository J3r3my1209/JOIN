create database DEBER;
USE DEBER;
-- ============================
-- CREACIÓN DE TABLAS
-- ============================

-- Pacientes
CREATE TABLE Pacientes (
    id_paciente INT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Consultas
CREATE TABLE Consultas (
    id_consulta INT PRIMARY KEY,
    id_paciente INT,
    id_doctor INT,
    fecha DATE,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente)
);

-- Doctores
CREATE TABLE Doctores (
    id_doctor INT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Medicamentos
CREATE TABLE Medicamentos (
    id_medicamento INT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Recetas (relaciona pacientes y medicamentos)
CREATE TABLE Recetas (
    id_receta INT PRIMARY KEY,
    id_paciente INT,
    id_medicamento INT,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento)
);

-- ============================
-- INSERCIÓN DE DATOS
-- ============================

-- Pacientes
INSERT INTO Pacientes (id_paciente, nombre) VALUES
(1, 'Ana Torres'),
(2, 'Luis Pérez'),
(3, 'Marta López'),
(4, 'Carlos Ríos');

-- Doctores
INSERT INTO Doctores (id_doctor, nombre) VALUES
(10, 'Dra. Gómez'),
(11, 'Dr. Salazar'),
(12, 'Dra. Zambrano');

-- Consultas
INSERT INTO Consultas (id_consulta, id_paciente, id_doctor, fecha) VALUES
(100, 1, 10, '2025-05-01'),
(101, 2, 11, '2025-05-03'),
(102, NULL, 10, '2025-05-05'), -- Consulta sin paciente
(103, 1, NULL, '2025-05-06'), -- Consulta sin doctor
(104, NULL, NULL, '2025-05-07'); -- Consulta sin paciente ni doctor

-- Medicamentos
INSERT INTO Medicamentos (id_medicamento, nombre) VALUES
(201, 'Paracetamol'),
(202, 'Ibuprofeno'),
(203, 'Amoxicilina'),
(204, 'Omeprazol');

-- Recetas
INSERT INTO Recetas (id_receta, id_paciente, id_medicamento) VALUES
(301, 1, 201),
(302, 2, 202),
(303, 2, 203);
-- Paciente 3 y 4 no tienen medicamentos
-- Medicamento 204 no ha sido recetado

-- ============================
-- CONSULTAS JOIN
-- ============================

-- 🟢 INNER JOIN - Pacientes con Consultas
SELECT p.id_paciente, p.nombre, c.id_consulta, c.fecha
FROM Pacientes p
INNER JOIN Consultas c ON p.id_paciente = c.id_paciente;

-- 🟡 LEFT JOIN - Todos los Pacientes (aunque no tengan consultas)
SELECT p.id_paciente, p.nombre, c.id_consulta, c.fecha
FROM Pacientes p
LEFT JOIN Consultas c ON p.id_paciente = c.id_paciente;

-- 🔵 RIGHT JOIN - Todas las Consultas (aunque no tengan paciente)
SELECT p.id_paciente, p.nombre, c.id_consulta, c.fecha
FROM Pacientes p
RIGHT JOIN Consultas c ON p.id_paciente = c.id_paciente;

-- 🔴 FULL OUTER JOIN - Todos los pacientes y consultas
SELECT p.id_paciente, p.nombre, c.id_consulta, c.fecha
FROM Pacientes p
LEFT JOIN Consultas c ON p.id_paciente = c.id_paciente
UNION
SELECT p.id_paciente, p.nombre, c.id_consulta, c.fecha
FROM Pacientes p
RIGHT JOIN Consultas c ON p.id_paciente = c.id_paciente;

-- ============================================
-- JOIN entre CONSULTAS y DOCTORES
-- ============================================

-- 🟢 INNER JOIN - Consultas con doctor asignado
SELECT c.id_consulta, d.nombre AS doctor, c.fecha
FROM Consultas c
INNER JOIN Doctores d ON c.id_doctor = d.id_doctor;

-- 🟡 LEFT JOIN - Todas las consultas, incluso sin doctor
SELECT c.id_consulta, d.nombre AS doctor, c.fecha
FROM Consultas c
LEFT JOIN Doctores d ON c.id_doctor = d.id_doctor;

-- 🔵 RIGHT JOIN - Todos los doctores, incluso si no tienen consultas
SELECT c.id_consulta, d.nombre AS doctor, c.fecha
FROM Consultas c
RIGHT JOIN Doctores d ON c.id_doctor = d.id_doctor;

-- 🔴 FULL OUTER JOIN - Todas las consultas y doctores
SELECT c.id_consulta, d.nombre AS doctor, c.fecha
FROM Consultas c
LEFT JOIN Doctores d ON c.id_doctor = d.id_doctor
UNION
SELECT c.id_consulta, d.nombre AS doctor, c.fecha
FROM Consultas c
RIGHT JOIN Doctores d ON c.id_doctor = d.id_doctor;

-- ============================================
-- JOIN entre PACIENTES y MEDICAMENTOS (Recetas)
-- ============================================

-- 🟢 INNER JOIN - Pacientes que han recibido medicamentos
SELECT p.nombre AS paciente, m.nombre AS medicamento
FROM Recetas r
INNER JOIN Pacientes p ON r.id_paciente = p.id_paciente
INNER JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento;


-- 🟡 LEFT JOIN - Todos los pacientes, incluso los que no han recibido medicamentos
SELECT p.nombre AS paciente, m.nombre AS medicamento
FROM Pacientes p
LEFT JOIN Recetas r ON p.id_paciente = r.id_paciente
LEFT JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento;

-- 🔵 RIGHT JOIN - Todos los medicamentos, incluso los que no han sido recetados
SELECT p.nombre AS paciente, m.nombre AS medicamento
FROM Recetas r
RIGHT JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento
LEFT JOIN Pacientes p ON r.id_paciente = p.id_paciente;

-- 🔴 FULL OUTER JOIN - Todos los pacientes y medicamentos
SELECT p.nombre AS paciente, m.nombre AS medicamento
FROM Pacientes p
LEFT JOIN Recetas r ON p.id_paciente = r.id_paciente
LEFT JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento
UNION
SELECT p.nombre AS paciente, m.nombre AS medicamento
FROM Medicamentos m
LEFT JOIN Recetas r ON m.id_medicamento = r.id_medicamento
LEFT JOIN Pacientes p ON r.id_paciente = p.id_paciente;
